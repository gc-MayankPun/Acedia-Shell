import Quickshell
import Quickshell.Io
import QtQuick

import "../theme"

Rectangle {
    id: capsule

    property date currentTime: new Date()

    width: content.implicitWidth + 30
    height: content.implicitHeight + 10

    radius: Theme.radiusPill
    color: Theme.background

    Row {
        id: content

        anchors.centerIn: parent
        spacing: 6

        // Time
        Text {
            anchors.verticalCenter: parent.verticalCenter
            
            text: Qt.formatDateTime(currentTime, "HH:mm")
            color: Theme.clock

            font {
                family: Theme.fontFamily
                pixelSize: Theme.fontSmall
                bold: true
            }
        }

        // Day
        Text {
            anchors.verticalCenter: parent.verticalCenter

            text: Qt.formatDateTime(currentTime, "ddd")
            color: Theme.textMuted

            font {
                family: Theme.fontFamily
                pixelSize: Theme.fontSmall
            }
        }

        // Date
        Text {
            anchors.verticalCenter: parent.verticalCenter

            text: Qt.formatDateTime(currentTime, "dd")
            color: Theme.textMuted

            font {
                family: Theme.fontFamily
                pixelSize: Theme.fontSmall
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            capsule.currentTime = new Date()
        }
    }
}