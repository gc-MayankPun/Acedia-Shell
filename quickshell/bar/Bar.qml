import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../theme"
import "./center_status_bar"
import "./right_status_bar"

PanelWindow {
    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 40
    color: "transparent"

    Item {
        anchors.fill: parent

        Workspaces {
            anchors {
                left: parent.left
                leftMargin: Theme.spacingMedium
                verticalCenter: parent.verticalCenter
            }
        }

        CenterStatus { anchors.fill: parent }

        RightStatus {
            anchors {
                right: parent.right
                rightMargin: Theme.spacingMedium
                verticalCenter: parent.verticalCenter
            }
        }
    }
}