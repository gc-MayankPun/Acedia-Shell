import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick 

import "../theme"

PanelWindow {
    id: root
    property bool launcherOpen: false 

    implicitWidth: 500
    implicitHeight: 400

    color: "transparent" 
    visible: root.launcherOpen

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            root.launcherOpen = !root.launcherOpen 
            console.log("Launcher:", root.launcherOpen)
        }
    }

    Rectangle {
        anchors.fill: parent
        
        color: Theme.background
        radius: Theme.radiusLarge

        Text {
            anchors.centerIn: parent

            text: "App Launcher"

            color: Theme.text

            font {
                family: Theme.fontFamily
                pixelSize: Theme.titleSize
            }
        }
    }
}