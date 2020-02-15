package models

// QRCode 二维码
type QRCode struct {
	Common
	Data Data `json:"data"`
}

// Data 二维码数据
type Data struct {
	URL      string `json:"url"`
	OauthKey string `json:"oauthKey"`
}

// CheckLogin 检查登陆
type CheckLogin struct {
	Common
	Data interface{} `json:"data"`
}
