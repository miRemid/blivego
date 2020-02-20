import QtQuick 2.12
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.0


// 弹出层，开播信息填写
Item {
    id: liveInfo
    visible: false

    // 开启直播
    signal success(string title, string liveid)

    Rectangle {
        id: backRec
        anchors.fill: parent
        opacity: 0.2
        color: "black"
    }

    Rectangle {
        id: mainRec
        height: 300
        width: 250
        anchors.centerIn:parent
        color: "#cceeff"
        
        // 直播标题
        Loader {
            id: inputTitle
            sourceComponent: component
            anchors {
                centerIn: parent
                verticalCenterOffset: -30
            }
            onLoaded: {
                item.placeHoldText = "房间标题"
                item.width = 200
            }
        }
        // 直播分类
        Loader {
            id: inputId
            sourceComponent: component
            anchors {
                centerIn: parent
                verticalCenterOffset: 30
            }
            onLoaded: {
                item.placeHoldText = "直播类型(数字id)"
                item.width = 200
            }
        }
        // 按钮
        MyButton {
            id: submit
            anchors {
                top: inputId.bottom
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
            onClick: {
                liveInfo.success(inputTitle.item.text, inputId.item.text)
            }
        }     
    }

    Component{
        id: component
        Item{
            width: 300
            height: 40
            property alias text: input.text
            property alias placeHoldText: placeHold.text

            Rectangle {
                id: inputRec
                anchors.fill: parent
                TextInput{
                    id: input
                    width: parent.width * 4 / 5
                    anchors.centerIn: parent
                    horizontalAlignment: TextInput.AlignLeft
                    verticalAlignment: TextInput.AlignVCenter
                    font.pixelSize: 20
                    color: "black"
                    clip: true
                }
                border {
                    width: 2
                    color: "#004d73"
                }
                radius: height / 3
            }
            Label {
                id: placeHold
                font {
                    pixelSize: 12
                }
                anchors {
                    bottom: inputRec.top
                }
                color: "black"
            }
        }
    }
}