import QtQuick 2.12
import QtQuick.Controls 2.12
// import Server 1.0

Rectangle {
    id: "personInfo"

    width: 300
    height: 400    

    Rectangle {
        id: "login"
        visible: true
        anchors.fill: parent

        Rectangle {
            id: "qrcode"
            width: 128
            height: width
            color: '#cceeff'

            anchors.horizontalCenter: login.horizontalCenter
            anchors.top: login.top
            anchors.topMargin: 50

            property bool outDate: false

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (parent.outDate) {
                        console.log("refresh")
                        parent.outDate = false
                    }else {
                        parent.outDate = true
                    }
                }
            }   
        }
    }


}
