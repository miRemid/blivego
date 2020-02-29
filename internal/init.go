package internal

import (
	"bililive-go/internal/api/models"
	"encoding/json"
	"io/ioutil"
	"os"
)

func init() {
	RegisterQmlInfomation("Server", 1, 0, "Infomation")
	RegisterQmlLogin("Server", 1, 0, "Login")
	RegisterQmlWebsocket("Server", 1, 0, "Websocket")
	RegisterQmlSend("Server", 1, 0, "Send")
}

var (
	user   models.UserData2
	roomid int
)

// BackEndError 错误信息
type BackEndError struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
}

// UserDisplay 用于展示的用户信息
type UserDisplay struct {
	Uname      string `json:"uname"`
	Fans       int    `json:"fans"`
	Avator     string `json:"avatar"`
	Roomid     int    `json:"roomid"`
	RoomStatus int    `json:"status"`
	RoomTitle  string `json:"title"`
}

// ItemList 分区表
type ItemList struct {
	ID    int    `json:"id"`
	Name  string `json:"name"`
	Items []Item `json:"item"`
}

// Item 分区信息
type Item struct {
	ID       string `json:"id"`
	ParentID string `json:"parent_id"`
	Name     string `json:"name"`
}

func saveLiveItems(lives models.LiveItems) error {
	var list = make([]ItemList, 0)
	l := lives.Data
	for _, v := range l {
		var tmp ItemList
		tmp.ID = v.ID
		tmp.Name = v.Name
		tmp.Items = make([]Item, 0)
		for _, value := range v.List {
			var item Item
			item.ID = value.ID
			item.ParentID = value.ParentID
			item.Name = value.Name
			tmp.Items = append(tmp.Items, item)
		}
		list = append(list, tmp)
	}
	data, _ := json.MarshalIndent(list, "", "\t")
	return ioutil.WriteFile("live.json", data, os.ModePerm)
}

// WebsocketMessage 直播信息
type WebsocketMessage struct {
	Uname   interface{} `json:"uname"`
	Face    interface{} `json:"face"`
	Message interface{} `json:"message"`
	Gift    bool        `json:"gift"`
	Number  int         `json:"num"`
}
