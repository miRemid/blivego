import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.12

ApplicationWindow {
    id: container
    height: 500
    width: 300
    x: Screen.desktopAvailableWidth
    y: Screen.desktopAvailableHeight / 4
    color: "transparent"    
    flags: Qt.CoverWindow | Qt.ToolTip | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.WindowTransparentForInput
    function append(data) {
        listModel.insert(0, {
            avatar: data["face"],
            uname: data["uname"],
            message: data["message"],
            gift: data["gift"],
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
            verticalLayoutDirection: ListView.BottomToTop
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
                        height: 30
                        width: 30
                        fillMode: Image.PreserveAspectFit
                        source: model.avatar
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Rectangle {
                        color: "steelblue"
                        width: 200
                        height: messageText.implicitHeight + 24                       
                        TextArea {
                            id: messageText
                            color: "white"
                            readOnly: true
                            textFormat: Text.RichText
                            text: model.gift ? uname + ': <font color="#ffcccc">' + message + "</font>" : uname + ': <font color="white">' + message + "</font>"
                            anchors.fill: parent
                            anchors.margins: 12
                            wrapMode: TextEdit.Wrap
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
                    gift: true
                }
            }
            populate: Transition{
                NumberAnimation{
                    property: "opacity"
                    from: 0
                    to: 1.0
                    duration: 200
                }
            }
            displaced: Transition {
                SpringAnimation{
                    property: "y"
                    spring: 2
                    damping: 0.5
                    epsilon: 0.25
                }
            }
            add:Transition {
                ParallelAnimation{
                    NumberAnimation{
                        property: "opacity"
                        from: 0
                        to : 1.0
                        duration: 200
                    }
                    NumberAnimation{
                        property: "y"
                        from: 0
                        duration:  500
                    }
                }
            }
        }
    }
}