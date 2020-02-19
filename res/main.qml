import QtQuick 2.12
import QtQuick.Controls 2.13
import Server 1.0 as Server
import "components" as MyComponents

Item {
    id: root
    width: 300
    height: 500

    Server.Infomation {
        id: infomationAPI

        function _onError(error) {
            let data = JSON.parse(error)
            if (data.code == 1) {
                loginView.visible = true
            }
        }

        function _onSuccess(jsonValue) {
            indexView.visible = true
            let data = JSON.parse(jsonValue)
            indexView.avatarURL = data["avatar"]
            indexView.uname = data["uname"]
            indexView.fans = data["fans"]
            indexView.roomid = data["roomid"]
        }

        onError: (error) => _onError(error)

        onSuccess: (data) => _onSuccess(data)
    }
    MyComponents.Index {
        id: indexView
        visible: false
        anchors.fill: parent
        z: 1
    }
    MyComponents.Login {
        id: "loginView"
        visible: false
        anchors.centerIn: parent
        z: 2
    }
    Component.onCompleted: {
        infomationAPI.getInfomation()
    }
    Connections {
        target: loginView
        onSuccess: {
            loginView.visible = false
            indexView.visible = true
        }
    }
}