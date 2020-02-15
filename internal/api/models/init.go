package models

// Common 通用结构
type Common struct {
	Code    int         `json:"code"`
	Status  bool        `json:"status"`
	Data    interface{} `json:"data"`
	Ts      int         `json:"ts,omitempty"`
	Message string      `json:"message,omitempty"`
}
