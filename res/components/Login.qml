import QtQuick 2.12
import QtQuick.Controls 2.12
import Server 1.0 as Server

Rectangle {
    id: "loginView"
    width: 256
    height: 256

    signal success()

    function onStart() {
        busy.running = true
        label.visible = false
        login.getQRCode()
    }

    Server.Login {
        id: login

        // 二维码获取错误
        // 重新获取二维码
        onQrcodeError: {
            busy.running = false
            label.visible = true
            label.text = "点击重新刷新二维码"
        }
        // 二维码获取成功
        // 加载二维码图片
        onQrcodeSuccess: (path) => {
            busy.running = false
            qrcode.source = "file:" + path
        }
        // 二维码过期
        onQrcodeObsolete: {
            mask.visible = true
            label.visible = true
            label.text = "二维码已过期，点击重新刷新二维码"
            qrcode.ob = true
        }
        // 二维码已扫描
        onQrcodeScan: {
            mask.visible = true
            label.visible = true
            label.text = "请在手机上确认登陆"
        }
        // 登陆成功
        onLogin: {
            loginView.success()
        }
    }

    BusyIndicator {
        id: busy
        running: true
        anchors.centerIn: parent
        z: 2
    }

    Label {
        id: label
        visible: false
        text: "test"
        anchors.centerIn: parent
        z: 3
        font {
            pixelSize: 18
        }
    }

    Image {
        id: qrcode
        property bool ob: false
        asynchronous: true
        cache: false
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        Rectangle {
            id: mask
            anchors.fill: parent
            visible: false
            color: "white"
            opacity: 0.8
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (qrcode.ob) {
                    console.log("过期了")
                }else {
                    console.log("> <")
                }
            }
        }
    }

    Component.onCompleted: {
       onStart()
    }

}