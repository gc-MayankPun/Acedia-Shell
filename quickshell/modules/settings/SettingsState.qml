pragma Singleton

import Quickshell
import Quickshell.Hyprland
import QtQuick

QtObject {
    enum SettingType {
        Wifi,
        Bluetooth,
        Audio,
        NightLight,
        BatteryMode
    }

    property int settingType: SettingType.Wifi

    property bool isSettingsOpen: false

    function toggle() {
        isSettingsOpen = !isSettingsOpen
    }

    function show() {
        isSettingsOpen = true
        Hyprland.dispatch("settings-blur off")
    }

    function hide() {
        isSettingsOpen = false
        Hyprland.dispatch("settings-blur on")
    }

    function selectSetting(type) {
        settingType = type
        show()
    }
}