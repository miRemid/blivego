import QtQuick 2.12
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.0
import QtQuick.Window 2.12
import Server 1.0 as Server
import "fonts/FontAwesome" as FontAwesome
import "items" as Items

Rectangle {
    id: root
    
    width: 300
    height: 500

    property string avatarURL: "https://i.loli.net/2019/11/03/r7vSwJsUzfWxYmk.jpg"
    property string uname: "测试用户名"
    property int fans: 66
    property int roomid: 114154
    property Component danmakuComponent: null
    property var childWin: null

    color: "#e6f7ff"

    

    Server.Websocket {
        id: websocket
        visible: false
        onDanmaku: (msg) => {
            let data = JSON.parse(msg)
            if (data["gift"]) {
                gift.num = gift.num + data["num"]
            }else {
                danmaku.num = danmaku.num + 1
            }
            childWin.append(data)
        }
        onMessage: (msg) => {
            console.log(msg)
        }
        onHot: (msg) => {
            populate.num = Number(msg)
        }
    }

    Image {  
        id: rocket  
        fillMode: Image.TileHorizontally  
        smooth: true  
        source: 'bg.jpg'
        opacity: 0.1
    }

    // 头像
    Item {
        id: avatar
        width: 100
        height: 100

        anchors {
            horizontalCenter: root.horizontalCenter
            top: root.top
            topMargin: 50
        }
        
        Image {
            id: img
            cache: false
            asynchronous: true
            fillMode: Image.PreserveAspectCrop
            source: root.avatarURL
            sourceSize: Qt.size(avatar.width, avatar.height)
            anchors.fill: parent
            smooth: true
            visible: false            
        }
        Rectangle {
            id: mask
            smooth: true
            visible: false
            anchors.fill: parent
            radius: height / 2
        }

        OpacityMask {
            anchors.fill: img
            source: img
            maskSource: mask
            
        }
    }
    // 昵称
    Label {
        id: uname
        anchors {
            top: avatar.bottom
            topMargin: 10
            horizontalCenter: root.horizontalCenter
        }
        font {
            pixelSize: 20
        }
        color: "#004d73"
        text: root.uname
    }  

    // 粉丝数
    Label {
        id: fans
        anchors {
            top: uname.bottom
            topMargin: 5
            horizontalCenter: parent.horizontalCenter
        }
        color: "#004d73"
        text: "<font color=\"#20b5ff\">粉丝数:</font>" + root.fans
        font {
            pixelSize: 13
        }          
    }

    // 房间号
    Label {
        id: roomid
        anchors {
            top: fans.bottom
            topMargin: 5
            horizontalCenter: parent.horizontalCenter
        }
        color: "#004d73"
        text: "<font color=\"#20b5ff\">房间号:</font>" + root.roomid
        font {
            pixelSize: 13
        }          
    }
    
    // 直播采集数据
    Item{
        id: liveStatus
        visible: false
        width: root.width
        anchors {
            top: roomid.bottom
            bottom: btn.top
            horizontalCenter: root.horizontalCenter
        }        
        // 观看人数
        Items.Data {
            id: populate
            width: 80
            title: "人气"
            titleColor: "#0099e6"
            anchors {
                centerIn: parent
            }
        }
        Items.Data {
            id: gift
            width: 80
            title: "礼物"
            titleColor: "#0099e6"
            anchors {
                left: populate.right
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }
        }
        Items.Data {
            id: danmaku
            width: 80
            title: "弹幕"        
            titleColor: "#0099e6"
            anchors {
                right: populate.left
                rightMargin: 10
                verticalCenter: parent.verticalCenter
            }
        }
    }
    Items.Danmaku {
        id: danmakulist
    }
    Items.MyButton {
        id: btn
        anchors {
            horizontalCenter: root.horizontalCenter
            bottom: root.bottom
            bottomMargin: 30
        }
        onStart: {
            populate.num = "0"
            gift.num = "0"
            danmaku.num = "0"

            danmakuComponent = Qt.createComponent("items/Danmaku.qml");
            childWin = danmakuComponent.createObject(root);
            childWin.show();

            liveStatus.visible = true
            websocket.start()
        }
        onClose: {
            childWin.close()
        }
    }
}