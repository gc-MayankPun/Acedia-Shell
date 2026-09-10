import QtQuick
import QtQuick.Layouts

import "../../config" as Config

RowLayout {
    anchors.fill: parent
    spacing: 10

    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: "transparent"

        ColumnLayout {
            x: 10
            y: 10
            spacing: 0

            Text {
                text: root.isBluetooth ? "Bluetooth device" : "Wi-Fi network"
                color: Config.Theme.text
                font {
                    family: Config.Theme.fontFamily
                    pixelSize: Config.Theme.fontSmall
                }
            }

            Text {
                text: "Looking for devices..."
                color: Config.Theme.textMuted
                font {
                    family: Config.Theme.fontFamily
                    pixelSize: Config.Theme.fontSmall - 1
                }
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: "transparent"

        ColumnLayout {
            x: 10
            y: 10
            spacing: 10

            Text {
                anchors.right: parent.right
                text: "\udb81\udc53"
                color: Config.Theme.text
                font {
                    family: Config.Theme.fontFamily
                    pixelSize: Config.Theme.fontSize
                }
            }

            ColumnLayout {
                spacing: 10
                Repeater {
                    model: 2

                    Rectangle {
                        color: "transparent"
                        height: 35
                        width: 280

                        RowLayout {
                            anchors.fill: parent

                            RowLayout {
                                spacing: 10
                                Rectangle {
                                    color: Config.Theme.surfaceAlt
                                    height: 30
                                    width: 30
                                    radius: Config.Theme.radiusMedium

                                    Text {
                                        text: "\uf294"
                                        anchors.centerIn: parent
                                        color: Config.Theme.text
                                        font {
                                            family: Config.Theme.fontFamily
                                            pixelSize: Config.Theme.fontSize
                                        }
                                    }
                                }

                                ColumnLayout {
                                    spacing: 0
                                    Text {
                                        text: "Sdad-dada-fad3a-da"
                                        color: Config.Theme.text
                                        font {
                                            family: Config.Theme.fontFamily
                                            pixelSize: Config.Theme.fontSmall - 1
                                        }
                                    }

                                    Text {
                                        visible: root.isBluetooth
                                        text: "Sdad-dada-fad3a-da"
                                        color: Config.Theme.textMuted
                                        font {
                                            family: Config.Theme.fontFamily
                                            pixelSize: Config.Theme.fontSmall - 2
                                        }
                                    }
                                }
                            }

                            Text {
                                text: root.isBluetooth ? "Pair" : "Connect"
                                color: Config.Theme.batCharging
                                font {
                                    family: Config.Theme.fontFamily
                                    pixelSize: Config.Theme.fontSmall - 1
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}