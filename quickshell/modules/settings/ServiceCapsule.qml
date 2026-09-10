import QtQuick
import QtQuick.Layouts

import "../../config" as Config

Rectangle {
    property string serviceName: ""
    property string serviceSignal: ""
    property string serviceStatus: "Off"
    property string connectedDevice: ""
    property int capsuleWidth: 200
    property int settingType: SettingsState.SettingType.Wifi

    // Emitted when the icon itself is clicked — parent decides
    // what "toggle" means for this specific service.
    signal iconClicked()

    id: root

    radius: Config.Theme.radiusMedium
    color: serviceStatus === "On" ? Config.Theme.primary : Config.Theme.primaryBright
    border.width: 1
    border.color: (iconMouse.containsMouse || arrowMouse.containsMouse)
        ? Config.Theme.tertiary
        : "transparent"

    Layout.preferredWidth: capsuleWidth
    Layout.preferredHeight: 60

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10

        // ICON ZONE — toggles the service, does not open settings
        Rectangle {
            id: iconRect

            Layout.preferredWidth: 40
            Layout.preferredHeight: 40

            color: Config.Theme.surface
            opacity: serviceStatus === "On" ? 1 : 0.5
            radius: Config.Theme.radiusPill

            Text {
                text: serviceSignal
                anchors.centerIn: parent
                color: Config.Theme.text
                font {
                    family: Config.Theme.fontFamily
                    pixelSize: Config.Theme.fontSize
                }
            }

            MouseArea {
                id: iconMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: root.iconClicked()
            }
        }

        // INFO + ARROW ZONE — opens the settings panel
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            ColumnLayout {
                spacing: 0
                Layout.fillWidth: true

                Text {
                    text: serviceName
                    color: serviceStatus === "On" ? Config.Theme.surface : Config.Theme.text
                    font {
                        family: Config.Theme.fontFamily
                        pixelSize: Config.Theme.fontSmall
                        bold: true
                    }
                }

                Text {
                    text: serviceStatus === "On" ? connectedDevice || serviceStatus : serviceStatus
                    color: serviceStatus === "On" ? Config.Theme.surfaceAlt : Config.Theme.textMuted
                    font {
                        family: Config.Theme.fontFamily
                        pixelSize: Config.Theme.fontSmall - 1
                    }

                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    wrapMode: Text.NoWrap
                }
            }

            RowLayout {
                spacing: 10

                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 30

                    color: serviceStatus === "On" ? Config.Theme.surface : Config.Theme.tertiary
                }

                Text {
                    text: "\ueab4"
                    color: serviceStatus === "On" ? Config.Theme.surface : Config.Theme.textMuted
                    font {
                        family: Config.Theme.fontFamily
                        pixelSize: Config.Theme.fontSmall - 1
                    }
                }
            }

            MouseArea {
                id: arrowMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    SettingsState.selectSetting(settingType)
                }
            }
        }
    }
}