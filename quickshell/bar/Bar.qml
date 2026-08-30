import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../theme"

PanelWindow {
    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 40
    color: "transparent"

    RowLayout {
        anchors.fill: parent

        Workspaces {
            anchors {
                left: parent.left
                leftMargin: Theme.spacingMedium
            }
        }

        Clock { anchors.centerIn: parent }

        RightStatus {
            anchors {
                right: parent.right
                rightMargin: Theme.spacingMedium
            }
        }
    }
}