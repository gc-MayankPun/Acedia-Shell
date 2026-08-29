import QtQuick
import QtQuick.Layouts

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
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom

            leftMargin: mouse.containsMouse ? 5 : 0
            rightMargin: mouse.containsMouse ? 5 : 0
        }

        radius: 10
        color: mouse.containsMouse ? Theme.surfaceAlt : "transparent" 

        Behavior on color {
            ColorAnimation {
                duration: Animations.normal
            }
        }

        Behavior on anchors.leftMargin {
            NumberAnimation {
                duration: Animations.normal
            }
        }

        Behavior on anchors.rightMargin {
            NumberAnimation {
                duration: Animations.normal
            }
        }

        // App image
        Text {
            anchors {
                left: parent.left
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }


            text: root.appIcon
            color: Theme.text 

            font {
                family: Theme.fontFamily
                pixelSize: 20
            }
        }

        // App name
        Text {
            anchors{
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