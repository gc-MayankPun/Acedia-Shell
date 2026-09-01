import Quickshell
import QtQuick

import "../../config" as Config

Rectangle {
    width: clockCapsule.implicitWidth + Config.Theme.barWidth
    height: clockCapsule.implicitHeight + Config.Theme.barHeight
    color: "transparent"

    Text {
        id: clockCapsule
        anchors.centerIn: parent

        text: '<span style="color:' + Config.Theme.clock + '; font-size:' + Config.Theme.fontSize + 'px; font-weight: 700">'
        + Qt.formatDateTime(clock.date, "hh:mm")
        + '</span>'
        + '&nbsp;&nbsp;'
        + '<span style="color:' + Config.Theme.textMuted + '; font-size:' + Config.Theme.fontSmall + 'px; font-weight: 600">'
        + Qt.formatDateTime(clock.date, "ddd dd")
        + '</span>'

        textFormat: Text.RichText

        font {
            family: Config.Theme.fontFamily
            letterSpacing: -0.5  
        }

        SystemClock {
            id: clock
            precision: SystemClock.Minutes
        }
    }
}