import Quickshell
import QtQuick
import QtQuick.Layouts

import "../../config" as Config 
import "../notifications"
import "../settings"

Rectangle {
    width: rightBar.width + Config.Theme.barWidth
    height: rightBar.height + Config.Theme.barHeight
    color: "transparent"

    RowLayout {
        id: rightBar
        anchors.centerIn: parent
        spacing: 10

        SettingsToggle {}

        NotificationToggle {}

        Battery {}
    }
}