package config

import (
	"bililive-go/utils"
)

func init() {
	Setup()
}

// Setup will create the template json config file
// create static directory
// create log directory
func Setup() {
	utils.MkdirInChain("static", "image")
	utils.MkdirInChain("static", "user")
}
