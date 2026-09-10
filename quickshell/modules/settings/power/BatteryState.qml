pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    property var profiles: []
    property string activeProfile: ""
    property bool loading: false
    property string lastError: ""

    readonly property var profileMeta: ({
        "power-saver": {
            label: "Power Saver",
            icon: "\udb80\udc79",
            description: "Lower performance, longer battery life"
        },
        "balanced": {
            label: "Balanced",
            icon: "\udb81\udd94",
            description: "Balances performance and battery life"
        },
        "performance": {
            label: "Performance",
            icon: "\uf0e7",
            description: "Maximum performance, uses more power"
        }
    })

    Process {
        id: listProcess

        command: ["bash", "-lc", "powerprofilesctl list"]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.split("\n")
                const found = []
                let current = ""

                for (const line of lines) {
                    const match = line.match(/^(\*)?\s*([\w-]+):\s*$/)

                    if (!match)
                        continue

                    const isActive = !!match[1]
                    const name = match[2]

                    found.push(name)

                    if (isActive)
                        current = name
                }

                root.profiles = found
                root.activeProfile = current
                root.lastError = found.length === 0
                    ? "No profiles detected. Is power-profiles-daemon installed and running?"
                    : ""
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
            root.update()
        }
    }

    function update() {
        root.loading = true
        listProcess.running = true
    }

    function setProfile(name) {
        root.loading = true
        root.lastError = ""

        setProcess.command = [
            "bash",
            "-lc",
            "powerprofilesctl set " + name
        ]

        setProcess.running = true
    }

    Component.onCompleted: {
        update()
    }
}