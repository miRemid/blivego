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

func testLoadCookies(t *testing.T) {
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

func TestRoom(t *testing.T) {
	room, err := GetLiveRoomInfo(525826)
	if err != nil {
		log.Fatal(err)
	}
	log.Println(room.Code)
	log.Println(room.Message)
	log.Println(room.Data.Roomid)
}

func TestGetFollow(t *testing.T) {
	if err := loadCookies(); err != nil {
		if os.IsNotExist(err) {
			testGetQRCode()
			goto getInfo
		}
		log.Fatal(err)
	}
getInfo:
	flo, err := GetFollow()
	if err != nil {
		log.Fatal(err)
	}
	log.Println(flo.Code)
	log.Println(flo.Message)
	log.Println(flo.Data.Follower)
}

func TestStartLive(t *testing.T) {
	if err := loadCookies(); err != nil {
		if os.IsNotExist(err) {
			testGetQRCode()
			goto getInfo
		}
		log.Fatal(err)
	}
getInfo:
	res, err := StartLive(56159, "107")
	if err != nil {
		log.Fatal(err)
	}
	log.Println(res.Message)
	log.Println(res.Code)
	log.Println(res.Data.Rtmp.Addr)
}

func TestStopLive(t *testing.T) {
	if err := loadCookies(); err != nil {
		if os.IsNotExist(err) {
			testGetQRCode()
			goto getInfo
		}
		log.Fatal(err)
	}
getInfo:
	res, err := StopLive(56159)
	if err != nil {
		log.Fatal(err)
	}
	log.Println(res.Message)
	log.Println(res.Code)
	log.Println(res.Data)
}

func TestUpdateTitle(t *testing.T) {
	if err := loadCookies(); err != nil {
		if os.IsNotExist(err) {
			testGetQRCode()
			goto getInfo
		}
		log.Fatal(err)
	}
getInfo:
	res, err := UpdateTitle(56159, "Test")
	if err != nil {
		log.Fatal(err)
	}
	log.Println(res.Message)
	log.Println(res.Code)
	log.Println(res.Data)
}

func TestSendDanmaku(t *testing.T) {
	if err := loadCookies(); err != nil {
		if os.IsNotExist(err) {
			testGetQRCode()
			goto getInfo
		}
		log.Fatal(err)
	}
getInfo:
	res, err := SendDanmaku("tset", 56159, 16777215, 25)
	if err != nil {
		log.Fatal(err)
	}
	log.Println(res.Code)
	log.Println(res.Message)
	log.Println(res.Data)
}

func TestGetInfomation(t *testing.T) {
	_, err := GetUserInfomation(525826)
	if err != nil {
		log.Fatal(err)
	}
}
