package internal

import (
	"bytes"
	"encoding/binary"
	"encoding/json"
	"fmt"

	"github.com/go-qamel/qamel"
	"github.com/miRemid/danmagu"
	"github.com/miRemid/danmagu/model"

	"bililive-go/internal/api"
	"bililive-go/utils"
)

// Websocket is the websocket bind of qml
type Websocket struct {
	qamel.QmlObject

	_ func() `slot:"start"`

	_ func(string) `signal:"message"`
	_ func(string) `signal:"danmaku"`
	_ func(string) `signal:"hot"`
}

func (websocket *Websocket) parse(message []byte) {
	h := message[:16]
	var head model.RHeader
	buf := bytes.NewReader(h)
	binary.Read(buf, binary.BigEndian, &head)
	body := message[16:head.Length]
	switch head.Type {
	case danmagu.WsHeartbeatReply:
		var rqz model.Population
		binary.Read(bytes.NewReader(body), binary.BigEndian, &rqz)
		websocket.hot(fmt.Sprintf("%v", rqz.Value))
		break
	case danmagu.WsMessage:
		var cmd model.CMD
		_ = json.Unmarshal(body, &cmd)
		switch cmd.Cmd {
		case "DANMU_MSG":
			var danmaku model.Danmaku
			json.Unmarshal(body, &danmaku)
			v, ok := cmd.Info[2][0].(float64)
			if !ok {
				websocket.message("interface assert failed")
				return
			}
			res, err := api.GetUserInfomation(int(v))
			if err != nil {
				e, _ := utils.EncodeJSON(BackEndError{
					Code:    -1,
					Message: err.Error(),
				})
				websocket.message(e)
				return
			}
			str, err := utils.EncodeJSON(WebsocketMessage{
				Uname:   cmd.Info[2][1],
				Face:    res.Data.Face,
				Message: danmaku.Info[1],
				Gift:    false,
			})
			if err != nil {
				e, _ := utils.EncodeJSON(BackEndError{
					Code:    -1,
					Message: err.Error(),
				})
				websocket.message(e)
			} else {
				websocket.danmaku(str)
			}
			break
		case "SEND_GIFT":
			var g model.Gift
			json.Unmarshal(body, &g)
			str, _ := utils.EncodeJSON(WebsocketMessage{
				Uname:   g.Data.Uname,
				Face:    g.Data.Face,
				Message: fmt.Sprintf("%s (%s) x %d", g.Data.GiftName, g.Data.CoinType, g.Data.Num),
				Gift:    true,
				Number:  g.Data.Num,
			})
			websocket.danmaku(str)
			break
		case "GUARD_BUY":
			var g model.Guard
			json.Unmarshal(body, &g)
			res, err := api.GetUserInfomation(int(g.Data.UID))
			if err != nil {
				return
			}
			str, _ := utils.EncodeJSON(WebsocketMessage{
				Uname:   g.Data.Username,
				Message: fmt.Sprintf("%s (%s) x %d", g.Data.GiftName, "gold", g.Data.Num),
				Face:    res.Data.Face,
			})
			websocket.danmaku(str)
			break
		}
		break
	}
	next := message[head.Length:]
	if binary.Size(next) != 0 {
		websocket.parse(next)
	}
}

func (websocket *Websocket) start() {
	go func() {
		client := danmagu.NewClient(0)
		client.DebugMode = false
		client.Enter(roomid)
		client.OnMessage(websocket.parse)
		client.Listen(30)
	}()
}
