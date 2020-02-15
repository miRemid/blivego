package main

import (
	"os"

	"github.com/go-qamel/qamel"

	_ "bililive-go/config"

	_ "bililive-go/log"

	_ "bililive-go/internal"
)

func main() {

	app := qamel.NewApplication(len(os.Args), os.Args)
	app.SetApplicationDisplayName("BiliLive-Go!")

	view := qamel.NewViewer()

	view.SetSource("qrc:/res/main.qml")
	view.SetResizeMode(qamel.SizeRootObjectToView)
	view.SetTitle("BiliLive-Go!")
	view.SetMaximumHeight(500)
	view.SetMaximumWidth(300)
	view.SetMinimumHeight(500)
	view.SetMinimumWidth(300)
	view.ShowNormal()

	app.Exec()
}
