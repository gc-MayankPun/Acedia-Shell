import Quickshell
import QtQuick

import "../../config" as Config

Rectangle {
    anchors.verticalCenter: parent.verticalCenter
    implicitWidth: notification.width
    implicitHeight: 20
    color: "transparent"

    Text {
        id: notification
        text: ""
        color: notifMouse.containsMouse ? Config.Theme.primary : Config.Theme.text
        anchors.centerIn: parent
        font {
            family: Config.Theme.fontFamily
            pixelSize: Config.Theme.fontSize
        }

        Behavior on color {
            ColorAnimation {
                duration: Config.Theme.animFast
                easing: Config.Theme.normalEasing
            }
        }

        MouseArea {
            id: notifMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            
            onClicked: NotificationState.toggle()
        }
    }
}