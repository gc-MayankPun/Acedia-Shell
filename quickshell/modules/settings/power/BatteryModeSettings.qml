import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../../../config" as Config

RowLayout {
    id: root

    anchors.fill: parent

    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true

        color: "transparent"

        ColumnLayout {
            width: 600

            x: 10
            y: 10

            spacing: 20

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    Layout.fillWidth: true

                    text: "Power Mode"

                    color: Config.Theme.text

                    font {
                        family: Config.Theme.fontFamily
                        pixelSize: Config.Theme.fontSmall
                        bold: true
                    }
                }

                Text {
                    visible: BatteryState.loading

                    text: "Applying…"

                    color: Config.Theme.textMuted

                    font {
                        family: Config.Theme.fontFamily
                        pixelSize: Config.Theme.fontSmall - 2
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                spacing: 8

                Repeater {
                    model: BatteryState.profiles

                    Rectangle {
                        id: profileRow

                        readonly property string profileName: modelData
                        readonly property var meta:
                            BatteryState.profileMeta[profileName] || {
                                label: profileName,
                                icon: "\udb80\udc79",
                                description: ""
                            }
                        readonly property bool isActive:
                            BatteryState.activeProfile === profileName

                        Layout.fillWidth: true
                        Layout.preferredHeight: 56

                        radius: Config.Theme.radiusMedium
                        color: isActive
                            ? Config.Theme.primary
                            : rowMouse.containsMouse
                                ? Config.Theme.surfaceAlt
                                : "transparent"

                        border.width: isActive ? 0 : 1
                        border.color: Config.Theme.tertiary

                        Behavior on color {
                            ColorAnimation { duration: 120 }
                        }

                        Rectangle {
                            visible: profileRow.isActive
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: 4
                            radius: 2
                            color: Config.Theme.surface
                        }

                        Rectangle {
                            id: profileIcon

                            anchors.left: parent.left
                            anchors.leftMargin: 12
                            anchors.verticalCenter: parent.verticalCenter

                            width: 34
                            height: 34

                            color: profileRow.isActive
                                ? Config.Theme.surface
                                : Config.Theme.surfaceAlt
                            radius: Config.Theme.radiusMedium

                            Text {
                                anchors.centerIn: parent

                                text: profileRow.meta.icon

                                color: profileRow.isActive
                                    ? Config.Theme.primary
                                    : Config.Theme.text

                                font {
                                    family: Config.Theme.fontFamily
                                    pixelSize: Config.Theme.fontSize
                                }
                            }
                        }

                        ColumnLayout {
                            anchors.left: profileIcon.right
                            anchors.leftMargin: 10
                            anchors.right: radioIndicator.left
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter

                            spacing: 2

                            Text {
                                Layout.fillWidth: true

                                text: profileRow.meta.label

                                color: profileRow.isActive
                                    ? Config.Theme.surface
                                    : Config.Theme.text

                                font {
                                    family: Config.Theme.fontFamily
                                    pixelSize: Config.Theme.fontSmall - 1
                                    bold: profileRow.isActive
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: text.length > 0

                                text: profileRow.meta.description || ""

                                elide: Text.ElideRight

                                color: profileRow.isActive
                                    ? Config.Theme.surfaceAlt
                                    : Config.Theme.textMuted

                                font {
                                    family: Config.Theme.fontFamily
                                    pixelSize: Config.Theme.fontSmall - 3
                                }
                            }
                        }

                        Rectangle {
                            id: radioIndicator

                            anchors.right: parent.right
                            anchors.rightMargin: 14
                            anchors.verticalCenter: parent.verticalCenter

                            width: 18
                            height: 18
                            radius: 9

                            color: "transparent"
                            border.width: 2
                            border.color: profileRow.isActive
                                ? Config.Theme.surface
                                : Config.Theme.textMuted

                            Rectangle {
                                anchors.centerIn: parent
                                visible: profileRow.isActive

                                width: 10
                                height: 10
                                radius: 5

                                color: Config.Theme.surface
                            }
                        }

                        MouseArea {
                            id: rowMouse

                            anchors.fill: parent
                            hoverEnabled: true

                            acceptedButtons: Qt.LeftButton
                            propagateComposedEvents: false

                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                if (!profileRow.isActive)
                                    BatteryState.setProfile(profileRow.profileName)
                            }
                        }
                    }
                }

                Text {
                    visible: BatteryState.profiles.length === 0 && !BatteryState.loading && BatteryState.lastError.length === 0

                    Layout.fillWidth: true

                    text: "No power profiles found."

                    color: Config.Theme.textMuted

                    font {
                        family: Config.Theme.fontFamily
                        pixelSize: Config.Theme.fontSmall - 2
                    }
                }
            }
        }
    }
}