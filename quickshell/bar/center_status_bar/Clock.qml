import Quickshell
import QtQuick

import "../../theme"

Rectangle {
    width: clockCapsule.implicitWidth + 30
    height: clockCapsule.implicitHeight + 10

    radius: Theme.radiusPill
    color: Theme.background

    Text {
        id: clockCapsule
        anchors.centerIn: parent

        text: '<span style="color:' + Theme.clock + '">'
        + Qt.formatDateTime(clock.date, "hh:mm")
        + '</span>'
        + '&nbsp;&nbsp;'
        + '<span style="color:' + Theme.textMuted + '">'
        + Qt.formatDateTime(clock.date, "ddd dd")
        + '</span>'

        textFormat: Text.RichText

        font {
            family: Theme.fontFamily
            letterSpacing: -0.5
            pixelSize: 12
            weight: 700
        }

        SystemClock {
            id: clock
            precision: SystemClock.Minutes
        }
    }
}