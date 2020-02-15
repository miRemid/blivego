package api

import (
	"encoding/json"
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

	userInfoURL = "https://account.bilibili.com/home/userInfo"
	goURL       = "https://live.bilibili.com/"
	originURL   = "https://passport.bilibili.com"

	cookiesPath = "static/user/cookies.json"
)

var (
	client *http.Client
	jar    *cookiejar.Jar

	// CSRF b站csrf跨域请求token，登陆时返回url可解析
	CSRF string
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
	Setup()
	client = &http.Client{
		Timeout: time.Second * time.Duration(10),
		Jar:     jar,
	}
}

// Setup 初始化操作
func Setup() {
	if err := loadCookies(); err != nil {
		if os.IsNotExist(err) {
			jar.RemoveAll()
			log.Error("cookies文件未找到， %s", cookiesPath)
		} else {
			log.Error(err.Error())
		}
	}
}

// CheckCookies 检查cookies是否有效
func CheckCookies() (bool, error) {
	info, err := GetPersonInfomation()
	if err != nil {
		return false, err
	}
	return info.Status, nil
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
func GetPersonInfomation() (models.User, error) {
	var user models.User
	req, err := http.NewRequest("GET", userInfoURL, nil)
	if err != nil {
		return user, err
	}
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
	jar.SetCookies(u, cookies)
	return nil
}
