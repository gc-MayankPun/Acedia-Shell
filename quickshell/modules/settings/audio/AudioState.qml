pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    property string defaultSink: ""
    property string defaultSource: ""

    property int volume: 0
    property bool muted: false

    property var sinks: []
    property var sources: []


    // --------------------------------------------------
    // Get default audio input volume
    // --------------------------------------------------

    Process {
        id: sourceVolumeProcess

        command: [
            "wpctl",
            "get-volume",
            "@DEFAULT_AUDIO_SOURCE@"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const output = text.trim()

                console.log("Volume output:", output)

                const match = output.match(
                    /Volume:\s+([0-9.]+)/
                )

                if (!match)
                    return

                root.volume = Math.round(
                    parseFloat(match[1]) * 100
                )

                root.muted = output.includes("[MUTED]")

                console.log(
                    "Audio volume:",
                    root.volume
                )

                console.log(
                    "Audio muted:",
                    root.muted
                )
            }
        }
    }


    // --------------------------------------------------
    // Get audio devices
    // --------------------------------------------------

    Process {
        id: statusProcess

        command: [
            "wpctl",
            "status"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                console.log("wpctl status:\n" + text)

                parseStatus(text)
            }
        }
    }


    // --------------------------------------------------
    // Parse wpctl status
    // --------------------------------------------------

    function parseStatus(output) {
    const lines = output.split("\n")

    let section = ""
    let audioSection = false

    const newSources = []
    const newSinks = []

    root.defaultSource = ""
    root.defaultSink = ""

    for (const line of lines) {
        const trimmed = line.trim()

        if (trimmed === "Audio") {
            audioSection = true
            section = ""
            continue
        }

        if (
            trimmed === "Video" ||
            trimmed === "Settings"
        ) {
            audioSection = false
            section = ""
            continue
        }

        if (!audioSection)
            continue

        if (trimmed.includes("Sinks:")) {
            section = "sinks"
            continue
        }

        if (trimmed.includes("Sources:")) {
            section = "sources"
            continue
        }

        if (
            trimmed.includes("Filters:") ||
            trimmed.includes("Streams:")
        ) {
            section = ""
            continue
        }

        if (!section)
            continue

        const cleanLine = trimmed.replace(
            /^[│├└─\s]+/,
            ""
        )

        const match = cleanLine.match(
            /^(\*)?\s*(\d+)\.\s+(.+)$/
        )

        if (!match)
            continue

        const isDefault = match[1] === "*"
        const id = parseInt(match[2])
        const name = match[3].trim()

        const device = {
            id: id,
            name: name,
            isDefault: isDefault
        }

        if (section === "sources") {
            newSources.push(device)

            if (isDefault)
                root.defaultSource = name
        }

        if (section === "sinks") {
            newSinks.push(device)

            if (isDefault)
                root.defaultSink = name
        }
    }

    root.sources = newSources
    root.sinks = newSinks
}


    // --------------------------------------------------
    // Update
    // --------------------------------------------------

    function updateVolume() {
        sourceVolumeProcess.running = true
    }

    function updateDevices() {
        statusProcess.running = true
    }

    function update() {
    updateVolume()
    updateDevices()
}

Timer {
    interval: 500
    running: true
    repeat: true

    onTriggered: {
        updateVolume()
    }
}

Component.onCompleted: {
    update()
}


    // --------------------------------------------------
    // Initial update
    // --------------------------------------------------

    // Component.onCompleted: {
    //     update()
    // }
}