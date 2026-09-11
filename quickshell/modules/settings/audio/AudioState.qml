pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    readonly property string scriptPath: Quickshell.env("HOME") + "/.config/quickshell/scripts/audio.sh"

    property string sinkName: ""
    property string sinkDescription: "Unknown output"
    property int volume: 0
    property bool muted: false

    property string sourceName: ""
    property string sourceDescription: "Unknown input"
    property int micVolume: 0
    property bool micMuted: false

    property bool loading: false
    property string lastError: ""

    Process {
        id: statusProcess

        command: [root.scriptPath, "status"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text)

                    root.sinkName = data.sinkName
                    root.sinkDescription = data.sinkDescription
                    root.volume = data.volume
                    root.muted = data.muted

                    root.sourceName = data.sourceName
                    root.sourceDescription = data.sourceDescription
                    root.micVolume = data.micVolume
                    root.micMuted = data.micMuted

                    root.lastError = ""
                } catch (e) {
                    root.lastError = "Failed to parse audio status: " + e
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

        onExited: root.silentUpdate()
    }

    // Background refresh — no visible loading flag, so it never
    // causes the "Refreshing…" text to blink every couple seconds.
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.silentUpdate()
    }

    function silentUpdate() {
        statusProcess.running = true
    }

    function update() {
        root.loading = true
        statusProcess.running = true
    }

    function setVolume(percent) {
        const clamped = Math.max(0, Math.min(100, Math.round(percent)))
        actionProcess.command = [root.scriptPath, "volume", String(clamped)]
        actionProcess.running = true
    }

    function toggleMute() {
        root.muted = !root.muted
        actionProcess.command = [root.scriptPath, "mute-toggle"]
        actionProcess.running = true
    }

    function setMicVolume(percent) {
        const clamped = Math.max(0, Math.min(100, Math.round(percent)))
        actionProcess.command = [root.scriptPath, "mic-volume", String(clamped)]
        actionProcess.running = true
    }

    function toggleMicMute() {
        root.micMuted = !root.micMuted
        actionProcess.command = [root.scriptPath, "mic-mute-toggle"]
        actionProcess.running = true
    }

    Component.onCompleted: update()
}