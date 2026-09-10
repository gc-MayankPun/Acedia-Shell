pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    property var devices: []
    property var pairedDevices: []
    property var availableDevices: []
    property bool loading: false
    property int infoIndex: 0

    // Persistent interactive bluetoothctl session. Commands are
    // written to its stdin so the registered agent stays alive
    // for the whole app session, instead of dying when a one-shot
    // process exits (which is why pair/connect were failing).
    Process {
        id: ctl

        command: ["bluetoothctl"]
        running: true
        stdinEnabled: true

        // NOTE: verify against your Quickshell version — this
        // assumes Process exposes write(text). If your version
        // uses a different method/property for stdin, swap it in
        // here; every call below goes through this one function.
        function send(line) {
            ctl.write(line + "\n")
        }

        Component.onCompleted: {
            send("agent NoInputNoOutput")
            send("default-agent")
            send("power on")
        }
    }

    // Gives bluetoothctl a moment to process a command before
    // we re-scan/refresh state.
    Timer {
        id: refreshTimer
        interval: 2000
        onTriggered: root.update()
    }

    Process {
        id: scanProcess

        command: [
            "bluetoothctl",
            "--timeout",
            "5",
            "scan",
            "on"
        ]

        onExited: {
            devicesProcess.running = true
        }
    }

    Process {
        id: devicesProcess

        command: [
            "bluetoothctl",
            "devices"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")
                const newDevices = []

                for (const line of lines) {
                    const match = line.match(
                        /^Device\s+([0-9A-Fa-f:]+)\s+(.+)$/
                    )

                    if (!match)
                        continue

                    newDevices.push({
                        address: match[1],
                        name: match[2],
                        paired: false,
                        connected: false
                    })
                }

                root.devices = newDevices
                root.infoIndex = 0
                root.runNextInfo()
            }
        }
    }

    Process {
        id: infoProcess

        stdout: StdioCollector {
            onStreamFinished: {
                const dev = root.devices[root.infoIndex]

                if (dev) {
                    dev.paired = /Paired:\s*yes/i.test(text)
                    dev.connected = /Connected:\s*yes/i.test(text)
                }

                root.infoIndex++
                root.runNextInfo()
            }
        }
    }

    function runNextInfo() {
        if (root.infoIndex >= root.devices.length) {
            finalizeDevices()
            return
        }

        infoProcess.command = [
            "bluetoothctl",
            "info",
            root.devices[root.infoIndex].address
        ]

        infoProcess.running = true
    }

    function finalizeDevices() {
        const paired = []
        const available = []

        for (const device of root.devices) {
            if (device.paired)
                paired.push(device)
            else
                available.push(device)
        }

        root.pairedDevices = paired
        root.availableDevices = available
        root.loading = false
    }

    function update() {
        root.loading = true
        scanProcess.running = true
    }

    function scan() {
        root.loading = true
        scanProcess.running = true
    }

    // pair/connect/disconnect now go through the persistent
    // session so the registered agent actually applies to them.
    function pair(address) {
        root.loading = true
        ctl.send("pair " + address)
        refreshTimer.restart()
    }

    function connect(address) {
        root.loading = true
        ctl.send("connect " + address)
        refreshTimer.restart()
    }

    function disconnect(address) {
        root.loading = true
        ctl.send("disconnect " + address)
        refreshTimer.restart()
    }

    Component.onCompleted: {
        update()
    }
}