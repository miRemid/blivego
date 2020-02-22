package internal

import (
	"bililive-go/internal/api"
	"bililive-go/log"
	"bililive-go/utils"
	"time"

	"github.com/go-qamel/qamel"
)

const (
	apiError    = 0
	cookieError = 1
)

// Infomation 个人信息api
type Infomation struct {
	qamel.QmlObject

	_ func() `slot:"getInfomation"`

	// 获取个人信息成功
	_ func(string) `signal:"success"`

	// 获取个人信息失败
	_ func(string) `signal:"error"`
}

func (info Infomation) init() {
	go info.getInfomation()
}

func (info Infomation) getInfomation() {
	for {
		infomation, err := api.GetPersonInfomation()
		if err != nil {
			log.Error(err.Error())
			e, _ := utils.EncodeJSON(BackEndError{
				Code:    apiError,
				Message: err.Error(),
			})
			info.error(e)
			select {
			case <-time.After(time.Second):
				continue
			}
		}
		if infomation.Code != 0 {
			e, _ := utils.EncodeJSON(BackEndError{
				Code:    cookieError,
				Message: "cookies失效，请重新登陆",
			})
			info.error(e)
		} else {
			api.Useful = true
			go func() {
				// 保存用户信息
				user = infomation.Data
				// 返回用户信息用于展示
				var response UserDisplay
				response.Uname = user.Uname
				response.Avator = user.Face
				// 获取本人直播间信息
				if live, err := api.GetLiveRoomInfo(user.Wallet.Mid); err != nil {
					e, _ := utils.EncodeJSON(BackEndError{
						Code:    apiError,
						Message: err.Error(),
					})
					info.error(e)
				} else {
					response.Roomid = live.Data.Roomid
					response.RoomStatus = live.Data.RoomStatus
					response.RoomTitle = live.Data.Title
					roomid = live.Data.Roomid
				}
				// 获取本人粉丝数
				if stat, err := api.GetFollow(); err != nil {
					info.error(err.Error())
				} else {
					response.Fans = stat.Data.Follower
				}
				data, _ := utils.EncodeJSON(response)
				info.success(data)
				items, err := api.GetLiveList()
				if err != nil {
					log.Error(err.Error())
				}
				go saveLiveItems(items)
			}()
		}
		break
	}
}
