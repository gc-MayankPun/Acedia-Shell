pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    property var networks: []
    property var savedNetworks: []
    property var availableNetworks: []
    property bool loading: false
    property string wifiDevice: ""

    Process {
        id: savedProcess

        command: [
            "nmcli",
            "-t",
            "-e",
            "no",
            "-f",
            "NAME,TYPE",
            "connection",
            "show"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")
                const saved = []

                for (const line of lines) {
                    if (!line)
                        continue

                    const separator = line.lastIndexOf(":")

                    if (separator === -1)
                        continue

                    const name = line.slice(0, separator).trim()
                    const type = line.slice(separator + 1).trim()

                    if (type !== "802-11-wireless")
                        continue

                    if (!name)
                        continue

                    if (saved.some(network => network.name === name))
                        continue

                    saved.push({
                        name: name,
                        isConnected: false
                    })
                }

                root.savedNetworks = saved
                scanProcess.running = true
            }
        }
    }

    Process {
        id: scanProcess

        command: [
            "nmcli",
            "device",
            "wifi",
            "rescan"
        ]

        onExited: {
            wifiProcess.running = true
        }
    }

    Process {
        id: wifiProcess

        command: [
            "nmcli",
            "-t",
            "-e",
            "no",
            "-f",
            "IN-USE,SSID,SIGNAL,SECURITY",
            "device",
            "wifi",
            "list"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")
                const visible = []

                for (const line of lines) {
                    if (!line)
                        continue

                    const parts = line.split(":")

                    if (parts.length < 4)
                        continue

                    const inUse = parts[0]
                    const security = parts[parts.length - 1]
                    const signal = parts[parts.length - 2]
                    const name = parts
                        .slice(1, parts.length - 2)
                        .join(":")
                        .trim()

                    if (!name)
                        continue

                    const existing = visible.find(
                        network => network.name === name
                    )

                    if (existing) {
                        if (inUse === "*")
                            existing.isConnected = true

                        if (Number(signal) > Number(existing.signal))
                            existing.signal = signal

                        continue
                    }

                    visible.push({
                        name: name,
                        signal: signal,
                        security: security,
                        isConnected: inUse === "*"
                    })
                }

                const saved = []
                const available = []

                for (const network of root.savedNetworks) {
                    const visibleNetwork = visible.find(
                        item => item.name === network.name
                    )

                    if (!visibleNetwork)
                        continue

                    saved.push({
                        name: network.name,
                        signal: visibleNetwork.signal,
                        security: visibleNetwork.security,
                        isConnected: visibleNetwork.isConnected
                    })
                }

                for (const network of visible) {
                    const isSaved = root.savedNetworks.some(
                        savedNetwork => savedNetwork.name === network.name
                    )

                    if (!isSaved)
                        available.push(network)
                }

                root.networks = visible
                root.savedNetworks = saved
                root.availableNetworks = available
                root.loading = false
            }
        }
    }

    Process {
        id: connectProcess

        onExited: {
            root.update()
        }
    }

    // Finds the actual wifi interface name (e.g. wlan0) since
    // `nmcli device disconnect` requires a device, not "type wifi"
    // which isn't valid syntax and was failing every time.
    Process {
        id: deviceNameProcess

        command: [
            "nmcli",
            "-t",
            "-f",
            "DEVICE,TYPE",
            "device",
            "status"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")

                for (const line of lines) {
                    const parts = line.split(":")

                    if (parts.length < 2)
                        continue

                    if (parts[1] === "wifi") {
                        root.wifiDevice = parts[0]
                        break
                    }
                }

                if (!root.wifiDevice) {
                    root.loading = false
                    return
                }

                disconnectProcess.command = [
                    "nmcli",
                    "device",
                    "disconnect",
                    root.wifiDevice
                ]

                disconnectProcess.running = true
            }
        }
    }

    Process {
        id: disconnectProcess

        onExited: {
            root.update()
        }
    }

    function update() {
        root.loading = true
        savedProcess.running = true
    }

    // password is optional — required for a brand-new secured
    // network that has no saved profile yet; existing saved
    // networks connect fine without it.
    function connect(name, password) {
        root.loading = true

        const cmd = [
            "nmcli",
            "device",
            "wifi",
            "connect",
            name
        ]

        if (password) {
            cmd.push("password", password)
        }

        connectProcess.command = cmd
        connectProcess.running = true
    }

    function disconnect() {
        root.loading = true
        deviceNameProcess.running = true
    }

    Component.onCompleted: {
        update()
    }
}