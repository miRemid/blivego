package api

import (
	"bililive-go/utils"
	"log"
	"os"
	"testing"
	"time"
)

func testGetQRCode() {
	utils.MkdirInChain("static", "image")
	qrcode, err := GetQRCode("static/image/login.png")
	if err != nil {
		log.Println(err)
	}
	select {
	case <-time.After(time.Second * time.Duration(10)):
		for {
			check, err := CheckLogin(qrcode.Data.OauthKey)
			if err != nil {
				log.Println(err)
				goto next
			}
			if stat, ok := check.Data.(float64); ok {
				switch int(stat) {
				case TimeoutOrNotMatch:
					log.Println("二维码过期")
					os.Exit(0)
				case NotScan:
					log.Println("请扫描二维码")
					break
				case NotConfirm:
					log.Println("请在手机上确认")
					break
				}
			}
			if check.Status {
				log.Println("登陆成功")
				if err := SaveCookies(); err != nil {
					log.Fatal(err)
				}
				SetCSRF()
				goto getInfo
			}
		next:
			select {
			case <-time.After(time.Second * time.Duration(5)):
				continue
			}
		}
	}
getInfo:
}

func testCheckCookies(t *testing.T) {
	log.Println("TestCheckCookies")
	info, err := GetPersonInfomation()
	if err != nil {
		log.Fatal(err)
	}
	log.Println(info)
}

func TestLoadCookies(t *testing.T) {
	if err := loadCookies(); err != nil {
		if os.IsNotExist(err) {
			testGetQRCode()
			goto getInfo
		}
		log.Fatal(err)
	}
getInfo:
	log.Println("csrf=", CSRF)
	log.Println("sessionid=", SessionID)
	info, err := GetPersonInfomation()
	if err != nil {
		log.Fatal(err)
	}
	if info.Code == 0 {
		log.Println(info.Data.Uname)
	} else {
		log.Fatal(info.Message)
	}
	if response, err := SendDanmaku("test", 56159, 16777215, 25); err != nil {
		log.Fatal(err)
	} else {
		log.Println(response)
	}
}
