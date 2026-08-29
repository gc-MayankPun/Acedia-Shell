import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "../theme"

Item {
    id: root

    property string appName: ""
    property string appIcon: ""
    property string appCommand: ""

    signal launchRequested(string command)

    Layout.fillWidth: true
    Layout.preferredHeight: 30

    Rectangle {
        anchors.fill: parent

        radius: 10

        color: mouse.containsMouse
            ? Theme.surfaceAlt
            : "transparent"

        // App icon
        IconImage {
            id: appIcon

            anchors {
                left: parent.left
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }

            width: 20
            height: 20

            source: root.appIcon.startsWith("/")
                ? root.appIcon
                : Quickshell.iconPath(root.appIcon, true)
        }

        // App name
        Text {
            anchors {
                left: parent.left
                leftMargin: 35
                verticalCenter: parent.verticalCenter
            }

            text: root.appName
            color: Theme.text

            font {
                family: Theme.fontFamily
                pixelSize: Theme.fontSmall
            }
        }
    }

    MouseArea {
        id: mouse

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            root.launchRequested(root.appCommand)
        }
    }
}