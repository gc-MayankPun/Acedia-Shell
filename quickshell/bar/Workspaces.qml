import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import "../theme"

Rectangle {
    color: Theme.background
    radius: Theme.radiusPill

    implicitWidth: workspaceRow.implicitWidth + 15
    implicitHeight: 30

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
                    ? Theme.radiusLarge
                    : mouse.containsMouse 
                        ? Theme.radiusSmall
                        : 0

                color: isActive 
                    ? Theme.workspaceActive 
                    : mouse.containsMouse 
                        ? Theme.workspaceHover
                        : "transparent"

                Behavior on color {
                    ColorAnimation {
                        duration: Animations.normal
                        easing.type: Animations.easing
                    }
                }

                Behavior on radius {
                    NumberAnimation {
                        duration: Animations.normal
                        easing.type: Animations.easing
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: index + 1

                    color: isActive
                        ? Theme.workspaceTextActive
                        : mouse.containsMouse 
                            ? Theme.workspaceTextActive
                            : (ws
                                ? Theme.workspaceTextOccupied
                                : Theme.workspaceTextEmpty)

                    font {
                        family: Theme.fontFamily
                        pixelSize: 12
                        bold: true
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: Animations.fast
                            easing.type: Animations.easing
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