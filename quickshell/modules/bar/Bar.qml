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
            left: parent.left
            top: parent.top  
        }
        z: 1
    }

    // CLOCK
    Clock {
        id: clock

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top  
        }
        z:1
    }

    // BATTERY
    Battery {
        id: battery

        anchors {
            right: parent.right
            top: parent.top 
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
        radius: 18

        color: Config.Theme.background
    }
}