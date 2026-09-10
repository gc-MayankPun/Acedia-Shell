import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../../../config" as Config

RowLayout {
    id: root

    anchors.fill: parent
    // spacing: 10

    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true

        color: "transparent"

        ColumnLayout {
            // anchors.fill: parent

            // anchors.leftMargin: 10
            // anchors.topMargin: 10
            // anchors.rightMargin: 10
            // anchors.bottomMargin: 10

             width: 600

            x: 10
            y: 10


            // spacing: 14
            spacing: 20

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    Layout.fillWidth: true

                    text: "Night Light"

                    color: Config.Theme.text

                    font {
                        family: Config.Theme.fontFamily
                        pixelSize: Config.Theme.fontSmall
                        bold: true
                    }
                }

                Text {
                    visible: NightLightState.loading

                    text: "Applying…"

                    color: Config.Theme.textMuted

                    font {
                        family: Config.Theme.fontFamily
                        pixelSize: Config.Theme.fontSmall - 2
                    }
                }
            }

            Text {
                visible: NightLightState.lastError.length > 0

                Layout.fillWidth: true

                text: NightLightState.lastError

                color: "#e06060"

                wrapMode: Text.WordWrap

                font {
                    family: Config.Theme.fontFamily
                    pixelSize: Config.Theme.fontSmall - 2
                }
            }

            // Toggle row
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 56

                radius: Config.Theme.radiusMedium
                color: NightLightState.enabled
                    ? Config.Theme.primary
                    : "transparent"

                border.width: NightLightState.enabled ? 0 : 1
                border.color: Config.Theme.tertiary

                Behavior on color {
                    ColorAnimation { duration: 120 }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 10

                    Rectangle {
                        width: 34
                        height: 34

                        color: NightLightState.enabled
                            ? Config.Theme.surface
                            : Config.Theme.surfaceAlt
                        radius: Config.Theme.radiusMedium

                        Text {
                            anchors.centerIn: parent

                            text: "\udb81\udd94"

                            color: NightLightState.enabled
                                ? Config.Theme.primary
                                : Config.Theme.text

                            font {
                                family: Config.Theme.fontFamily
                                pixelSize: Config.Theme.fontSize
                            }
                        }
                    }

                    Text {
                        Layout.fillWidth: true

                        text: NightLightState.enabled ? "On" : "Off"

                        color: NightLightState.enabled
                            ? Config.Theme.surface
                            : Config.Theme.text

                        font {
                            family: Config.Theme.fontFamily
                            pixelSize: Config.Theme.fontSmall - 1
                            bold: true
                        }
                    }

                    // iOS-style toggle switch
                    Rectangle {
                        id: switchTrack

                        width: 46
                        height: 26
                        radius: 13

                        color: NightLightState.enabled
                            ? Config.Theme.surface
                            : Config.Theme.surfaceAlt

                        Behavior on color {
                            ColorAnimation { duration: 120 }
                        }

                        Rectangle {
                            width: 20
                            height: 20
                            radius: 10

                            anchors.verticalCenter: parent.verticalCenter

                            x: NightLightState.enabled
                                ? parent.width - width - 3
                                : 3

                            Behavior on x {
                                NumberAnimation {
                                    duration: 150
                                    easing.type: Easing.OutCubic
                                }
                            }

                            color: NightLightState.enabled
                                ? Config.Theme.primary
                                : Config.Theme.textMuted
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent

                    acceptedButtons: Qt.LeftButton
                    propagateComposedEvents: false

                    cursorShape: Qt.PointingHandCursor

                    onClicked: { NightLightState.toggle() }
                }
            }

            // Temperature slider
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                opacity: NightLightState.enabled ? 1 : 0.4

                Behavior on opacity {
                    NumberAnimation { duration: 150 }
                }

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true

                        text: "Warmth"

                        color: Config.Theme.text

                        font {
                            family: Config.Theme.fontFamily
                            pixelSize: Config.Theme.fontSmall - 1
                        }
                    }

                    Text {
                        text: NightLightState.temperature + "K"

                        color: Config.Theme.textMuted

                        font {
                            family: Config.Theme.fontFamily
                            pixelSize: Config.Theme.fontSmall - 2
                        }
                    }
                }

                Slider {
                    id: tempSlider

                    Layout.fillWidth: true

                    enabled: NightLightState.enabled

                    from: NightLightState.minTemperature
                    to: NightLightState.maxTemperature
                    stepSize: 100

                    value: NightLightState.temperature

                    onPressedChanged: {
                        if (!pressed)
                            NightLightState.setTemperature(Math.round(value))
                    }

                    background: Rectangle {
                        x: tempSlider.leftPadding
                        y: tempSlider.topPadding + tempSlider.availableHeight / 2 - height / 2
                        width: tempSlider.availableWidth
                        height: 4
                        radius: 2
                        color: Config.Theme.surfaceAlt

                        Rectangle {
                            width: tempSlider.visualPosition * parent.width
                            height: parent.height
                            radius: 2
                            color: Config.Theme.primary
                        }
                    }

                    handle: Rectangle {
                        x: tempSlider.leftPadding + tempSlider.visualPosition * (tempSlider.availableWidth - width)
                        y: tempSlider.topPadding + tempSlider.availableHeight / 2 - height / 2
                        width: 16
                        height: 16
                        radius: 8
                        color: Config.Theme.primary
                    }
                }

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Warmer"
                        color: Config.Theme.textMuted
                        font {
                            family: Config.Theme.fontFamily
                            pixelSize: Config.Theme.fontSmall - 3
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "Cooler"
                        color: Config.Theme.textMuted
                        font {
                            family: Config.Theme.fontFamily
                            pixelSize: Config.Theme.fontSmall - 3
                        }
                    }
                }
            }
        }
    }
}