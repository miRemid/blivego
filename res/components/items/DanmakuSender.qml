import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.13
import Qt.labs.platform 1.0
import Server 1.0 as Server
import QtQuick.Dialogs 1.2
import "../fonts/UbuntuMono" as UM

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
            text: "Enter send(null close),Esc close"
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
                focus: true
                id: danmakuInput
                width: parent.width * 4 / 5
                anchors.centerIn: parent
                cursorVisible: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                font.family: UM.Fonts.regular

                Keys.enabled: true
                Keys.onEscapePressed: {
                    danmakuInput.text = ""
                    subWindow.visible = false
                }
                Keys.onPressed: {  
                    if (event.key === Qt.Key_Return ) {  
                        if (danmakuInput.length > 0) {
                            sender.send(danmakuInput.text)
                            danmakuInput.text = ""
                        }
                    } 
                }
            }
        }
    }
    onClosing: {
        subWindow.visible = false
        danmakuInput.text = ""
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