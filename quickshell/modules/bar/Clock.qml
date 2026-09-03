import Quickshell
import QtQuick
import QtQuick.Layouts

import "../../config" as Config

Rectangle {
    width: clockRow.implicitWidth + Config.Theme.barWidth
    height: clockRow.implicitHeight + Config.Theme.barHeight

    color: "transparent"

    RowLayout {
        id: clockRow

        anchors.centerIn: parent
        spacing: 13

        Text {
            text: Qt.formatDateTime(clock.date, "hh:mm")

            color: Config.Theme.primary

            font {
                family: Config.Theme.fontFamily
                pixelSize: Config.Theme.fontSize
                weight: 700
            }
        }

        Text {
            text: Qt.formatDateTime(clock.date, "ddd dd")

            color: Config.Theme.textMuted

            font {
                family: Config.Theme.fontFamily
                pixelSize: Config.Theme.fontSmall
                weight: 600
            }
        }
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}