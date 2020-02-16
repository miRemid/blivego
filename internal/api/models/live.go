package models

// DanmakuResponse 发送弹幕返回信息
type DanmakuResponse struct {
	Common
	Msg string `json:"msg,omitempty"`
	TTL int    `json:"ttl,omitempty"`
}
