import QtQuick

import "../../theme"

Item {
    id: button

    property string icon: ""
    property color normalColor: Theme.textMuted
    property color hoverColor: Theme.textHover
    property color hoverBackground: Qt.alpha(Theme.primary, 0.15)

    signal clicked()

    width: 24
    height: 24

    Rectangle {
        anchors.fill: parent

        radius: Theme.radiusSmall

        color: mouseArea.containsMouse
               ? button.hoverBackground
               : "transparent"

        scale: mouseArea.containsMouse ? 1.08 : 1.0

        Behavior on color {
            ColorAnimation {
                duration: Animations.fast
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: Animations.fast
                easing.type: Animations.easing
            }
        }
    }

    Text {
        anchors.centerIn: parent

        text: button.icon

        color: mouseArea.containsMouse
               ? button.hoverColor
               : button.normalColor

        font {
            family: Theme.fontFamily
            pixelSize: 14
        }

        Behavior on color {
            ColorAnimation {
                duration: Animations.fast
            }
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: button.clicked()
    }
}