package utils

import (
	"os"
)

// Mkdir 创建文件夹
func Mkdir(dir string) error {
	_, err := os.Stat(dir)
	if os.IsNotExist(err) {
		return os.Mkdir(dir, os.ModePerm)
	} else if os.IsExist(err) {
		return nil
	}
	return err
}

// MkdirInChain 链式创建文件夹
func MkdirInChain(dir ...string) error {
	path := ""
	for _, name := range dir {
		path += name
		if err := Mkdir(path); err != nil {
			return err
		}
		path += "/"
	}
	return nil
}
