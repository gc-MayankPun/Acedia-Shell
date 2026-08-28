import Quickshell
import QtQuick

import "../theme"

Item {
    id: root
    implicitWidth: clock.implicitWidth
    implicitHeight: clock.implicitHeight

    Text {
        id: clock
        color: Theme.clock
        font {
            family: Theme.fontFamily
            pixelSize: Theme.fontSize
            bold: true
        }
        text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
        }
    }
}