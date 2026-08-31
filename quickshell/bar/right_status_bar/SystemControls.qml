import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

import "../../theme"

Rectangle {
    id: capsule

    implicitWidth: content.implicitWidth + 30
    implicitHeight: content.implicitHeight + 10

    radius: Theme.radiusPill
    color: Theme.background

    RowLayout {
        id: content

        anchors.centerIn: parent
        spacing: 10
 
        // Volume 
        RowLayout {
            id: volume

            spacing: 7

            property var sink: Pipewire.defaultAudioSink

            readonly property bool ready: sink && sink.ready
            readonly property bool muted: ready && sink.audio.muted
            readonly property int vol: ready
                ? Math.round(sink.audio.volume * 100)
                : 0

            readonly property string icon: {
                if (!ready) return String.fromCodePoint(0xF0581)
                if (muted) return "󰖁"

                if (vol === 0) return String.fromCodePoint(0xF0581)
                if (vol < 34) return String.fromCodePoint(0xF057F)
                if (vol < 67) return String.fromCodePoint(0xF0580)

                return String.fromCodePoint(0xF057E)
            }

            Text {
                text: volume.icon
                color: "#f5cd5b"
                font {
                    family: "JetBrainsMono Nerd Font Propo"
                    pixelSize: 13
                }
            }

            Text {
                text: {
                    if (!volume.ready) return "-"
                    if (volume.muted) return "Muted"

                    return volume.vol + "%"
                }
                color: volume.muted
                    ? "#c4b09a"
                    : "#f5e2c5"
                font {
                    family: "SF Pro Display"
                    weight: 500
                }
            }

            PwObjectTracker {
                objects: [volume.sink]
            }
        }

        // Separator
        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 14

            color: Theme.border
        }

        // Brightness
        RowLayout {
            id: brightness

            spacing: 7

            readonly property int value: Brightness.percentage

            readonly property string icon: {
                if (value <= 0)
                    return "󰃞"

                if (value < 34)
                    return "󰃚"

                if (value < 67)
                    return "󰃛"

                return "󰃠"
            }

            Text {
                text: brightness.icon

                color: "#f5cd5b"

                font {
                    family: "JetBrainsMono Nerd Font Propo"
                    pixelSize: 13
                }
            }

            Text {
                text: brightness.value + "%"

                color: "#f5e2c5"

                font {
                    family: "SF Pro Display"
                    weight: 500
                }
            }
        }
    }
}