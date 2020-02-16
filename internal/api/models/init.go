package models

// Common 通用结构
type Common struct {
	Code    int         `json:"code,omitempty"`
	Status  bool        `json:"status,omitempty"`
	Data    interface{} `json:"data,omitempty"`
	Ts      int         `json:"ts,omitempty"`
	Message string      `json:"message,omitempty"`
}
