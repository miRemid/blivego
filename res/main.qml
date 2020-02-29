import QtQuick 2.12
import QtQuick.Controls 2.13
import QtQuick.Window 2.12
import Server 1.0 as Server
import "components" as MyComponents
import Qt.labs.platform 1.0
import QtQuick.Dialogs 1.2


ApplicationWindow {
    id: root
    width: 300
    height: 500
    visible: true
    maximumHeight: 500
    maximumWidth: 300
    minimumHeight: 500
    minimumWidth: 300    

    Server.Infomation {
        id: infomationAPI
        function _onError(error) {
            let data = JSON.parse(error)
            if (data.code == 1) {
                loginView.visible = true
            }
        }

        function _onSuccess(jsonValue) {
            indexView.visible = true
            let data = JSON.parse(jsonValue)
            indexView.avatarURL = data["avatar"]
            indexView.uname = data["uname"]
            indexView.fans = data["fans"]
            indexView.roomid = data["roomid"]
        }

        onError: (error) => _onError(error)

        onSuccess: (data) => _onSuccess(data)
    }
    MyComponents.Index {
        id: indexView
        visible: false
        anchors.fill: parent
        z: 1
    }
    MyComponents.Login {
        id: loginView
        visible: false
        anchors.centerIn: parent
        z: 2
    }
    Component.onCompleted: {
        infomationAPI.getInfomation()
    }
    Connections {
        target: loginView
        onSuccess: {
            loginView.visible = false
            indexView.visible = true
        }
    }
    MyComponents.FlowWindow {
        id: flowWindow
        visible: true        
    }
    Menu {
        id: systemTrayMenu
        // 右键菜单
        MenuItem {
            text: qsTr("显示主界面")
            onTriggered: root.show()
        }
        // MenuItem {
        //     text: "更改房间id"
        //     onTriggered: {
        //         roomid.show()
        //     }
        // }
        MenuItem {
            text: flowWindow.visible ? qsTr("隐藏悬浮窗") : qsTr("显示悬浮窗")
            onTriggered: {
                flowWindow.visible = !flowWindow.visible
            }
        }
        MenuItem {
            text: qsTr("退出")
            onTriggered: Qt.quit()
        }
    }

    // Window {
    //     id: roomid
    //     flags: Qt.WindowCloseButtonHint
    //     maximumHeight: 110
    //     maximumWidth: 270
    //     minimumHeight: 110
    //     minimumWidth: 270
    //     x: (Screen.desktopAvailableWidth - width) / 2
    //     y: (Screen.desktopAvailableHeight - height) / 2
    //     Rectangle {
    //         width: parent.width * 4 / 5
    //         height: parent.height * 2 / 3
    //         anchors.centerIn: parent
    //         Label {
    //             id: title
    //             height: parent.height * 2 / 5
    //             width: parent.width
    //             text: "Enter修改(为空不修改),Esc关闭窗口"
    //             anchors {
    //                 top: parent.top
    //                 margins: 3
    //             }
    //         }
    //         Rectangle {
    //             width: parent.width
    //             anchors {
    //                 top: title.bottom
    //                 bottom: parent.bottom
    //                 margins: 3
    //             }
    //             height: parent.height * 3 / 5
    //             radius: height / 2
    //             color: "transparent"
    //             border {
    //                 width: 1
    //                 color: "#004d73"
    //             }
    //             TextInput {
    //                 id: roomidinput
    //                 width: parent.width * 4 / 5
    //                 anchors.centerIn: parent
    //                 cursorVisible: true
    //                 horizontalAlignment: TextInput.AlignHCenter
    //                 verticalAlignment: TextInput.AlignVCenter
    //                 MouseArea {
    //                     anchors.fill: parent
    //                     focus: true;
    //                     Keys.enabled: true;
    //                     Keys.onEscapePressed: {
    //                         roomid.visible = false
    //                         roomdsender.text = ""
    //                     }
    //                     Keys.onPressed: {
    //                         if (event.key === Qt.Key_Return ) { 
    //                             if (roomidinput.length > 0) {
    //                                 roomdsender.change(roomidinput.text)
    //                             }
    //                         } 
    //                     }  
    //                 }
    //             }
    //         }
    //     }
    //     onClosing: {
    //         roomid.visible = false
    //         roomidinput.text = ""
    //     }
    //     MessageDialog {
    //         id: notificial
    //         standardButtons: StandardButton.Yes
    //         onYes: {
    //             notificial.visible = false
    //         }
    //         onRejected: {
    //             notificial.visible = false
    //         }
    //     }
    //     Server.Send {
    //         id: roomdsender
    //         onChangeError: {
    //             notificial.title = "Error"
    //             notificial.text = "更改失败"
    //             notificial.visible = true
    //         }
    //         onChangeSuccess: {
    //             roomid.visible = false
    //             roomidinput.text = ""
    //         }
    //     }
    // }

    //系统托盘
    SystemTrayIcon {
        id:trayIcon
        visible: true
        iconSource: "qrc:/res/icon.png"
        tooltip: "Bililive-Go!"
        onActivated: {
            console.log("托盘激活")
        }
        menu: systemTrayMenu
    }

    onClosing: {
        root.hide()
    }
}
