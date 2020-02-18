import QtQuick 2.12
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.0

Item {
    id : mybutton
    width: 50
    height: 50
 
    signal clicked();
    
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
                mybutton.clicked();
            }
            onEntered: {
                animation.start();
            }
            onExited: {
                toprect.color = "#0099e6";
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
        text: qsTr("Live!")
        color: "#fff"
        font.pixelSize : 16
    }
 
 
    SequentialAnimation {
        id : animation
        NumberAnimation { target: toprect; property: "y"; to: toprect.x+2; duration: 100 }
        NumberAnimation { target: toprect; property: "y"; to: toprect.x-2; duration: 100 }
    }
 
}
