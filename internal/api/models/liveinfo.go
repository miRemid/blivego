package models

// LiveItems 直播分类列表
type LiveItems struct {
	Common
	Data []LiveItemsData `json:"data"`
}

// LiveItemsData 直播分类数据
type LiveItemsData struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
	List []Item `json:"list"`
}

// Item 直播分类实体
type Item struct {
	ID         string `json:"id"`
	ParentID   string `json:"parent_id"`
	OldAreaID  string `json:"old_area_id"`
	Name       string `json:"name"`
	ActID      string `json:"act_id"`
	PkStatus   string `json:"pk_status"`
	HotStatus  int    `json:"hot_status"`
	LockStatus string `json:"lock_status"`
	Pic        string `json:"pic"`
	ParentName string `json:"parent_name"`
	AreaType   int    `json:"area_type"`
}

// LiveRoom 直播间api
type LiveRoom struct {
	Common
	Data LiveRoomData `json:"data"`
}

// LiveRoomData 直播间信息数据
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
