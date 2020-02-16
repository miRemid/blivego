package internal

import (
	"bililive-go/internal/api"

	"bililive-go/log"

	"os"
	"path/filepath"
	"time"

	"github.com/go-qamel/qamel"
)

const (
	path = "static/image/login.png"
)

// Login is the backedn for person's login api
type Login struct {
	qamel.QmlObject

	_ func() `slot:"getQRCode"`

	// 二维码获取错误信号
	_ func() `signal:"qrcodeError"`
	// 二维码获取成功信号
	_ func(string) `signal:"qrcodeSuccess"`
	// 二维码过时信号
	_ func() `signal:"qrcodeObsolete"`
	// 等待手机确认信号
	_ func() `signal:"qrcodeScan"`
	// 登陆信号
	_ func() `signal:"login"`
}

func (login Login) checkObsolete(oauth string) {
	select {
	case <-time.After(time.Second * time.Duration(5)):
		for {
			check, err := api.CheckLogin(oauth)
			if err != nil {
				log.Error(err.Error())
				goto next
			}
			log.Debug("二维码状态: %v", check.Status)
			if check.Status {
				log.Debug("二维码登陆成功，正在保存cookies信息")
				login.login()
				if err := api.SaveCookies(); err != nil {
					log.Error(err.Error())
				}
				api.SetCSRF()
				goto exit
			}
			if stat, ok := check.Data.(float64); ok {
				switch int(stat) {
				case api.TimeoutOrNotMatch:
					log.Debug("二维码失效")
					login.qrcodeObsolete()
					goto exit
				case api.NotConfirm:
					log.Debug("二维码扫描成功，等待手机验证")
					login.qrcodeScan()
					goto next
				}
			}
		next:
			select {
			case <-time.After(time.Second * time.Duration(5)):
				continue
			}
		}
	}
exit:
}
func (login Login) getQRCode() {
	go func() {
		if api.Useful {
			return
		}
		log.Print("请求二维码API")
		qr, err := api.GetQRCode(path)
		if err != nil {
			// 二维码获取失败
			log.Error("二维码请求失败，%s", err.Error())
			login.qrcodeError()
			return
		}
		// 二维码获取成功，路径为static/image
		dir, err := filepath.Abs(filepath.Dir(os.Args[0]))
		if err != nil {
			log.Error(err.Error())
			login.qrcodeError()
		}
		login.qrcodeSuccess(dir + "/" + path)
		log.Print("开始监听登陆状态")
		go login.checkObsolete(qr.Data.OauthKey)
	}()
}
