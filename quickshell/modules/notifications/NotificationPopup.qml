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

            // Header
            RowLayout {  
                Text {
                    text: "Notifications"
                    color: Config.Theme.text
                    font {
                        pixelSize: Config.Theme.fontLarge
                        family: Config.Theme.fontFamily
                        bold: true
                    }
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

                contentWidth: availableWidth
                contentHeight: notificationColumn.height

                wheelEnabled: true

                ScrollBar.vertical.policy: ScrollBar.AsNeeded

                Column {
                    id: notificationColumn
 
                    width: notificationScroll.availableWidth
                    height: childrenRect.height

                    visible: NotificationState.hasNotifications 
                    spacing: 10

                    Repeater {
                        model: NotificationState.history

                        delegate: Rectangle {
                            id: card
                            required property int index
                            required property string summary
                            required property string body
                            required property string appName
                            required property string time
                            required property int urgency 

                            property bool canExpand: bodyMeasure.truncated
                            property bool isClicked: canExpand && index === NotificationState.clickedNotif

                            width: parent.width - 20
                            height: contentCol.implicitHeight + 20

                            radius: 12
                            color: Config.Theme.surfaceAlt

                            Behavior on height {
                                NumberAnimation {
                                    duration: Config.Theme.animNormal
                                    easing: Config.Theme.normalEasing
                                }
                            }

                            // Hidden measuring Text, never shown, always single-line,
                            // used only to detect if `body` would overflow the card width.
                            Text {
                                id: bodyMeasure
                                visible: false
                                text: card.body
                                wrapMode: Text.NoWrap
                                elide: Text.ElideRight
                                width: contentCol.width
                                font: notifBody.font
                            }

                            ColumnLayout {
                                id: contentCol
                                z: 1
                                anchors {
                                    fill: parent
                                    leftMargin: 12
                                    rightMargin: 12 
                                    topMargin: 10
                                    bottomMargin: 10
                                }

                                // Appname + Body
                                ColumnLayout {
                                    
                                    Layout.fillWidth: true
                                    spacing: 0

                                    RowLayout {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 24

                                        Text {
                                            text: appName

                                            color: Config.Theme.text
                                            font {
                                                pixelSize: Config.Theme.fontSize
                                                bold: true
                                                family: Config.Theme.fontFamily
                                            }

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

                                                onClicked: NotificationState.history.remove(index)
                                                onWheel: (wheel) => wheel.accepted = false
                                            }
                                        }
                                    }

                                    Text {
                                        text: summary
                                        color: Config.Theme.textMuted
                                        font {
                                            family: Config.Theme.fontFamily
                                            pixelSize: Config.Theme.fontSmall
                                        }
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                    }

                                    Text { 
                                        id: elidedNotifBody
                                        text: body
                                        visible: body !== "" && !isClicked
                                        color: Config.Theme.textMuted
                                        opacity: 0.85
                                        font {
                                            family: Config.Theme.fontFamily
                                            pixelSize: Config.Theme.fontSmall - 1
                                        } 
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                        Layout.topMargin: 2 
                                    }

                                    Text { 
                                        id: notifBody
                                        text: body
                                        visible: body !== "" && isClicked
                                        color: Config.Theme.textMuted
                                        opacity: 0.85
                                        font {
                                            family: Config.Theme.fontFamily
                                            pixelSize: Config.Theme.fontSmall - 1
                                        }
                                        wrapMode: Text.WordWrap 
                                        Layout.fillWidth: true
                                        Layout.topMargin: 2 
                                    }
                                }

                                // Time 
                                Text {
                                    text: time
                                    color: Config.Theme.tertiary
                                    font {
                                        family: Config.Theme.fontFamily
                                        pixelSize: Config.Theme.fontSmall -1
                                    } 
                                } 
                            }

                            MouseArea { 
                                anchors.fill: parent
                                hoverEnabled: true 
                                cursorShape: canExpand ? Qt.PointingHandCursor : Qt.ArrowCursor
                                enabled: canExpand
                                onClicked: NotificationState.clickedNotif = (NotificationState.clickedNotif === index ? -1 : index)
                                onWheel: (wheel) => wheel.accepted = false
                            }
                        }
                    }
                }
            }

            Column {
                visible: !NotificationState.hasNotifications
                anchors.centerIn: parent
                spacing: 5

                Image {
                    width: 200
                    height: 100

                    anchors.horizontalCenter: parent.horizontalCenter
                    source: Qt.resolvedUrl("../../assets/images/no-notification.png")
 
                    fillMode: Image.PreserveAspectCrop 
                    smooth: true
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "No Notifications"
                    color: Config.Theme.text

                    font {
                        family: Config.Theme.fontFamily
                        pixelSize: Config.Theme.fontSize
                        bold: true
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "You're all caught up"
                    color: Config.Theme.textMuted 

                    font {
                        family: Config.Theme.fontFamily
                        pixelSize: Config.Theme.fontSmall - 1
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
                NotificationState.clickedNotif = -1
            }
        }
    }
}