package internal

func init() {
	RegisterQmlInfomation("Server", 1, 0, "Infomation")
	RegisterQmlLogin("Server", 1, 0, "Login")
}

// BackEndError 错误信息
type BackEndError struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
}
