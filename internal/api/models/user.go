package models

// UserLevel 用户等级信息
type UserLevel struct {
	CurrentExp   int `json:"current_exp"`
	CurrentLevel int `json:"current_level"`
	CurrentMin   int `json:"current_min"`
	NextExp      int `json:"next_exp"`
}

// UserData 用户数据
type UserData struct {
	LevelInfo    UserLevel `json:"level_info"`
	BCoins       int       `json:"bCoins"`
	Coins        float64   `json:"coins"`
	Face         string    `json:"face"`
	Nameplate    string    `json:"nameplate_current"`
	Official     int       `json:"official_verify"`
	Pendant      string    `json:"pendant_current"`
	PointBalance int       `json:"pointBalance"`
	Uname        string    `json:"uname"`
	UserStatus   string    `json:"userStatus"`
	VipStatus    int       `json:"vipStatus"`
	VipType      int       `json:"vipType"`
}

// User 用户信息模型
type User struct {
	Common
	Data UserData `json:"data"`
}
