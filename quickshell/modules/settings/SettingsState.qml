pragma Singleton

import Quickshell
import QtQuick

QtObject {
    property bool isSettingsOpen: false

    function toggle() { isSettingsOpen = !isSettingsOpen }
    function show() { isSettingsOpen = true }
    function hide() { isSettingsOpen = false }
}