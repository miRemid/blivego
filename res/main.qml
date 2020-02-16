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
                console.log("cookies不存在或失效，重新登陆")
                loginView.visible = true
            }
        }

        function _onSuccess(jsonValue) {
            let data = JSON.parse(jsonValue)
            for (let key in data) {
                console.log(key, data[key])
            }
        }

        onError: (error) => _onError(error)

        onSuccess: (data) => _onSuccess(data)
    }

    MyComponents.Login {
        id: "loginView"
        visible: false
        anchors.centerIn: parent
    }
    
    Component.onCompleted: {
        infomationAPI.getInfomation()
    }

    Connections {
        target: loginView
        onSuccess: {
            console.log("登陆成功")
        }
    }
}