import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../../config" as Config
import "../../components" as Components

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Overlay

    WlrLayershell.keyboardFocus:
        NotificationState.isNotificationPopupOpen
            ? WlrKeyboardFocus.Exclusive
            : WlrKeyboardFocus.None

    WlrLayershell.namespace: "notification-popup"

    // Full screen so we can detect clicks outside
    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    color: "transparent"

    exclusionMode: ExclusionMode.Ignore

    // Only the launcher itself receives input
    mask: Region {
        item: NotificationState.isNotificationPopupOpen ? bar : null
    }

    // Outside click
    MouseArea {
        anchors.fill: parent
        enabled: NotificationState.isNotificationPopupOpen

        onClicked: {
            if (!bar.containsMouse)
                NotificationState.hide()
        }
    }

    Item {
        id: bar

        anchors.right: parent.right
        height: 400 
        width: 400

        y: NotificationState.isNotificationPopupOpen ? 0 : -height

        Behavior on y {
            NumberAnimation {
                duration: 300
                easing: Config.Theme.smoothEasing
            }
        }

        // Popup background
        Components.PopupShape {
            anchors.fill: parent

            attachedEdge: "top-right"
            color: Config.Theme.background

            radius: 18

            flareWidth: 18
            flareHeight: 18
        }
 
            
        ColumnLayout {  
            anchors {
                fill: parent
                topMargin: 10
                leftMargin: 35
                rightMargin: 10
                bottomMargin: 30
            }

            spacing: 12

            // // Header
            RowLayout {  
                Text {
                    text: "Notifications"
                    color: Config.Theme.text
                    font.pixelSize: 22
                    font.bold: true
                }

                Item {Layout.fillWidth: true}

                Rectangle {
                    width: 32
                    height: 32
                    radius: 8
 
                    color: closeMouse.containsMouse
                    ? Config.Theme.surfaceAlt
                    : "transparent"

                    Behavior on color {
                        ColorAnimation { duration: Config.Theme.animNormal }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "×"
                        color: Config.Theme.text
                        font.pixelSize: 24
                    }

                    MouseArea {
                        id: closeMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            NotificationState.hide()
                        }
                    }
                }
            }

            // Scrollable notifications
            ScrollView {
                id: notificationScroll
                anchors.leftMargin: 18

                Layout.fillWidth: true
                Layout.fillHeight: true

                clip: true

                ScrollBar.vertical.policy: ScrollBar.AsNeeded

                Column {
                    width: notificationScroll.availableWidth
                    clip: true 

                    spacing: 10

                    Repeater {
                        model: 5

                        Rectangle {
                            width: parent.width - 20
                            height: 90

                            radius: 12
                            color: Config.Theme.surfaceAlt

                            ColumnLayout {
                                anchors {
                                    fill: parent
                                    margins: 12
                                }

                                spacing: 0

                                // Header
                                RowLayout {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 24

                                    Text {
                                        text: "New notification"

                                        color: Config.Theme.text
                                        font.pixelSize: 15
                                        font.bold: true

                                        Layout.fillWidth: true
                                    }

                                    Rectangle {
                                        width: 24
                                        height: 24

                                        radius: 6

                                        color: removeMouse.containsMouse
                                            ? Config.Theme.background
                                            : "transparent"

                                            Behavior on color {
                                                ColorAnimation { duration: Config.Theme.animNormal }
                                            }


                                        Text {
                                            anchors.centerIn: parent

                                            text: "×"

                                            color: Config.Theme.textMuted
                                            font.pixelSize: 18
                                        }

                                        MouseArea {
                                            id: removeMouse

                                            anchors.fill: parent
                                            hoverEnabled: true 
                                            cursorShape: Qt.PointingHandCursor

                                            onClicked: {
                                                // Remove notification here
                                            }
                                        }
                                    }
                                }

                                // Body + summary
                                ColumnLayout {
                                    Layout.fillWidth: true

                                    spacing: 2

                                    Text {
                                        text: "This is an example notification."

                                        color: Config.Theme.textMuted
                                        font.pixelSize: 13

                                        elide: Text.ElideRight

                                        Layout.fillWidth: true
                                    }

                                    Text {
                                        text: "Just now"

                                        color: Config.Theme.tertiary
                                        font.pixelSize: 11

                                        Layout.topMargin: 8
                                    }
                                }
                            }
                        }
                    }
                }
            }
        
        }

        // Consume clicks inside the popup
        MouseArea {
            anchors.fill: parent

            z: -1

            onClicked: {
                mouse.accepted = true
            }
        }
    }
}