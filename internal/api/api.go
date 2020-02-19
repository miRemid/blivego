package api

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"os"
	"strings"
	"time"

	"bililive-go/internal/api/models"
	"bililive-go/log"

	cookiejar "github.com/juju/persistent-cookiejar"
	qrcode "github.com/skip2/go-qrcode"
	"golang.org/x/net/publicsuffix"
)

const (
	// TimeoutOrNotMatch 二维码过期或未找到对应的二维码
	TimeoutOrNotMatch = -2
	// NotScan 未扫描二维码
	NotScan = -4
	// NotConfirm 未在手机上确认登陆
	NotConfirm = -5
)

const (
	qrcodeURL = "https://passport.bilibili.com/qrcode/getLoginUrl"
	checkURL  = "https://passport.bilibili.com/qrcode/getLoginInfo"

	userInfoURL = "https://api.bilibili.com/x/web-interface/nav"
	goURL       = "https://live.bilibili.com/"
	originURL   = "https://passport.bilibili.com"
	roomidURL   = "https://api.live.bilibili.com/room/v1/Room/getRoomInfoOld?mid=%d"
	followURL   = "https://api.bilibili.com/x/web-interface/nav/stat"

	cookiesPath = "static/user/cookies.json"

	liveDanmaURL = "https://api.live.bilibili.com/msg/send"
	liveList     = "https://api.live.bilibili.com/room/v1/Area/getList"
)

var (
	client *http.Client
	jar    *cookiejar.Jar

	// CSRF b站csrf跨域请求token，登陆时返回url可解析
	CSRF string
	// SessionID 登陆唯一标志
	SessionID string

	// Useful 作为往期cookies是否可用的标志
	Useful bool
)

func init() {
	if j, err := cookiejar.New(&cookiejar.Options{
		PublicSuffixList: publicsuffix.List,
		Filename:         cookiesPath,
	}); err != nil {
		log.Error(err.Error())
		os.Exit(0)
	} else {
		jar = j
	}

	// 导入往期cookies
	// 如果没有cookies或导入失败，则清除jar所有cookies
	if err := loadCookies(); err != nil {
		if os.IsNotExist(err) {
			log.Error("cookies文件未找到， %s", cookiesPath)
		} else {
			log.Error(err.Error())
		}
	}

	client = &http.Client{
		Timeout: time.Second * time.Duration(10),
		Jar:     jar,
	}
}

// 保存cookies到文件中
func loadCookies() error {
	var cookies = make([]*http.Cookie, 0)
	data, err := ioutil.ReadFile(cookiesPath)
	if err != nil {
		return err
	}
	if err := json.Unmarshal(data, &cookies); err != nil {
		return err
	}
	u, err := url.Parse(originURL)
	if err != nil {
		return err
	}
	// 1. 设置cookies
	jar.SetCookies(u, cookies)
	// 2. 获取cookie信息
	SetCSRF()
	return nil
}

// SetCSRF 保存相应信息
func SetCSRF() {
	cookies := jar.AllCookies()
	for _, cookie := range cookies {
		if cookie.Name == "bili_jct" {
			CSRF = cookie.Value
		} else if cookie.Name == "SESSDATA" {
			SessionID = cookie.Value
		}
	}
}

// GetQRCode this will send a qrcode request and save the qrcode into the file at the static directory
func GetQRCode(filepath string) (models.QRCode, error) {
	var qr models.QRCode
	req, _ := http.NewRequest("GET", qrcodeURL, nil)
	resp, err := client.Do(req)
	if err != nil {
		return qr, err
	}
	defer resp.Body.Close()
	data, _ := ioutil.ReadAll(resp.Body)
	if err := json.Unmarshal(data, &qr); err != nil {
		return qr, err
	}
	err = qrcode.WriteFile(qr.Data.URL, qrcode.Medium, 256, filepath)
	return qr, err
}

