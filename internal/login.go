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
	_ func() `slot:"checkCookies"`
	_ func() `slog:"getInfomation"`

	// 二维码获取错误信号
	_ func(string) `signal:"qrcodeError"`
	// 二维码获取成功信号
	_ func(string) `signal:"qrcodeSuccess"`
	// 二维码过时信号
	_ func() `signal:"qrcodeObsolete"`
	// 等待手机确认信号
	_ func() `signal:"qrcodeScan"`
	// 登陆信号
	_ func() `signal:"login"`
	// cookies无效信号
	_ func() `signal:"cookieObsolete"`
}

func (info Login) checkObsolete(oauth string) {
	select {
	case <-time.After(time.Second * time.Duration(5)):
		for {
			check, err := api.CheckLogin(oauth)
			if err != nil {
				log.Error(err.Error())
				goto next
			}
			log.Info("%v", check.Status)
			if check.Status {
				info.login()
				if err := api.SaveCookies(); err != nil {
					log.Error(err.Error())
				}
				goto exit
			}
			if stat, ok := check.Data.(float64); ok {
				switch int(stat) {
				case api.TimeoutOrNotMatch:
					info.qrcodeObsolete()
					goto exit
				case api.NotConfirm:
					info.qrcodeScan()
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

func (info Login) getQRCode() {
	log.Print("请求二维码API")
	qr, err := api.GetQRCode(path)
	if err != nil {
		// 二维码获取失败
		log.Error("二维码请求失败")
		info.qrcodeError(err.Error())
		return
	}
	// 二维码获取成功，路径为static/image
	dir, err := filepath.Abs(filepath.Dir(os.Args[0]))
	if err != nil {
		log.Error(err.Error())
		info.qrcodeError(err.Error())
	}
	info.qrcodeSuccess(dir + "/" + path)
	log.Print("开始监听登陆状态")
	go info.checkObsolete(qr.Data.OauthKey)
}

func (info Login) checkCookies() {
	avalible, err := api.CheckCookies()
	if err != nil {
		log.Error(err.Error())
		info.cookieObsolete()
	}
	log.Print(avalible)
	if !avalible {
		info.cookieObsolete()
	}
}

func (info Login) getInfomation() {

}
