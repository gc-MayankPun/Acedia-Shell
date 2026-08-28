import Quickshell
import Quickshell.Io
import QtQuick

import "../theme"

Item {
    id: root

    property int batteryLevel: 0
    property string batteryStatus: "Unknown"

    implicitWidth: batteryText.implicitWidth
    implicitHeight: batteryText.implicitHeight

    Process {
        id: batteryProc

        command: [
            "sh",
            "-c",
            "printf '%s %s\\n' \"$(cat /sys/class/power_supply/BAT1/capacity)\" \"$(cat /sys/class/power_supply/BAT1/status)\""
        ]

        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                if (parts.length >= 2) {
                    root.batteryLevel = parseInt(parts[0]) || 0
                    root.batteryStatus = parts[1]
                }
            }
        }
        
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true

        onTriggered: {
            batteryProc.running = true
        }
    }
 
    Text {
        id: batteryText
        text: "󰁹 " + root.batteryLevel + "%"
        color: root.batteryStatus === "Charging"
            ? Theme.batCharging
            : root.batteryLevel < 10
                ? Theme.batLow
                : Theme.batDischarging
        font {
            family: Theme.fontFamily
            pixelSize: Theme.fontSize
            bold: true
        }
    }
}