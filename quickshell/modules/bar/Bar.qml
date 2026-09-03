import Quickshell
import Quickshell.Wayland
import QtQuick

import "../../config" as Config
import "../../components" as Components

PanelWindow {
    id: root 

    implicitHeight: Config.Theme.notchHeight
    color: "transparent" 

    anchors {
        top: true
        left: true
        right: true
    }

    // WORKSPACES
    Workspaces {
        id: workspaces

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left 
        }
        z: 1
    }

    // CLOCK
    Clock {
        id: clock

        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter 
        }
        z:1
    }

    // BATTERY
    Battery {
        id: battery

        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
        }
        z:1
    }

    // BAR SHAPE
    Components.SeamlessBarShape {
        id: barShape

        anchors.fill: parent

        z: 0

        leftWidth: workspaces.width
        centerWidth: clock.width
        rightWidth: battery.width

        notchHeight: Config.Theme.notchHeight
        radius: 20

        color: Config.Theme.background
    }
}