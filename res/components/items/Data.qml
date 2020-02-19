import QtQuick 2.12
import QtQuick.Controls 2.13


Item {
    id: root
    width: 50
    height: width

    property string title: "数据"
    property color titleColor: "#cceeff"

    property string num: "6"
    property color dataColor: "#000"

    // 1. title
    Item {
        id: title
        height: root.height * 2 / 5
        width: root.width
        Label {
            text: root.title
            color: root.titleColor
            anchors.centerIn: parent
            font {
                pixelSize: title.height / 2
            }
        }
    }
    // 数据
    Item {
        id: data
        height: root.height * 3 / 5
        width: root.width
        anchors {
            top: title.bottom
        }
        Label {
            text: root.num
            color: root.dataColor
            anchors.centerIn: parent
            font {
                pixelSize: data.height / 3
            }
        }
    }
}