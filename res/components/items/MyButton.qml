import QtQuick 2.12
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.0

Item {
    id : mybutton
    width: 50
    height: 50

    property bool status: false
    property color rawColor: "#0099e6"
    property color rawTextColor: "#fff"
    property color hoverColor: "#0099e6"
    property color hoverTextColor: "#fff"

    property string rawText: "Start!"
    property string afterText: "Live"


    signal close()
    signal start()
    signal click()
    
    Rectangle{
        id : toprect
        color: "#0099e6"
        width: mybutton.width-2;
        height: mybutton.height-2
        radius: height/2
        opacity: 0.2
 
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled : true
            onClicked: {
                animation.start();
                if(mybutton.status) {
                    mytext.text = qsTr(mybutton.rawText)
                    mytext.color = mybutton.rawTextColor
                    toprect.color = mybutton.rawColor
                    mybutton.close()
                }else {
                    mytext.text = qsTr(mybutton.afterText)
                    toprect.color = mybutton.hoverColor
                    mytext.color = mybutton.hoverTextColor
                    mybutton.start()
                }
                mybutton.status = !mybutton.status
                mybutton.click()
            }
            onEntered: {
                animation.start();
            }
            onExited: {
                // toprect.color = "#0099e6";
            }
        }
    }

    DropShadow {
        id : shadow
        anchors.fill: toprect
        horizontalOffset: 2
        verticalOffset: 4
        radius: 8.0
        samples: 17
        color: "#999999"
        source: toprect
    }
 
    Text {
        id: mytext
        anchors.centerIn: toprect
        text: qsTr(mybutton.rawText)
        color: mybutton.rawTextColor
        font.pixelSize : 16
    }
 
 
    SequentialAnimation {
        id : animation
        NumberAnimation { target: toprect; property: "y"; to: toprect.x+2; duration: 100 }
        NumberAnimation { target: toprect; property: "y"; to: toprect.x-2; duration: 100 }
    }
 
}
