package models

// DanmakuResponse 发送弹幕返回信息
type DanmakuResponse struct {
	Common
	Msg string `json:"msg,omitempty"`
	TTL int    `json:"ttl,omitempty"`
}

type StartLive struct {
	Common
	Data StartLiveData `json:"data"`
}

type Rtmp struct {
	Addr     string `json:"addr"`
	Code     string `json:"code"`
	NewLink  string `json:"new_link"`
	Provider string `json:"provider"`
}

type Protocols struct {
	Protocol string `json:"protocol"`
	Addr     string `json:"addr"`
	Code     string `json:"code"`
	NewLink  string `json:"new_link"`
	Provider string `json:"provider"`
}

type Notice struct {
	Type       int    `json:"type"`
	Status     int    `json:"status"`
	Title      string `json:"title"`
	Msg        string `json:"msg"`
	ButtonText string `json:"button_text"`
	ButtonURL  string `json:"button_url"`
}

type StartLiveData struct {
	Change    int         `json:"change"`
	Status    string      `json:"status"`
	RoomType  int         `json:"room_type"`
	Rtmp      Rtmp        `json:"rtmp"`
	Protocols []Protocols `json:"protocols"`
	TryTime   string      `json:"try_time"`
	LiveKey   string      `json:"live_key"`
	Notice    Notice      `json:"notice"`
}

type StopLive struct {
	Common
	Data StopLiveData `json:"data"`
}

type StopLiveData struct {
	Change int    `json:"change"`
	Status string `json:"status"`
}
