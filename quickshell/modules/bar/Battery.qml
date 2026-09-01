import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

import "../../config" as Config

Rectangle {
    implicitWidth: root.implicitWidth + Config.Theme.barWidth
    implicitHeight: root.implicitHeight + Config.Theme.barHeight
    color: "transparent"

    RowLayout {
        id: root

        anchors.centerIn: parent
        spacing: 6

        property var battery: UPower.displayDevice
        property bool charging: battery.state === UPowerDeviceState.Charging
        readonly property int level: Math.round(battery.percentage * 100)

        readonly property string icon: {
            if (charging) return String.fromCodePoint(0xF0084)
            if (level >= 100) return String.fromCodePoint(0xF0079)
            if (level < 10) return String.fromCodePoint(0xF0083)

            return String.fromCodePoint(0xF007A + (Math.floor(level / 10) - 1))
        }

        Text {
            text: root.icon
            color: root.charging ? "#7ad9a8"
            : root.level <= 15 ? "#ff5048"
            : root.level <= 30 ? "#ffa478"
            : "#7ad9a8"

            font {
                family: "JetBrainsMono Nerd Font Propo"
                pixelSize: 14
            }
        }

        Text {
            text: root.level + "%"
            color: "#f5e2c5"
            font {
                family: "SF Pro Display"
                weight: 600
                pixelSize: Theme.fontSize
            }
        }
    }
}