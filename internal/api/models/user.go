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

type FullUserInfomation struct {
	Common
	Data UserData2 `json:"data"`
}

type LevelInfo struct {
	CurrentLevel int `json:"current_level"`
	CurrentMin   int `json:"current_min"`
	CurrentExp   int `json:"current_exp"`
	NextExp      int `json:"next_exp"`
}

type Official struct {
	Role  int    `json:"role"`
	Title string `json:"title"`
	Desc  string `json:"desc"`
	Type  int    `json:"type"`
}

type OfficialVerify struct {
	Type int    `json:"type"`
	Desc string `json:"desc"`
}

type Pendant struct {
	Pid    int    `json:"pid"`
	Name   string `json:"name"`
	Image  string `json:"image"`
	Expire int    `json:"expire"`
}

type Wallet struct {
	Mid           int `json:"mid"`
	BcoinBalance  int `json:"bcoin_balance"`
	CouponBalance int `json:"coupon_balance"`
	CouponDueTime int `json:"coupon_due_time"`
}

type UserData2 struct {
	IsLogin        bool           `json:"isLogin"`
	EmailVerified  int            `json:"email_verified"`
	Face           string         `json:"face"`
	LevelInfo      LevelInfo      `json:"level_info"`
	Mid            int            `json:"mid"`
	MobileVerified int            `json:"mobile_verified"`
	Money          float64        `json:"money"`
	Moral          int            `json:"moral"`
	Official       Official       `json:"official"`
	OfficialVerify OfficialVerify `json:"officialVerify"`
	Pendant        Pendant        `json:"pendant"`
	Scores         int            `json:"scores"`
	Uname          string         `json:"uname"`
	VipDueDate     int            `json:"vipDueDate"`
	VipStatus      int            `json:"vipStatus"`
	VipType        int            `json:"vipType"`
	VipPayType     int            `json:"vip_pay_type"`
	VipThemeType   int            `json:"vip_theme_type"`
	Wallet         Wallet         `json:"wallet"`
	HasShop        bool           `json:"has_shop"`
	ShopURL        string         `json:"shop_url"`
	AllowanceCount int            `json:"allowance_count"`
	AnswerStatus   int            `json:"answer_status"`
}

type LiveRoom struct {
	Common
	Data LiveRoomData `json:"data"`
}

type LiveRoomData struct {
	RoomStatus    int    `json:"roomStatus"`
	RoundStatus   int    `json:"roundStatus"`
	LiveStatus    int    `json:"liveStatus"`
	URL           string `json:"url"`
	Title         string `json:"title"`
	Cover         string `json:"cover"`
	Online        int    `json:"online"`
	Roomid        int    `json:"roomid"`
	BroadcastType int    `json:"broadcast_type"`
	OnlineHidden  int    `json:"online_hidden"`
}

type Follow struct {
	Common
	Data FollowData `json:"data"`
}

type FollowData struct {
	Following    int `json:"following"`
	Follower     int `json:"follower"`
	DynamicCount int `json:"dynamic_count"`
}
