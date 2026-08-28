import Quickshell
import Quickshell.Wayland
import QtQuick

import "../theme"

PanelWindow {
    id: root 
    height: 40
    width: 200 
    color: "transparent"
    anchors.top: true

    property string title: ""

    Rectangle {
        id: button
        anchors.fill: parent
        color: mouse.containsMouse ? Theme.blue : Theme.background
        radius: mouse.containsMouse ? 15 : 5 
    
        Behavior on color {
            ColorAnimation {
                duration: Animations.normal
                easing.type: Animations.easing
            }
        }

        Behavior on radius {
            NumberAnimation {
                duration: Animations.normal
                easing.type: Animations.easing
            }
        }

        Text {
            id: label
            anchors.centerIn: parent
            text: root.title
            color: mouse.containsMouse ? Theme.background : Theme.blue

            Behavior on color {
                ColorAnimation {
                    duration: Animations.normal
                    easing.type: Animations.easing
                }
            }
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                console.log("Clicked!")
            }
        }
    }
}