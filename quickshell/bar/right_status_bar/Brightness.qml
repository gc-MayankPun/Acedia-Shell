pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // Brightness state
    property int percentage: 50
    readonly property real level: percentage / 100.0

    // Read current brightness
    Process {
        id: readProcess

        command: [
            "brightnessctl",
            "-e4",
            "-n2",
            "-m"
        ]

        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(",")

                if (parts.length >= 4) {
                    const value = parseInt(
                        parts[3].replace("%", "")
                    )

                    if (!isNaN(value))
                        root.percentage = value
                }
            }
        }
    }

    // Change brightness
    Process {
        id: changeProcess

        command: []

        onExited: {
            root.refresh()
        }
    }

    // Refresh
    function refresh() {
        if (!readProcess.running)
            readProcess.running = true
    }

    // Set brightness
    function setBrightness(value) {
        value = Math.max(0, Math.min(100, value))

        // Update UI immediately
        root.percentage = value

        changeProcess.command = [
            "brightnessctl",
            "-e4",
            "-n2",
            "set",
            value + "%"
        ]

        changeProcess.running = true
    }

    // Increase / Decrease
    function increaseBrightness() {
        setBrightness(root.percentage + 5)
    }

    function decreaseBrightness() {
        setBrightness(root.percentage - 5)
    }

    // IPC
    IpcHandler {
        target: "brightness"

        function increase() {
            root.increaseBrightness()
        }

        function decrease() {
            root.decreaseBrightness()
        }

        function refresh() {
            root.refresh()
        }
    }

    // Initial read
    Component.onCompleted: {
        root.refresh()
    }
}