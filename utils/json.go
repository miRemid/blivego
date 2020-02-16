package utils

import "encoding/json"

// EncodeJSON 生成字符串json
func EncodeJSON(data interface{}) (string, error) {
	str, err := json.Marshal(data)
	return string(str), err
}
