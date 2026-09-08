pragma Singleton

import Quickshell
import QtQuick

QtObject {
    property bool isNotificationPopupOpen: false

    function toggle() { isNotificationPopupOpen = !isNotificationPopupOpen }
    function show() { isNotificationPopupOpen = true }
    function hide() { isNotificationPopupOpen = false }
}