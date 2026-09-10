pragma Singleton

import Quickshell
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
    }

    function hide() {
        isSettingsOpen = false
    }

    function selectSetting(type) {
        settingType = type
        show()
    }
}