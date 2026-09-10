pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    property bool enabled: false
    property int temperature: 4500
    property bool loading: false
    property string lastError: ""

    readonly property int minTemperature: 2500
    readonly property int maxTemperature: 6500

    Process {
        id: setProcess

        stdout: StdioCollector {
            onStreamFinished: {}
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (text.trim().length > 0)
                    root.lastError = text.trim()
            }
        }

        onExited: {
            root.loading = false
        }
    }

    function enable() {
        root.loading = true
        root.lastError = ""
        root.enabled = true

        setProcess.command = [
            "bash",
            "-lc",
            "hyprsunset -t " + root.temperature
        ]

        setProcess.running = true
    }

    function disable() {
        root.loading = true
        root.lastError = ""
        root.enabled = false

        // -i resets to identity (no color filter)
        setProcess.command = ["bash", "-lc", "hyprsunset -i"]

        setProcess.running = true
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

        // Only push the new temperature live if already enabled
        if (root.enabled)
            enable()
    }

    Component.onCompleted: {
        // No reliable "query current state" IPC call in hyprsunset,
        // so we assume off at startup. Adjust here if you always
        // enable it via exec-once with a fixed default temperature.
    }
}