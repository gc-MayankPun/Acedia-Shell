pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    readonly property string scriptPath: Quickshell.env("HOME") + "/.config/quickshell/scripts/nightlight.sh"

    property bool enabled: false
    property int temperature: 4500
    property bool loading: false
    property string lastError: ""

    readonly property int minTemperature: 2500
    readonly property int maxTemperature: 6500

    Process {
        id: statusProcess

        command: [root.scriptPath, "status"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text)

                    root.enabled = data.enabled
                    root.temperature = data.temperature

                    root.lastError = ""
                } catch (e) {
                    root.lastError = "Failed to parse nightlight status: " + e
                }

                root.loading = false
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (text.trim().length > 0)
                    root.lastError = text.trim()
            }
        }
    }

    Process {
        id: actionProcess

        onExited: root.update()
    }

    function update() {
        root.loading = true
        statusProcess.running = true
    }

    function enable() {
        root.loading = true
        actionProcess.command = [root.scriptPath, "enable", String(root.temperature)]
        actionProcess.running = true
    }

    function disable() {
        root.loading = true
        actionProcess.command = [root.scriptPath, "disable"]
        actionProcess.running = true
    }

    function toggle() {
        if (root.enabled)
            disable()
        else
            enable()
    }

    function setTemperature(value) {
        root.temperature = Math.max(
            root.minTemperature,
            Math.min(root.maxTemperature, value)
        )

        if (root.enabled)
            enable()
    }

    Component.onCompleted: update()
}