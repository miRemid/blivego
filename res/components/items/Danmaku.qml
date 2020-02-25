import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.12

ApplicationWindow {
    id: container
    height: 500
    width: 300
    x: Screen.desktopAvailableWidth
    y: Screen.desktopAvailableHeight/2
    color: "transparent"
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.WindowDoesNotAcceptFocus

    function append(message) {
        console.log(message)
        let data = JSON.parse(message)
        listModel.append({
            avatar: data["face"],
            uname: data["uname"],
            message: data["message"],
        })
    }

    ColumnLayout {
        anchors.fill: parent
        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            displayMarginBeginning: 40
            displayMarginEnd: 40
            spacing: 12
            delegate: Column {
                spacing: 6
                anchors.left: parent.left
                Row {
                    id: messageRow
                    spacing: 6
                    anchors.left: parent.left
                    Image {
                        id: avatar
                        height: 25
                        width: 25
                        fillMode: Image.PreserveAspectFit
                        source: model.avatar
                    }
                    Rectangle {
                        width: Math.min(messageText.implicitWidth + 24, listView.width - avatar.width - messageRow.spacing)
                        height: messageText.implicitHeight + 24
                        color: "steelblue"
                        Label {
                            id: messageText
                            text: model.message
                            color: "white"
                            anchors.fill: parent
                            anchors.margins: 12
                            wrapMode: Label.Wrap
                        }
                    }
                }
            }
            model: ListModel {
                id: listModel
                ListElement {
                    avatar: "https://i.loli.net/2019/11/03/r7vSwJsUzfWxYmk.jpg"
                    uname: "测试君"
                    message: "这是一条测试弹幕"
                }
            }
        }
    }
}