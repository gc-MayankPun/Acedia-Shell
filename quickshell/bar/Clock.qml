import Quickshell
import Quickshell.Io
import QtQuick

import "../theme"

Rectangle {
    id: capsule

    width: clock.implicitWidth + 60
    height: clock.implicitHeight + 10

    radius: Theme.radiusPill
    color: Theme.background

    Text {
        id: clock

        anchors.centerIn: parent
        color: Theme.clock

        font {
            family: Theme.fontFamily
            pixelSize: Theme.fontSmall
            bold: true
        }

        text: Qt.formatDateTime(
            new Date(),
            "hh:mm AP"
        )

        Timer {
            interval: 1000
            running: true
            repeat: true

            onTriggered: {
                clock.text = Qt.formatDateTime(
                    new Date(),
                    "hh:mm AP"
                )
            }
        }
    }
}