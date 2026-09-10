import QtQuick
import QtQuick.Layouts

import "../../../config" as Config

Rectangle {
    color: "transparent"
    x: 10
    y: 10

    ColumnLayout {
        spacing: 10
        ColumnLayout {
            spacing: 0
            Text {
                text: "Audio Input"
                color: Config.Theme.text
                font {
                    family: Config.Theme.fontFamily
                    pixelSize: Config.Theme.fontSmall
                }
            }

            Text {
                text: AudioState.sources.length + " available"
                color: Config.Theme.textMuted
                font {
                    family: Config.Theme.fontFamily
                    pixelSize: Config.Theme.fontSmall - 1
                }
            }
        }

        Item {
            height: 45
            width: 600

            Rectangle {
                color: Config.Theme.surface
                height: parent.height
                width: 600
                radius: Config.Theme.radiusPill

                Rectangle {
                    color: Config.Theme.primary
                    height: 35
                    width: (parent.width - 10) * AudioState.volume / 100
                    radius: Config.Theme.radiusPill

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left 
                    anchors.leftMargin: 5

                    Text {
                        anchors.leftMargin: 15
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left

                        text: "\uec1c"

                        color: AudioState.muted
                            ? Config.Theme.textMuted
                            : Config.Theme.surface

                        font {
                            family: Config.Theme.fontFamily
                            pixelSize: Config.Theme.fontSize
                        }
                    }
                }       

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 15
                    text: AudioState.volume + "%"
                    color: Config.Theme.text
                    font {
                        family: Config.Theme.fontFamily
                        pixelSize: Config.Theme.fontSmall
                    }
                }
            }
        }

        Repeater {
            model: AudioState.sources

            Item {
            height: 40
            Layout.fillWidth: true

            Rectangle {
                height: parent.height
                width: parent.width
                color: "transparent"
                border.width: 1
                border.color: Config.Theme.borderActive
                radius: Config.Theme.radiusSmall

                RowLayout {
                    anchors.fill: parent
                    RowLayout {
                        spacing: 10
                        anchors.left: parent.left
                        anchors.leftMargin: 10

                        Rectangle {
                            anchors.top: parent.top
                            anchors.left: parent.left
                            height: 30
                            width: 30
                            color: Config.Theme.primary
                            radius: Config.Theme.radiusMedium

                            Text {
                                anchors.centerIn: parent
                                text: "\uec1c"
                                color: serviceStatus === "On" ? Config.Theme.surface : Config.Theme.textMuted
                                font {
                                    family: Config.Theme.fontFamily
                                    pixelSize: Config.Theme.fontSmall
                                }
                            }
                        }

                        Text {
                            // text: AudioState.sources.length > 0 ? AudioState.sources[0].name : "No audio input"
                            text: modelData.name
                            color: Config.Theme.text
                            font {
                                family: Config.Theme.fontFamily
                                pixelSize: Config.Theme.fontSmall
                            }
                        }
                    }

                    Item {Layout.fillWidth: true}

                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 10

                        // visible: AudioState.sources.length > 0 && AudioState.sources[0].isDefault
                        visible: modelData.isDefault

                        text: "Selected"

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