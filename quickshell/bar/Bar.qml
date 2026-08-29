import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../theme"

PanelWindow {
    id: root 
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 40
    color: "transparent"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.spacingMedium
        anchors.rightMargin: Theme.spacingMedium

        Workspaces {}
        
        Item {
            Layout.fillWidth: true
        }

        Controls {}

        Item {
            Layout.fillWidth: true
        }

        Battery {}

        Separator {}

        Clock {}
    }
}