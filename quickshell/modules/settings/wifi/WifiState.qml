pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    readonly property string scriptPath: Quickshell.env("HOME") + "/.config/quickshell/scripts/wifi.sh"

    property bool radioEnabled: true
    property var networks: []
    property var savedNetworks: []
    property var availableNetworks: []
    property bool loading: false
    property string lastError: ""

    // Tracks an in-flight connect/disconnect so the UI can show
    // "Connecting…" / "Disconnecting…" on the right row.
    property string pendingNetwork: ""
    property string pendingAction: ""

    Process {
        id: statusProcess

        command: [root.scriptPath, "status"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text)

                    root.radioEnabled = data.radioEnabled
                    root.networks = data.networks

                    root.savedNetworks = data.networks.filter(n => n.isSaved)
                    root.availableNetworks = data.networks.filter(n => !n.isSaved)

                    root.lastError = ""
                } catch (e) {
                    root.lastError = "Failed to parse wifi status: " + e
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
            root.pendingNetwork = ""
            root.pendingAction = ""
            root.update()
        }
    }

    function update() {
        root.loading = true
        statusProcess.running = true
    }

    function toggleRadio() {
        actionProcess.command = [root.scriptPath, "radio", root.radioEnabled ? "off" : "on"]
        actionProcess.running = true
    }

    function scan() {
        root.loading = true
        actionProcess.command = [root.scriptPath, "scan"]
        actionProcess.running = true
    }

    function connect(name, password) {
        root.pendingNetwork = name
        root.pendingAction = "connecting"
        root.loading = true

        if (password) {
            actionProcess.command = [root.scriptPath, "connect", name, password]
        } else {
            actionProcess.command = [root.scriptPath, "connect", name]
        }

        actionProcess.running = true
    }

    function disconnect() {
        const connected = root.savedNetworks.concat(root.availableNetworks).find(n => n.isConnected)

        root.pendingNetwork = connected ? connected.name : ""
        root.pendingAction = "disconnecting"
        root.loading = true

        actionProcess.command = [root.scriptPath, "disconnect"]
        actionProcess.running = true
    }

    Component.onCompleted: update()
}