// CheckLogin 查询二维码登陆状态
func CheckLogin(oauth string) (models.CheckLogin, error) {
	var check models.CheckLogin
	data := url.Values{}
	data.Set("oauthKey", oauth)
	data.Set("gourl", goURL)
	req, err := http.NewRequest("POST", checkURL, strings.NewReader(data.Encode()))
	req.Header.Add("Content-Type", "application/x-www-form-urlencoded")
	req.Header.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36")
	req.Header.Add("Origin", originURL)
	req.Close = true
	if err != nil {
		return check, err
	}

	resp, err := client.Do(req)
	if err != nil {
		return check, err
	}
	defer resp.Body.Close()
	block, _ := ioutil.ReadAll(resp.Body)
	err = json.Unmarshal(block, &check)
	return check, err
}

// GetPersonInfomation 获取个人信息
func GetPersonInfomation() (models.FullUserInfomation, error) {
	var user models.FullUserInfomation
	req, _ := http.NewRequest("GET", userInfoURL, nil)
	req.Header.Add("Origin", "https://space.bilibili.com")
	req.Header.Add("User-Agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36")
	resp, err := client.Do(req)
	if err != nil {
		return user, err
	}
	defer resp.Body.Close()
	data, _ := ioutil.ReadAll(resp.Body)
	err = json.Unmarshal(data, &user)
	return user, err
}

// SaveCookies 保存cookies到文件中
func SaveCookies() error {
	return jar.Save()
}

// SendDanmaku 发送弹幕
func SendDanmaku(message string, roomid, color, fontsize int) (models.DanmakuResponse, error) {
	data := make(url.Values)
	data.Set("msg", message)
	data.Set("color", fmt.Sprintf("%d", color))
	data.Set("fontsize", fmt.Sprintf("%d", fontsize))
	data.Set("mode", "1")
	data.Set("rnd", fmt.Sprintf("%d", time.Now().Unix()))
	data.Set("roomid", fmt.Sprintf("%d", roomid))
	data.Set("bubble", "0")
	data.Set("csrf_token", CSRF)
	data.Set("csrf", CSRF)
	req, _ := http.NewRequest("POST", liveDanmaURL, strings.NewReader(data.Encode()))
	req.Header.Add("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
	req.Header.Add("Referer", fmt.Sprintf("https://live.bilibili.com/%d", roomid))
	req.Header.Add("Origin", "https://live.bilibili.com")
	req.Header.Add("Accept", "application/json, text/javascript, */*; q=0.01")
	req.Header.Add("Sec-Fetch-Mode", "cors")
	req.Header.Add("Sec-Fetch-Site", "same-site")
	req.Header.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36")
	var response models.DanmakuResponse
	resp, err := client.Do(req)
	if err != nil {
		return response, err
	}
	log.Debug("请求直播弹幕API:%s, 状态码:%d", liveDanmaURL, resp.StatusCode)
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)
	err = json.Unmarshal(body, &response)
	if response.Code == 0 {
		log.Debug("弹幕发送成功,Roomid=%d,Message=%s", roomid, message)
	} else {
		log.Warning("弹幕发送失败, Error=%s", response.Message)
	}
	return response, err
}

// GetLiveRoomInfo 获取直播间信息
func GetLiveRoomInfo(id int) (models.LiveRoom, error) {
	var live models.LiveRoom
	url := fmt.Sprintf(roomidURL, id)
	req, _ := http.NewRequest("GET", url, nil)
	req.Header.Add("Origin", "https://space.bilibili.com")
	req.Header.Add("User-Agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36")
	resp, err := client.Do(req)
	if err != nil {
		return live, err
	}
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)
	err = json.Unmarshal(body, &live)
	return live, err
}

// GetFollow 获取粉丝数
func GetFollow() (models.Follow, error) {
	var f models.Follow
	req, _ := http.NewRequest("GET", followURL, nil)
	req.Header.Add("Origin", "https://space.bilibili.com")
	req.Header.Add("User-Agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36")
	resp, err := client.Do(req)
	if err != nil {
		return f, err
	}
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)
	err = json.Unmarshal(body, &f)
	return f, err
}

// GetLiveList 获取直播分类表
func GetLiveList() (models.LiveItems, error) {
	var items models.LiveItems
	req, _ := http.NewRequest(http.MethodGet, liveList, nil)
	resp, err := client.Do(req)
	if err != nil {
		return items, err
	}
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)
	err = json.Unmarshal(body, &items)
	return items, err
}
