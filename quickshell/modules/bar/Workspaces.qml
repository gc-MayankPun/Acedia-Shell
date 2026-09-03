import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import "../../config" as Config

Rectangle {
    implicitWidth: workspaceRow.implicitWidth + Config.Theme.barWidth 
    implicitHeight: workspaceRow.implicitHeight + Config.Theme.barHeight
    color: "transparent"

    RowLayout {
        id: workspaceRow  

        anchors.centerIn: parent
        spacing: 3

        Repeater {
            model: 9

            Rectangle { 
                required property int index

                property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === index + 1

                Layout.preferredWidth: 20
                Layout.preferredHeight: 20 
 
                radius: isActive 
                    ? Config.Theme.radiusLarge
                    : mouse.containsMouse 
                        ? Config.Theme.radiusSmall
                        : 0

                color: isActive 
                    ? Config.Theme.workspaceActive 
                    : mouse.containsMouse 
                        ? Config.Theme.workspaceHover
                        : "transparent"

                Behavior on color {
                    ColorAnimation {
                        duration: Config.Theme.animSlow 
                    }
                }

                Behavior on radius {
                    NumberAnimation {
                        duration: Config.Theme.animSlow 
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: index + 1

                    color: isActive
                        ? Config.Theme.workspaceTextActive
                        : mouse.containsMouse 
                            ? Config.Theme.workspaceTextActive
                            : (ws
                                ? Config.Theme.workspaceTextOccupied
                                : Config.Theme.workspaceTextEmpty)

                    font {
                        family: Config.Theme.fontFamily
                        pixelSize: isActive ? 10 : Config.Theme.fontSize
                        bold: !isActive ? true : false  
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: Config.Theme.animSlow
                            easing.type: Config.Theme.smoothEasing
                        }
                    } 
                }

                MouseArea { 
                    id: mouse
                    anchors.fill: parent

                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        Hyprland.dispatch("hl.dsp.focus({ workspace = " + (index + 1) + " })")
                    }
                }
            }
        }
    }
}