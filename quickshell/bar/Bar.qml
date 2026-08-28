import Quickshell
import Quickshell.Wayland
import QtQuick

import "../theme"

PanelWindow {
    id: root
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 40
    color: "transparent"

    Workspaces {}
}