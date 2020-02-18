package internal

import "bililive-go/internal/api/models"

func init() {
	RegisterQmlInfomation("Server", 1, 0, "Infomation")
	RegisterQmlLogin("Server", 1, 0, "Login")
}

var (
	user models.UserData2
)

// BackEndError 错误信息
type BackEndError struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
}

// UserDisplay 用于展示的用户信息
type UserDisplay struct {
	Uname      string `json:"uname"`
	UID        int    `json:"uid"`
	Fans       int    `json:"fans"`
	Avator     string `json:"avator"`
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
	ID       int    `json:"id"`
	ParentID int    `json:"parent_id"`
	Name     string `json:"name"`
}
