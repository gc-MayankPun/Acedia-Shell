pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    readonly property string scriptPath: Quickshell.env("HOME") + "/.config/quickshell/scripts/battery.sh"

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
        id: statusProcess

        command: [root.scriptPath, "status"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text)

                    root.profiles = data.profiles
                    root.activeProfile = data.activeProfile

                    root.lastError = data.profiles.length === 0
                        ? "No profiles detected."
                        : ""
                } catch (e) {
                    root.lastError = "Failed to parse battery status: " + e
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

    function setProfile(name) {
        root.loading = true
        actionProcess.command = [root.scriptPath, "set", name]
        actionProcess.running = true
    }

    function cycleProfile() {
        if (root.profiles.length === 0)
            return

        const idx = root.profiles.indexOf(root.activeProfile)
        const nextIdx = (idx + 1) % root.profiles.length

        root.setProfile(root.profiles[nextIdx])
    }

    Component.onCompleted: update()
}