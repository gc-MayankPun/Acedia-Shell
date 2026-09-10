import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../../../config" as Config

RowLayout {
    id: root

    anchors.fill: parent
    spacing: 10

    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true

        color: "transparent"

        ColumnLayout {
            anchors.fill: parent

            anchors.leftMargin: 10
            anchors.topMargin: 10
            anchors.rightMargin: 10
            anchors.bottomMargin: 10

            spacing: 16

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    Layout.fillWidth: true

                    text: "Audio"

                    color: Config.Theme.text

                    font {
                        family: Config.Theme.fontFamily
                        pixelSize: Config.Theme.fontSmall
                        bold: true
                    }
                }

                Text {
                    visible: AudioState.loading

                    text: "Refreshing…"

                    color: Config.Theme.textMuted

                    font {
                        family: Config.Theme.fontFamily
                        pixelSize: Config.Theme.fontSmall - 2
                    }
                }
            }

            Text {
                visible: AudioState.lastError.length > 0

                Layout.fillWidth: true

                text: AudioState.lastError

                color: "#e06060"

                wrapMode: Text.WordWrap

                font {
                    family: Config.Theme.fontFamily
                    pixelSize: Config.Theme.fontSmall - 2
                }
            }

            // ---------- OUTPUT ----------
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "Output"
                    color: Config.Theme.textMuted
                    font {
                        family: Config.Theme.fontFamily
                        pixelSize: Config.Theme.fontSmall - 3
                        bold: true
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 74

                    radius: Config.Theme.radiusMedium
                    color: Config.Theme.surfaceAlt
                    opacity: outputMouse.containsMouse ? 1 : 0.9

                    Behavior on opacity {
                        NumberAnimation { duration: 100 }
                    }

                    MouseArea {
                        id: outputMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.NoButton
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            Rectangle {
                                width: 32
                                height: 32
                                radius: Config.Theme.radiusMedium

                                color: AudioState.muted
                                    ? Qt.rgba(0.88, 0.38, 0.38, 0.18)
                                    : Config.Theme.surface

                                Text {
                                    anchors.centerIn: parent

                                    text: AudioState.muted ? "\udb81\udfce" : "\udb80\udecb"

                                    color: AudioState.muted
                                        ? "#e06060"
                                        : Config.Theme.text

                                    font {
                                        family: Config.Theme.fontFamily
                                        pixelSize: Config.Theme.fontSize - 2
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: AudioState.toggleMute()
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0

                                Text {
                                    Layout.fillWidth: true
                                    text: AudioState.sinkDescription
                                    elide: Text.ElideRight
                                    color: Config.Theme.text
                                    font {
                                        family: Config.Theme.fontFamily
                                        pixelSize: Config.Theme.fontSmall - 1
                                    }
                                }

                                Text {
                                    text: AudioState.muted ? "Muted" : "Output device"
                                    color: Config.Theme.textMuted
                                    font {
                                        family: Config.Theme.fontFamily
                                        pixelSize: Config.Theme.fontSmall - 3
                                    }
                                }
                            }

                            Text {
                                text: (AudioState.muted ? 0 : outputSlider.value) + "%"
                                color: Config.Theme.textMuted
                                font {
                                    family: Config.Theme.fontFamily
                                    pixelSize: Config.Theme.fontSmall - 2
                                }
                            }
                        }

                        Slider {
                            id: outputSlider

                            Layout.fillWidth: true

                            from: 0
                            to: 100
                            stepSize: 1
                            value: AudioState.volume
                            enabled: !AudioState.muted

                            onMoved: AudioState.setVolume(value)

                            background: Rectangle {
                                x: outputSlider.leftPadding
                                y: outputSlider.topPadding + outputSlider.availableHeight / 2 - height / 2
                                width: outputSlider.availableWidth
                                height: 4
                                radius: 2
                                color: Config.Theme.surface

                                Rectangle {
                                    width: outputSlider.visualPosition * parent.width
                                    height: parent.height
                                    radius: 2
                                    color: Config.Theme.primary
                                }
                            }

                            handle: Rectangle {
                                x: outputSlider.leftPadding + outputSlider.visualPosition * (outputSlider.availableWidth - width)
                                y: outputSlider.topPadding + outputSlider.availableHeight / 2 - height / 2
                                width: 14
                                height: 14
                                radius: 7
                                color: Config.Theme.primary
                            }
                        }
                    }
                }
            }

            // ---------- INPUT (MIC) ----------
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "Input"
                    color: Config.Theme.textMuted
                    font {
                        family: Config.Theme.fontFamily
                        pixelSize: Config.Theme.fontSmall - 3
                        bold: true
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 74

                    radius: Config.Theme.radiusMedium
                    color: Config.Theme.surfaceAlt
                    opacity: inputMouse.containsMouse ? 1 : 0.9

                    Behavior on opacity {
                        NumberAnimation { duration: 100 }
                    }

                    MouseArea {
                        id: inputMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.NoButton
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            Rectangle {
                                width: 32
                                height: 32
                                radius: Config.Theme.radiusMedium

                                color: AudioState.micMuted
                                    ? Qt.rgba(0.88, 0.38, 0.38, 0.18)
                                    : Config.Theme.surface

                                Text {
                                    anchors.centerIn: parent

                                    // "mic on" icon is a placeholder guess —
                                    // swap \uf130 for your font's actual glyph
                                    text: AudioState.micMuted ? "\udb80\udf6d" : "\uf130"

                                    color: AudioState.micMuted
                                        ? "#e06060"
                                        : Config.Theme.text

                                    font {
                                        family: Config.Theme.fontFamily
                                        pixelSize: Config.Theme.fontSize - 2
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: AudioState.toggleMicMute()
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0

                                Text {
                                    Layout.fillWidth: true
                                    text: AudioState.sourceDescription
                                    elide: Text.ElideRight
                                    color: Config.Theme.text
                                    font {
                                        family: Config.Theme.fontFamily
                                        pixelSize: Config.Theme.fontSmall - 1
                                    }
                                }

                                Text {
                                    text: AudioState.micMuted ? "Muted" : "Input device"
                                    color: Config.Theme.textMuted
                                    font {
                                        family: Config.Theme.fontFamily
                                        pixelSize: Config.Theme.fontSmall - 3
                                    }
                                }
                            }

                            Text {
                                text: (AudioState.micMuted ? 0 : inputSlider.value) + "%"
                                color: Config.Theme.textMuted
                                font {
                                    family: Config.Theme.fontFamily
                                    pixelSize: Config.Theme.fontSmall - 2
                                }
                            }
                        }

                        Slider {
                            id: inputSlider

                            Layout.fillWidth: true

                            from: 0
                            to: 100
                            stepSize: 1
                            value: AudioState.micVolume
                            enabled: !AudioState.micMuted

                            onMoved: AudioState.setMicVolume(value)

                            background: Rectangle {
                                x: inputSlider.leftPadding
                                y: inputSlider.topPadding + inputSlider.availableHeight / 2 - height / 2
                                width: inputSlider.availableWidth
                                height: 4
                                radius: 2
                                color: Config.Theme.surface

                                Rectangle {
                                    width: inputSlider.visualPosition * parent.width
                                    height: parent.height
                                    radius: 2
                                    color: Config.Theme.primary
                                }
                            }

                            handle: Rectangle {
                                x: inputSlider.leftPadding + inputSlider.visualPosition * (inputSlider.availableWidth - width)
                                y: inputSlider.topPadding + inputSlider.availableHeight / 2 - height / 2
                                width: 14
                                height: 14
                                radius: 7
                                color: Config.Theme.primary
                            }
                        }
                    }
                }
            }

            Item { Layout.fillHeight: true }
        }
    }
}