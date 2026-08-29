import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../theme"

PanelWindow {    
    anchors.top: true
    anchors.left: true
    anchors.right: true

    implicitHeight: 40
    color: "transparent"

    Item {
        anchors.fill: parent         

        Workspaces {
            anchors.left: parent.left
            anchors.leftMargin: Theme.spacingMedium
            anchors.verticalCenter: parent.verticalCenter
        }

        Clock {
            anchors.centerIn: parent
        }

        Battery {
            anchors.right: parent.right
            anchors.rightMargin: Theme.spacingMedium
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}