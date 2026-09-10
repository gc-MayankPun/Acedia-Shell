pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    readonly property string scriptPath: Quickshell.env("HOME") + "/.config/quickshell/scripts/bluetooth.sh"

    property bool powered: false
    property var devices: []
    property var pairedDevices: []
    property var availableDevices: []
    property bool loading: false
    property string lastError: ""

    property string pendingAddress: ""
    property string pendingAction: ""

    Process {
        id: statusProcess

        command: [root.scriptPath, "status"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text)

                    root.powered = data.powered
                    root.devices = data.devices

                    root.pairedDevices = data.devices.filter(d => d.paired)
                    root.availableDevices = data.devices.filter(d => !d.paired)

                    root.lastError = ""
                } catch (e) {
                    root.lastError = "Failed to parse bluetooth status: " + e
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

        onExited: {
            root.pendingAddress = ""
            root.pendingAction = ""
            root.update()
        }
    }

    function update() {
        root.loading = true
        statusProcess.running = true
    }

    function togglePower() {
        actionProcess.command = [root.scriptPath, "power", root.powered ? "off" : "on"]
        actionProcess.running = true
    }

    function scan() {
        root.loading = true
        actionProcess.command = [root.scriptPath, "scan"]
        actionProcess.running = true
    }

    function pair(address) {
        root.pendingAddress = address
        root.pendingAction = "pairing"
        root.loading = true

        actionProcess.command = [root.scriptPath, "pair", address]
        actionProcess.running = true
    }

    function connect(address) {
        root.pendingAddress = address
        root.pendingAction = "connecting"
        root.loading = true

        actionProcess.command = [root.scriptPath, "connect", address]
        actionProcess.running = true
    }

    function disconnect(address) {
        root.pendingAddress = address
        root.pendingAction = "disconnecting"
        root.loading = true

        actionProcess.command = [root.scriptPath, "disconnect", address]
        actionProcess.running = true
    }

    Component.onCompleted: update()
}