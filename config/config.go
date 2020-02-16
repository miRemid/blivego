package config

import (
	"bililive-go/utils"
)

// create the template json config file
// create static directory
// create log directory
func init() {
	utils.MkdirInChain("static", "image")
	utils.MkdirInChain("static", "user")
}
