pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    readonly property string scriptPath: Quickshell.env("HOME") + "/.config/quickshell/scripts/media.sh"

    property bool isMediaPopupOpen: false

    property bool hasPlayer: false
    property bool playing: false
    property string title: ""
    property string artist: ""
    property string album: ""
    property string artUrl: ""
    property int position: 0
    property int length: 0
    property string source: "other"
    property bool hasLoadedOnce: false
    property string lastError: ""

    property Process statusProcess: Process {
        command: [root.scriptPath, "status"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text)

                    root.hasPlayer = data.hasPlayer
                    root.playing = data.playing
                    root.title = data.title
                    root.artist = data.artist
                    root.album = data.album
                    root.artUrl = data.artUrl
                    root.position = data.position
                    root.length = data.length
                    root.source = data.source
                    root.hasLoadedOnce = true
                    root.lastError = ""
                } catch (e) {
                    root.lastError = "Failed to parse media status: " + e + " | raw: " + text
                }
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (text.trim().length > 0)
                    root.lastError = text.trim()
            }
        }
    }

    property Process actionProcess: Process {
        onExited: root.silentUpdate()
    }

    property Timer pollTimer: Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.silentUpdate()
    }

    function silentUpdate() {
        if (statusProcess.running)
            return

        statusProcess.running = true
    }

    function toggle() { isMediaPopupOpen = !isMediaPopupOpen }
    function show() { isMediaPopupOpen = true }
    function hide() { isMediaPopupOpen = false }

    function playPause() {
        actionProcess.command = [root.scriptPath, "play-pause"]
        actionProcess.running = true
    }

    function next() {
        actionProcess.command = [root.scriptPath, "next"]
        actionProcess.running = true
    }

    function previous() {
        actionProcess.command = [root.scriptPath, "previous"]
        actionProcess.running = true
    }

    function seek(seconds) {
        actionProcess.command = [root.scriptPath, "seek", String(seconds)]
        actionProcess.running = true
    }
}
