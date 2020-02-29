package main

import (
	"os"

	_ "bililive-go/config"

	_ "bililive-go/log"

	_ "bililive-go/internal/api"

	_ "bililive-go/internal"

	"github.com/go-qamel/qamel"
)

func main() {

	app := qamel.NewApplication(len(os.Args), os.Args)
	app.SetApplicationDisplayName("BiliLive-Go!")
	app.SetWindowIcon(":/res/icon.png")

	engine := qamel.NewEngine()
	engine.Load("qrc:/res/main.qml")

	app.Exec()
}
