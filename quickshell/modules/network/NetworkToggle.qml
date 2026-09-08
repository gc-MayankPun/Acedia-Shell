import Quickshell
import QtQuick

import "../../config" as Config

Rectangle {
    id: root
    anchors.verticalCenter: parent.verticalCenter
    implicitWidth: network.width
    implicitHeight: 20
    color: "transparent"

    Text {
        id: network
        text: "\uf1eb"
        color: mouse.containsMouse ? Config.Theme.primary : Config.Theme.text
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
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: NetworkState.toggle()
        }
    }
}