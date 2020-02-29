package internal

import (
	"bililive-go/internal/api"
	"bililive-go/log"
	"bililive-go/utils"
	"strconv"

	"github.com/go-qamel/qamel"
)

// Send is the Send danmaku bind of qml
type Send struct {
	qamel.QmlObject

	_ func(string) `slot:"send"`
	_ func(string) `slot:"change"`

	_ func() `signal:"changeError"`
	_ func() `signal:"changeSuccess"`

	_ func(string) `signal:"error"`
	_ func(string) `signal:"response"`
}

func (send Send) change(id string) {
	tmp, err := strconv.Atoi(id)
	if err != nil {
		send.changeError()
		log.Error(err.Error())
	} else {
		roomid = tmp
		send.changeSuccess()
	}
}

func (send Send) send(content string) {
	res, err := api.SendDanmaku(content, roomid, 16777215, 25)
	if err != nil {
		e, _ := utils.EncodeJSON(BackEndError{
			Code:    -1,
			Message: err.Error(),
		})
		send.error(e)
	} else {
		res, _ := utils.EncodeJSON(BackEndError{
			Code:    res.Code,
			Message: res.Message,
		})
		send.response(res)
	}
}
