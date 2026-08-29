import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick 
import QtQuick.Layouts

import "../theme"

PanelWindow {
    id: launcher
    focusable: true

    property int emptyLauncherHeight: 60
    property int maxLauncherHeight: 500
    property bool launcherOpen: false 
    property var applications: []
    property var filteredApplications: {
        const query = searchBar.searchText.trim().toLowerCase()

        if (query === "")
            return []

        return applications.filter(function(app) {
            return app.name.toLowerCase().includes(query)
        })
    }

    Component.onCompleted: {
        appLoader.running = true
    }

    Process {
        id: appLoader

        command: ["bash", "/home/riceuser/.config/quickshell/launcher/applications.sh"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    launcher.applications = JSON.parse(text)
                    console.log("Loaded applications:", launcher.applications.length)
                } catch (error) {
                    console.log("JSON error:", error)
                    console.log("Output:", text)
                }
            }
        }
    }
    
    implicitWidth: 500 
    implicitHeight: searchBar.searchText === ""
        ? emptyLauncherHeight
        : Math.min(
            searchBar.height +
            Theme.spacingLarge +
            appList.implicitHeight +
            20,
            maxLauncherHeight
        )

    color: "transparent" 
    visible: launcher.launcherOpen

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            launcher.launcherOpen = !launcher.launcherOpen 
            if(launcher.launcherOpen) searchBar.searchText = "" 
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
                    model: launcher.filteredApplications

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