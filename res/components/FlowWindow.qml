import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.13
import Qt.labs.platform 1.0
import Server 1.0 as Server
import QtQuick.Dialogs 1.2

Window {
    id: flowWindow
    visible: true
    width: 35
    height: 35
    flags: Qt.FramelessWindowHint | Qt.WindowSystemMenuHint | Qt.WindowStaysOnTopHint | Qt.X11BypassWindowManagerHint
    color: "transparent"

    x: Screen.desktopAvailableWidth * 4 / 5
    y: Screen.desktopAvailableHeight / 5

    Window {
        id: subWindow
        flags: Qt.WindowCloseButtonHint
        maximumHeight: 110
        maximumWidth: 270
        minimumHeight: 110
        minimumWidth: 270
        x: (Screen.desktopAvailableWidth - width) / 2
        y: (Screen.desktopAvailableHeight - height) / 2
        Rectangle {
            width: 250
            height: 70
            anchors.centerIn: parent
            Label {
                id: title
                height: 20
                width: parent.width
                text: "Enter发送弹幕(为空不发送),Esc关闭窗口"
                anchors {
                    top: parent.top
                    margins: 3
                }
            }
            Rectangle {
                width: parent.width
                anchors {
                    top: title.bottom
                    bottom: parent.bottom
                    margins: 3
                }
                height: 35
                radius: height / 2
                color: "transparent"
                border {
                    width: 1
                    color: "#004d73"
                }
                TextInput {
                    id: danmakuInput
                    width: parent.width * 4 / 5
                    anchors.centerIn: parent
                    cursorVisible: true
                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter
                    MouseArea {
                        anchors.fill: parent
                        focus: true;
                        Keys.enabled: true;
                        Keys.onEscapePressed: {
                            subWindow.visible = false
                        }
                        Keys.onPressed: {  
                            if (event.key === Qt.Key_Return ) {  
                                if (danmakuInput.length > 0) {
                                    sender.send(danmakuInput.text)
                                }
                            } 
                        }  
                    }
                }
            }
        }
        onClosing: {
            subWindow.visible = false
        }
        MessageDialog {
            id: notificial
            standardButtons: StandardButton.Yes
            onYes: {
                subWindow.visible = false
            }
            onRejected: {
                subWindow.visible = false
            }
        }
        Server.Send {
            id: sender
            onError: (error) => {
                let data = JSON.parse(error)
                notificial.title = "Error"
                notificial.text = data["message"]
                notificial.visible = true
            }
            onResponse: (response) => {
                let data = JSON.parse(response)
                if (data["code"] != 0) {
                    notificial.title = "Error"
                    notificial.text = data["message"]
                }else {
                    notificial.text = ""
                    subWindow.visible = false
                }
            }
        }
    }

    Rectangle {
        id: rectangle
        width: 30
        height: width
        color: "#e6f7ff"
        border {
            color: "#004d73"
            width: 3
        }
        Text {
            anchors.centerIn: parent
            text: "Go"
            color: "#004d73"
        }
        radius: height / 2
        anchors.centerIn: parent
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RigtButton
            property point clickPos: "0,0"
            onPressed: {
                clickPos = Qt.point(mouse.x, mouse.y)
            }
            onPositionChanged: {
                //鼠标偏移量
                var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                //如果mainwindow继承自QWidget,用setPos
                flowWindow.setX(flowWindow.x + delta.x)
                flowWindow.setY(flowWindow.y + delta.y)
            }
            onDoubleClicked: {
                subWindow.show()
            }
        }
    }
}
