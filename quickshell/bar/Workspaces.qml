import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import "../theme"

Rectangle {
    id: root
    color: Theme.background
    radius: 10

    implicitWidth: workspaceRow.implicitWidth + 10
    implicitHeight: 30

    RowLayout {
        id: workspaceRow
        anchors.centerIn: parent
        spacing: 3

        Repeater {
            model: 9

            Rectangle {
                property var ws: Hyprland.workspaces.values.find(
                    w => w.id === index + 1
                )

                property bool isActive: Hyprland.focusedWorkspace?.id === index + 1

                Layout.preferredWidth: 25
                Layout.preferredHeight: 25
 
                radius: isActive 
                    ? Theme.radiusLarge
                    : mouse.containsMouse 
                        ? Theme.radiusSmall
                        : 0

                color: isActive 
                    ? Theme.workspaceActive 
                    : mouse.containsMouse 
                        ? Theme.workspaceOccupied
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
                            ? Theme.primary
                            : (ws
                                ? Theme.workspaceTextOccupied
                                : Theme.workspaceTextEmpty)

                    font {
                        family: Theme.fontFamily
                        pixelSize: Theme.fontSize
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