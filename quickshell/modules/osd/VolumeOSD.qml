import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

import "../../config" as Config

Scope {
    id: root

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property bool shouldShowOsd: false
    property real previousVolume: 0
    property string volumeAction: "increase"

    Connections {
        target: Pipewire.defaultAudioSink?.audio

        function onVolumeChanged() {
            const currentVolume = Pipewire.defaultAudioSink?.audio.volume ?? 0

            if (currentVolume > root.previousVolume)
                root.volumeAction = "increase"
            else if (currentVolume < root.previousVolume)
                root.volumeAction = "decrease"

            root.previousVolume = currentVolume
            root.shouldShowOsd = true
            hideTimer.restart()
        }

        function onMutedChanged() {
            root.shouldShowOsd = true
            hideTimer.restart()
        }
    }

    Timer {
        id: hideTimer
        interval: 1000

        onTriggered: root.shouldShowOsd = false
    }

    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            anchors.bottom: true
            margins.bottom: screen.height / 30
            exclusiveZone: 0

            implicitWidth: 400
            implicitHeight: 50

            color: "transparent"

            mask: Region {}

            Rectangle {
                anchors.fill: parent

                radius: height / 2
                color: Config.Theme.surface

                border.width: 1
                border.color: Config.Theme.border

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 10
                        rightMargin: 15
                    }

                    Text {
                        text: Pipewire.defaultAudioSink?.audio.muted
                            ? "\ueee8"
                            : root.volumeAction === "increase"
                                ? "\uefcf"
                                : "\uf027"

                        color: Config.Theme.primary
                        font.family: Config.Theme.fontFamily
                        font.pixelSize: Config.Theme.fontLarge

                        Layout.preferredWidth: 30
                        Layout.preferredHeight: 30
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 10

                        radius: Config.Theme.radiusPill
                        color: Config.Theme.surfaceAlt

                        Rectangle {
                            anchors {
                                left: parent.left
                                top: parent.top
                                bottom: parent.bottom
                            }

                            width: parent.width *
                                   (Pipewire.defaultAudioSink?.audio.volume ?? 0)

                            radius: parent.radius
                            color: Config.Theme.primary

                            Behavior on width {
                                NumberAnimation {
                                    duration: Config.Theme.animFast
                                    easing.type: Config.Theme.smoothEasing
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 38
                        Text {
                            anchors.centerIn: parent
                            text: Pipewire.defaultAudioSink?.audio.muted
                                ? "Muted"
                                : Math.round(
                                    (Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100
                                  ) + "%"

                            color: Config.Theme.text
                            font.family: Config.Theme.fontFamily
                            font.pixelSize: Config.Theme.fontSmall
                        }
                    }
                }
            }
        }
    }
}