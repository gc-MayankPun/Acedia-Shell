pragma Singleton

import Quickshell
import QtQuick

QtObject {
    property bool isNetworkPopupOpen: false

    function toggle() { isNetworkPopupOpen = !isNetworkPopupOpen }
    function show() { isNetworkPopupOpen = true }
    function hide() { isNetworkPopupOpen = false }
}