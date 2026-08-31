import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts

import "../../theme"

Rectangle {
    id: capsule

    // Media state
    property var lastPlayingPlayer: null
    property var player: lastPlayingPlayer
    property bool hasMedia: player !== null

    // The full width of the capsule when expanded.
    readonly property real expandedWidth: content.implicitWidth + 16

    // Capsule geometry
    width: hasMedia ? expandedWidth : 0
    height: 30

    radius: Theme.radiusPill
    color: Theme.background

    clip: true

    transformOrigin: Item.Right

    opacity: hasMedia ? 1 : 0
    scale: hasMedia ? 1 : 0.90

    Behavior on width {
        NumberAnimation {
            duration: Animations.normal
            easing.type: Animations.easing
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: Animations.normal
            easing.type: Animations.easing
        }
    }

    Behavior on scale {
        NumberAnimation {
            duration: Animations.normal
            easing.type: Animations.easing
        }
    }

    // Find / track MPRIS players
    Repeater {
        model: Mpris.players

        delegate: Connections {
            required property var modelData

            target: modelData

            function onPlaybackStateChanged() {
                // A new player started playing. 
                if (modelData.playbackState === MprisPlaybackState.Playing) {
                    capsule.lastPlayingPlayer = modelData
                    return
                }

                /**
                  * The current player stopped.
                  * 
                  * Paused is intentionally NOT handled here. 
                  * We want paused tracks to remain visible.
                */
                if (
                    modelData === capsule.lastPlayingPlayer &&
                    modelData.playbackState === MprisPlaybackState.Stopped
                ) {
                    capsule.lastPlayingPlayer = null
                }
            }
        }
    }

    // Handle players being added / removed
    Connections {
        target: Mpris.players

        function onValuesChanged() {

            // If the player we were displaying no longer exists,
            // remove it from the capsule.

            if (
                capsule.lastPlayingPlayer &&
                Mpris.players.values.indexOf(
                    capsule.lastPlayingPlayer
                ) === -1
            ) {
                capsule.lastPlayingPlayer = null
            }

            // If something is currently playing, always prefer it.

            var playing = Mpris.players.values.find(
                p => p.playbackState === MprisPlaybackState.Playing
            )

            if (playing) {
                capsule.lastPlayingPlayer = playing
            }
        }
    }

    // Initial player
    Component.onCompleted: {

        var playing = Mpris.players.values.find(
            p => p.playbackState === MprisPlaybackState.Playing
        )

        if (playing) {
            lastPlayingPlayer = playing
        }
    }

    // Content
    RowLayout {
        id: content

        anchors.centerIn: parent

        spacing: 5

        // Music visualizer
        Item {
            Layout.preferredWidth: 18
            Layout.preferredHeight: 18

            Row {
                anchors.centerIn: parent
                spacing: 2

                // Bar 1 
                Rectangle {
                    width: 3
                    height: 7

                    radius: 2

                    color: capsule.player &&
                        capsule.player.playbackState ===
                        MprisPlaybackState.Playing
                        ? Theme.primary
                        : Theme.textMuted

                    SequentialAnimation on height {
                        running:
                            capsule.player &&
                            capsule.player.playbackState ===
                            MprisPlaybackState.Playing

                        loops: Animation.Infinite

                        NumberAnimation {
                            from: 5
                            to: 12

                            duration: 350

                            easing.type: Easing.InOutSine
                        }

                        NumberAnimation {
                            from: 12
                            to: 6

                            duration: 280

                            easing.type: Easing.InOutSine
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: Animations.fast
                        }
                    }
                }
 
                // Bar 2 
                Rectangle {
                    width: 3
                    height: 12

                    radius: 2

                    color:
                        capsule.player &&
                        capsule.player.playbackState ===
                        MprisPlaybackState.Playing
                        ? Theme.primary
                        : Theme.textMuted

                    SequentialAnimation on height {

                        running:
                            capsule.player &&
                            capsule.player.playbackState ===
                            MprisPlaybackState.Playing

                        loops: Animation.Infinite

                        NumberAnimation {
                            from: 12
                            to: 5

                            duration: 300

                            easing.type: Easing.InOutSine
                        }

                        NumberAnimation {
                            from: 5
                            to: 13

                            duration: 400

                            easing.type: Easing.InOutSine
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: Animations.fast
                        }
                    }
                }

                 // Bar 3 
                Rectangle {
                    width: 3
                    height: 6

                    radius: 2

                    color:
                        capsule.player &&
                        capsule.player.playbackState ===
                        MprisPlaybackState.Playing
                        ? Theme.primary
                        : Theme.textMuted

                    SequentialAnimation on height {

                        running:
                            capsule.player &&
                            capsule.player.playbackState ===
                            MprisPlaybackState.Playing

                        loops: Animation.Infinite

                        NumberAnimation {
                            from: 6
                            to: 11

                            duration: 250

                            easing.type: Easing.InOutSine
                        }

                        NumberAnimation {
                            from: 11
                            to: 4

                            duration: 380

                            easing.type: Easing.InOutSine
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: Animations.fast
                        }
                    }
                }
            }
        }

        // Track name
        Text {
            id: trackName

            Layout.preferredWidth:
                Math.min(implicitWidth, 130)

            Layout.maximumWidth: 130

            text:
                capsule.player
                ? capsule.player.trackTitle
                : ""

            color: Theme.text

            elide: Text.ElideRight

            font {
                family: Theme.fontFamily
                pixelSize: 10
                weight: 600
            }
        }

        // Previous
        MediaButton {
            width: 20
            height: 20

            icon: "󰒮"

            onClicked: {
                if (capsule.player)
                    capsule.player.previous()
            }
        }

        // Play / Pause       
        MediaButton {
            width: 20
            height: 20

            icon:
                capsule.player &&
                capsule.player.playbackState ===
                MprisPlaybackState.Playing
                ? "󰏤"
                : "󰐊"

            normalColor: Theme.text
            hoverColor: Theme.primaryBright

            onClicked: {
                if (capsule.player)
                    capsule.player.togglePlaying()
            }
        }

        // Next 
        MediaButton {
            width: 20
            height: 20

            icon: "󰒭"

            onClicked: {
                if (capsule.player)
                    capsule.player.next()
            }
        }
    }
}