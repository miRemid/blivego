import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.13
import Server 1.0 as Server
import QtQuick.Dialogs 1.2
import "fonts/UbuntuMono" as UM

Window {
    id: flowWindow
    visible: true
    width: 35
    height: 35
    flags: Qt.FramelessWindowHint | Qt.WindowSystemMenuHint | Qt.WindowStaysOnTopHint | Qt.X11BypassWindowManagerHint
    color: "transparent"

    x: Screen.desktopAvailableWidth * 4 / 5
    y: Screen.desktopAvailableHeight / 5

    Rectangle {
        id: rectangle
        width: 30
        height: width
        color: "#e6f7ff"
        border {
            color: "#004d73"
            width: 2
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
                var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                flowWindow.setX(flowWindow.x + delta.x)
                flowWindow.setY(flowWindow.y + delta.y)
            }
            onDoubleClicked: {
                let components = Qt.createComponent("items/DanmakuSender.qml")
                let subWindow = components.createObject("flowWindow")
                subWindow.show()
            }
        }
    }
}
