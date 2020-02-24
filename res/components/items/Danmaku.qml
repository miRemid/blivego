import QtQuick 2.12
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.12

Item {
    id: container
    height: 500
    width: 300

    // property string name: "test"
    // property string message: "value"
    // property string avator: "https://i.loli.net/2019/11/03/r7vSwJsUzfWxYmk.jpg"

    ColumnLayout {
        anchors.fill: parent
        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: pane.leftPadding + messageField.leftPadding
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
                    uname: "test"
                    message: "testsetset"
                }
            }
            ScrollBar.vertical: ScrollBar{}
        }
        Pane {
            id: pane
            Layout.fillWidth: true

            RowLayout {
                width: parent.width

                TextArea {
                    id: messageField
                    Layout.fillWidth: true
                    placeholderText: qsTr("Compose message")
                    wrapMode: TextArea.Wrap
                }

                Button {
                    id: sendButton
                    text: qsTr("Send")
                    enabled: messageField.length > 0
                    onClicked: {
                        listView.model.sendMessage(inConversationWith, messageField.text);
                        messageField.text = "";
                    }
                }
            }
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            listModel.append({
                avatar: "https://i.loli.net/2019/11/03/r7vSwJsUzfWxYmk.jpg",
                uname: "test",
                message: "testsetset"
            })
        }
    }
}