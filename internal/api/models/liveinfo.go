package models

type LiveItems struct {
	Common
	Data []LiveItemsData `json:"data"`
}

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

type LiveItemsData struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
	List []Item `json:"list"`
}
