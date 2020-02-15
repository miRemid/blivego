package utils

import (
	"log"
	"testing"
)

func TestMkdir(t *testing.T) {
	if err := Mkdir("static/image"); err != nil {
		log.Println(err)
	}
}
