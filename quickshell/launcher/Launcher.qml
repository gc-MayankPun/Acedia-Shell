import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick 
import QtQuick.Layouts

import "../theme"

PanelWindow {
    id: launcher
    property bool launcherOpen: false 

    property var applications: [
        {
            name: "Firefox",
            icon: "󰈹",
            command: "firefox"
        },
        {
            name: "Kitty",
            icon: "󰄛",
            command: "kitty"
        },
        {
            name: "VS Code",
            icon: "󰨞",
            command: "code"
        },
        {
            name: "Thunar",
            icon: "󰝰",
            command: "thunar"
        }
    ]

    implicitWidth: 500
    // implicitHeight: 400
    implicitHeight: searchBar.height + Theme.spacingLarge + appList.implicitHeight + 10

    color: "transparent" 
    visible: launcher.launcherOpen

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            launcher.launcherOpen = !launcher.launcherOpen 
            console.log("Launcher:", launcher.launcherOpen)
        }
    }

    Process {
        id: appProcess

        command: ["sh", "-c", commandToRun]

        property string commandToRun: ""
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

                margins: 10
            }

            contentWidth: width
            contentHeight: appList.implicitHeight

            clip: true

            ColumnLayout {
                id: appList

                width: parent.width 


                Repeater {
                    model: launcher.applications

                    AppDetails {
                        appName: modelData.name
                        appIcon: modelData.icon
                        appCommand: modelData.command

                        onLaunchRequested: command => {
                            appProcess.commandToRun = command
                            appProcess.running = true
                            launcher.launcherOpen = false
                        }
                    }
                }
            }
        }
    }
}