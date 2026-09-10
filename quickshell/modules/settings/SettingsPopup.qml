import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../../config" as Config
import "../../components" as Components

PanelWindow {
    id: root
 
    property bool isBluetooth: SettingsState.settingType === SettingsState.SettingType.Bluetooth

    WlrLayershell.layer: WlrLayer.Overlay

    WlrLayershell.keyboardFocus:
        SettingsState.isSettingsOpen
            ? WlrKeyboardFocus.Exclusive
            : WlrKeyboardFocus.None

    WlrLayershell.namespace: "settings-popup"

    // Full screen so we can detect clicks outside
    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    color: "transparent"

    exclusionMode: ExclusionMode.Ignore

    // Only the launcher itself receives input
    mask: Region {
        item: SettingsState.isSettingsOpen ? bar : null
    }

    // Outside click
    MouseArea {
        anchors.fill: parent
        enabled: SettingsState.isSettingsOpen

        onClicked: {
            if (!bar.containsMouse)
                SettingsState.hide()
        }
    }

    Item {
        id: bar

        anchors.verticalCenter: parent.verticalCenter
 
        width: columnLayout.implicitWidth + 40 
        height: columnLayout.implicitHeight + 70

        x: SettingsState.isSettingsOpen   
            ? parent.width - width
            : parent.width

        Behavior on x {
            NumberAnimation {
                duration: 300
                easing.type: Config.Theme.smoothEasing
            }
        }

        Components.PopupShape {
            anchors.fill: parent

            attachedEdge: "right"
            color: Config.Theme.background

            radius: 18

            flareWidth: 18
            flareHeight: 18
        } 

        ColumnLayout {
            id: columnLayout 

            x: 20
            y: 30
 
            spacing: 10

            Text {
                text: "Control Center"
                color: Config.Theme.text
                font {
                    family: Config.Theme.fontFamily
                    pixelSize: Config.Theme.fontSize
                }
            }

            RowLayout {
                spacing: 10

                ServiceCapsule {
                    serviceSignal: "\uf1eb"
                    serviceName: "Wi-Fi"
                    serviceStatus: "On"
                    connectedDevice: "gc_mayankpun"

                    settingType: SettingsState.SettingType.Wifi
                }

                ServiceCapsule {
                    serviceSignal: "\uefcf"
                    serviceName: "Audio"
                    serviceStatus: "On"
                    connectedDevice: "Laptop Speaker"

                    settingType: SettingsState.SettingType.Audio
                }

                ServiceCapsule {
                    serviceSignal: "\uf294"
                    serviceName: "Bluetooth"
                    serviceStatus: "On"
                    connectedDevice: "Toad One"

                    settingType: SettingsState.SettingType.Bluetooth
                }
            }

            RowLayout {
                spacing: 10

                ServiceCapsule {
                    serviceSignal: "\udb81\udd94"
                    serviceName: "Night Light"
                    serviceStatus: "Off"

                    settingType: SettingsState.SettingType.NightLight

                    capsuleWidth: 305
                }

                ServiceCapsule {
                    serviceSignal: "\udb80\udc79"
                    serviceName: "Power Mode"
                    serviceStatus: "On"
                    connectedDevice: "On power mode"

                    settingType: SettingsState.SettingType.BatteryMode

                    capsuleWidth: 305
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 300
                radius: Config.Theme.radiusMedium
                color: Config.Theme.primaryBright

                Loader {
                    anchors.fill: parent

                    sourceComponent: {
                        switch (SettingsState.settingType) {
                            case SettingsState.SettingType.Wifi: return wifiBluetooth
                            case SettingsState.SettingType.Bluetooth: return wifiBluetooth
                            case SettingsState.SettingType.Audio: return audio
                            case SettingsState.SettingType.NightLight: return nightLight
                            case SettingsState.SettingType.BatteryMode: return batteryMode
                            default: return null
                        }
                    }
                }

                Component {
                    id: wifiBluetooth
                    WifiBluetooth {}
                }

                Component {
                    id: audio
                    AudioSettings {}
                }

                Component {
                    id: nightLight
                    NightLightSettings {}
                }

                Component {
                    id: batteryMode
                    BatteryModeSettings {}
                }
            }
        } 
    }
}