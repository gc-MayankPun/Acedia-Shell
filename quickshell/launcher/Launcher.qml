import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick 
import QtQuick.Layouts

import "../theme"

PanelWindow {
    id: launcher
    property bool launcherOpen: false 

    implicitWidth: 500
    implicitHeight: 400

    color: "transparent" 
    visible: launcher.launcherOpen

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            launcher.launcherOpen = !launcher.launcherOpen 
            console.log("Launcher:", launcher.launcherOpen)
        }
    }

    Rectangle {
        anchors.fill: parent
        border {
            width: 0.5
            color: Theme.workspaceEmpty
        }
        
        color: Theme.background
        radius: Theme.radiusLarge

        SearchBar {
            id: searchBar
        }

        Flickable {
            anchors {
                top: searchBar.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom

                margins: Theme.spacingLarge
            }

            contentWidth: width
            contentHeight: appList.implicitHeight

            clip: true

            ColumnLayout {
                id: appList

                width: parent.width
                spacing: Theme.spacingMedium 

                Repeater {
                    model: 9

                    AppDetails {}
                }
            }
        }
    }
}