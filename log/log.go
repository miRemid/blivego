package log

import (
	"bililive-go/utils"
	"fmt"
	"io"
	"log"
	"os"

	"github.com/fatih/color"
)

var (
	logger *log.Logger

	// Color 是否开启颜色
	Color bool
	// Terminal 是否开启控制台输出
	Terminal bool
)

func init() {
	Color = true
	Terminal = true
	logger = &log.Logger{}
	Setup()
}

// Setup 设置logger
func Setup() {
	utils.Mkdir("log")
	file, err := os.OpenFile("log/bililive.log", os.O_CREATE|os.O_APPEND|os.O_RDWR, os.ModePerm)
	if err != nil {
		panic(err)
	}
	logger.SetPrefix("Blive-Go")
	logger.SetFlags(log.Ldate | log.Ltime)
	if Terminal {
		logger.SetOutput(io.MultiWriter(os.Stdout, file))
	} else {
		logger.SetOutput(file)
	}
}

// Print 打印信息
func Print(argv ...interface{}) {
	logger.Print(argv...)
}

// Printf 格式化打印
func Printf(format string, argv ...interface{}) {
	logger.Printf(format, argv...)
}

// Fatal panic输出
func Fatal(argv ...interface{}) {
	logger.Fatal(argv...)
}

// Info 普通消息
func Info(format string, argv ...interface{}) {
	msg := fmt.Sprintf("[i] "+format, argv...)
	if Color {
		Print(color.WhiteString(msg))
	} else {
		Print(msg)
	}
}

// Debug Debug消息
func Debug(format string, argv ...interface{}) {
	msg := fmt.Sprintf("[Debug] "+format, argv...)
	if Color {
		Print(color.GreenString(msg))
	} else {
		Print(msg)
	}
}

// Error Error消息
func Error(format string, argv ...interface{}) {
	msg := fmt.Sprintf("[E] "+format, argv...)
	if Color {
		Print(color.RedString(msg))
	} else {
		Print(msg)
	}
}

// Warning 警告消息
func Warning(format string, argv ...interface{}) {
	msg := fmt.Sprintf("[W] "+format, argv...)
	if Color {
		Print(color.GreenString(msg))
	} else {
		Print(msg)
	}
}
