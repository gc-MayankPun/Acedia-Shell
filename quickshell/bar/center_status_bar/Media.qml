import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts

import "../../theme"

Rectangle {
    id: capsule

    implicitWidth: content.implicitWidth + 16
    implicitHeight: content.implicitHeight + 10

    radius: Theme.radiusPill
    color: Theme.background

    property var lastPlayingPlayer: null
    property var player: lastPlayingPlayer
 
    // Track the player that is actually playing 
    Repeater {
        model: Mpris.players

        delegate: Connections {
            required property var modelData

            target: modelData

            function onPlaybackStateChanged() {
                if (modelData.playbackState === MprisPlaybackState.Playing) 
                capsule.lastPlayingPlayer = modelData
            }
        }
    }

    Component.onCompleted: {
        var playing = Mpris.players.values.find(
            p => p.playbackState === MprisPlaybackState.Playing
        )

        if (playing) lastPlayingPlayer = playing
    }

    // Content
    RowLayout {
        id: content

        anchors.centerIn: parent
        spacing: 3

        // Visualizer
        Item {
            Layout.preferredWidth: 18
            Layout.preferredHeight: 18

            Row {
                anchors.centerIn: parent
                spacing: 2

                Rectangle {
                    width: 3
                    height: 7
                    radius: 2

                    color: capsule.player && capsule.player.playbackState === MprisPlaybackState.Playing
                    ? Theme.primary
                    : Theme.textMuted

                    SequentialAnimation on height {
                        running: capsule.player &&
                        capsule.player.playbackState === MprisPlaybackState.Playing

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
                }

                Rectangle {
                    width: 3
                    height: 12
                    radius: 2

                    color: capsule.player &&
                    capsule.player.playbackState === MprisPlaybackState.Playing
                    ? Theme.primary
                    : Theme.textMuted

                    SequentialAnimation on height {
                        running: capsule.player &&
                        capsule.player.playbackState === MprisPlaybackState.Playing

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
                }

                Rectangle {
                    width: 3
                    height: 6
                    radius: 2

                    color: capsule.player &&
                    capsule.player.playbackState === MprisPlaybackState.Playing
                    ? Theme.primary
                    : Theme.textMuted

                    SequentialAnimation on height {
                        running: capsule.player &&
                        capsule.player.playbackState === MprisPlaybackState.Playing

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
                }
            }
        }
 
        // Track 
        Text {
            Layout.preferredWidth: Math.min(
                implicitWidth,
                130
            )

            Layout.maximumWidth: 130

            text: capsule.player
            ? capsule.player.trackTitle
            : "Nothing playing"

            color: Theme.text

            elide: Text.ElideRight

            font {
                family: Theme.fontFamily
                pixelSize: 11
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

            icon: capsule.player &&
            capsule.player.playbackState === MprisPlaybackState.Playing
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