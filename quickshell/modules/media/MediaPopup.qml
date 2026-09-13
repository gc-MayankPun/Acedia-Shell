import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

import "../../config" as Config
import "../../components" as Components

PanelWindow {
    id: root

    IpcHandler {
        target: "media-popup"

        function toggle() { MediaState.toggle() }
    }

    WlrLayershell.layer: WlrLayer.Overlay

    WlrLayershell.keyboardFocus:
        MediaState.isMediaPopupOpen
            ? WlrKeyboardFocus.Exclusive
            : WlrKeyboardFocus.None

    WlrLayershell.namespace: "media-popup"

    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    color: "transparent"

    exclusionMode: ExclusionMode.Ignore

    mask: Region {
        item: MediaState.isMediaPopupOpen ? bar : null
    }

    MouseArea {
        anchors.fill: parent
        enabled: MediaState.isMediaPopupOpen

        onClicked: {
            if (!bar.containsMouse)
                MediaState.hide()
        }
    }

    Item {
        id: bar

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter 
        height: 500
        width: MediaState.isMediaPopupOpen ? 500 : 0
        opacity: MediaState.isMediaPopupOpen ? 1 : 0
        clip: true

        Behavior on opacity {
            NumberAnimation {
                duration: Config.Theme.animVerySlow
                easing.type: Config.Theme.springEasing
            }
        }

        Behavior on width {
            NumberAnimation {
                duration: Config.Theme.animVerySlow
                easing: Config.Theme.smoothEasing
            }
        }

        Components.PopupShape {
            anchors.fill: parent

            attachedEdge: "left"
            color: Config.Theme.background

            radius: 18

            flareWidth: 18
            flareHeight: 18
        }

        Item {
            anchors {
                fill: parent
                topMargin: 20
                leftMargin: 30
                rightMargin: 20
                bottomMargin: 24
            }

            ColumnLayout {
                anchors {
                    fill: parent
                    centerIn: parent
                }

                spacing: 14

                // Empty state
                ColumnLayout {
                    visible: !MediaState.hasLoadedOnce || !MediaState.hasPlayer
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    anchors.fill: parent
                    anchors.margins: 30

                    Item { Layout.fillHeight: true }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "\udb80\udecb"
                        color: Config.Theme.textMuted
                        font {
                            family: Config.Theme.fontFamily
                            pixelSize: 40
                        }
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Nothing playing"
                        color: Config.Theme.textMuted
                        font {
                            family: Config.Theme.fontFamily
                            pixelSize: Config.Theme.fontSmall - 1
                        }
                    }

                    Item { Layout.fillHeight: true }
                }
 
                ColumnLayout {
                    visible: MediaState.hasLoadedOnce && MediaState.hasPlayer
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 18
                    anchors.fill: parent
                    anchors.margins: 20

                    // Character gif
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                        Layout.preferredHeight: 200
                        radius: Config.Theme.radiusMedium 
                        color: "transparent"
                        clip: true

                        AnimatedImage {
                            id: mediaGif
                            anchors.fill: parent
                            source: {
                                const base = Quickshell.env("HOME") + "/.config/quickshell/assets/images/"
                                switch (MediaState.source) {
                                    case "spotify": return "file://" + base + "media-spotify.gif"
                                    case "browser": return "file://" + base + "media-browser.gif"
                                    default: return "file://" + base + "media.gif"
                                }
                            }
                            fillMode: Image.PreserveAspectFit
                            playing: MediaState.playing
                            cache: true
                        }
                    }

                    // Title / artist + small album art thumbnail
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
 
                        Rectangle {
                            Layout.preferredWidth: 60
                            Layout.preferredHeight: 60
                            radius: Config.Theme.radiusMedium
                            color: Config.Theme.surfaceAlt
                            clip: true

                            Image {
                                id: albumArtImage
                                anchors.fill: parent
                                source: MediaState.artUrl
                                fillMode: Image.PreserveAspectCrop
                                visible: MediaState.artUrl !== "" && status === Image.Ready
                                asynchronous: true

                                sourceSize.width: 120
                                sourceSize.height: 120

                                layer.enabled: true
                                layer.smooth: true
                                layer.textureSize: Qt.size(width * 4, height * 4)
                                layer.effect: MultiEffect {
                                    maskEnabled: true
                                    maskSource: albumArtMask
                                    maskThresholdMin: 0.5
                                    maskSpreadAtMin: 1.0
                                }
                            }

                            Rectangle {
                                id: albumArtMask
                                anchors.fill: parent
                                radius: Config.Theme.radiusMedium
                                color: "white"
                                antialiasing: true
                                visible: false
                                layer.enabled: true
                                layer.smooth: true
                                layer.textureSize: Qt.size(width * 4, height * 4)
                            }

                            Text {
                                anchors.centerIn: parent
                                visible: MediaState.artUrl === ""
                                text: "\udb80\udecb"
                                color: Config.Theme.textMuted
                                font {
                                    family: Config.Theme.fontFamily
                                    pixelSize: Config.Theme.fontSize - 4
                                }
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1

                            Text {
                                Layout.fillWidth: true
                                text: MediaState.title !== "" ? MediaState.title : "Unknown title"
                                color: Config.Theme.text
                                elide: Text.ElideRight
                                font {
                                    family: Config.Theme.fontFamily
                                    pixelSize: Config.Theme.fontSmall
                                    bold: true
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                text: {
                                    const a = MediaState.artist !== "" ? MediaState.artist : "Unknown artist"
                                    return MediaState.album !== "" ? a + " · " + MediaState.album : a
                                }
                                color: Config.Theme.textMuted
                                elide: Text.ElideRight
                                font {
                                    family: Config.Theme.fontFamily
                                    pixelSize: Config.Theme.fontSmall - 2
                                }
                            }
                        }
                    }

                    // Progress bar with time labels
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: Math.floor(MediaState.position / 60) + ":" + String(MediaState.position % 60).padStart(2, "0")
                            color: Config.Theme.textMuted
                            font {
                                family: Config.Theme.fontFamily
                                pixelSize: Config.Theme.fontSmall - 3
                            }
                        }

                        Rectangle {
                            id: progressBar

                            Layout.fillWidth: true
                            Layout.preferredHeight: 4
                            Layout.alignment: Qt.AlignVCenter
                            radius: 2
                            color: Config.Theme.surfaceAlt

                            Rectangle {
                                height: parent.height
                                radius: 2
                                color: Config.Theme.text
                                width: MediaState.length > 0
                                    ? parent.width * Math.min(1, MediaState.position / MediaState.length)
                                    : 0

                                Behavior on width {
                                    NumberAnimation { duration: 200 }
                                }
                            }

                            Rectangle {
                                width: 12
                                height: 12
                                radius: 6
                                color: Config.Theme.text
                                anchors.verticalCenter: parent.verticalCenter
                                x: MediaState.length > 0
                                    ? Math.min(parent.width - width, parent.width * (MediaState.position / MediaState.length) - width / 2)
                                    : 0

                                Behavior on x {
                                    NumberAnimation { duration: 200 }
                                }
                            }
                        }

                        Text {
                            text: Math.floor(MediaState.length / 60) + ":" + String(MediaState.length % 60).padStart(2, "0")
                            color: Config.Theme.textMuted
                            font {
                                family: Config.Theme.fontFamily
                                pixelSize: Config.Theme.fontSmall - 3
                            }
                        }
                    }

                    // Control row — shuffle / prev / play-pause (circled) / next / repeat
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 4
                        spacing: 26

                        Text {
                            text: "\uf048"
                            color: Config.Theme.text
                            font {
                                family: Config.Theme.fontFamily
                                pixelSize: Config.Theme.fontSize
                            }

                            MouseArea {
                                anchors.fill: parent
                                anchors.margins: -8
                                cursorShape: Qt.PointingHandCursor
                                onClicked: MediaState.previous()
                            }
                        }

                        Rectangle {
                            width: 56
                            height: 56
                            radius: 28
                            color: "transparent"
                            border.width: 2
                            border.color: Config.Theme.text

                            Text {
                                anchors.centerIn: parent
                                text: MediaState.playing ? "\udb80\udfe4" : "\udb81\udc0a"
                                color: Config.Theme.text
                                font {
                                    family: Config.Theme.fontFamily
                                    pixelSize: Config.Theme.fontSize
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: MediaState.playPause()
                            }
                        }

                        Text {
                            text: "\uf051"
                            color: Config.Theme.text
                            font {
                                family: Config.Theme.fontFamily
                                pixelSize: Config.Theme.fontSize
                            }

                            MouseArea {
                                anchors.fill: parent
                                anchors.margins: -8
                                cursorShape: Qt.PointingHandCursor
                                onClicked: MediaState.next()
                            }
                        }
                    }
                }

                Text {
                    visible: MediaState.lastError.length > 0
                    Layout.fillWidth: true
                    text: MediaState.lastError
                    color: "#e06060"
                    wrapMode: Text.WordWrap
                    font {
                        family: Config.Theme.fontFamily
                        pixelSize: Config.Theme.fontSmall - 3
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            z: -1
            onClicked: mouse.accepted = true
        }
    }
}