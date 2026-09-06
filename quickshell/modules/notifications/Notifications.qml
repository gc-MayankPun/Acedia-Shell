import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "../../services" as Services
import "../../config" as Config

Scope {
    Services.NotificationService {
        id: notificationService
    }

    PanelWindow {
        anchors {
            top: true
            right: true
        }

        margins {
            top: 45
            right: 10
        }

        implicitWidth: 300
        implicitHeight: column.implicitHeight

        color: "transparent"

        exclusionMode: ExclusionMode.Ignore

        ColumnLayout {
            id: column

            width: parent.width
            spacing: 10

            Repeater {
                model: notificationService.history

                delegate: Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: content.implicitHeight + 20 

                    color: Config.Theme.background
                    radius: Config.Theme.cornerRadius

                    Timer {
                        running: model.urgency !== NotificationUrgency.Critical
                        interval: 5000

                        onTriggered: { notificationService.dismiss(model.notification) }
                    }

                    ColumnLayout {
                        id: content

                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        // Header
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10
        
                            // App icon
                            Rectangle {
                                color: appImage.visible ? "transparent" : "#41434C"
                                height: 36
                                width: 36
                                radius: Config.Theme.radiusPill

                                Image {
                                    id: appImage
                                    anchors.centerIn: parent

                                    width: 30
                                    height: 30

                                    fillMode: Image.PreserveAspectFit

                                    source: model.notification.image
                                        || model.notification.appIcon
                                        || ""

                                    visible: source.toString() !== ""
                                }

                                Text {
                                    anchors.centerIn: parent

                                    text: ""
                                    color: Config.Theme.text
                                    font {
                                        pixelSize: 20
                                        family: Config.Theme.fontFamily
                                    }

                                    visible: !appImage.visible
                                }
                            }

                            // App name + time
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0

                                Text {
                                    Layout.fillWidth: true
                                    text: model.appName
                                    color: Config.Theme.text
                                    elide: Text.ElideRight

                                    font {
                                        family: Config.Theme.fontFamily
                                        pixelSize: Config.Theme.fontSmall
                                    }
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: model.time
                                    color: Config.Theme.textMuted

                                    font {
                                        family: Config.Theme.fontFamily
                                        pixelSize: Config.Theme.fontSmall
                                    }
                                }
                            }

                            // Close button
                            Text {
                                text: "×"
                                color: Config.Theme.textMuted
                                anchors.verticalCenter: parent.verticalCenter

                                font {
                                    family: Config.Theme.fontFamily
                                    pixelSize: 16
                                }

                                Layout.alignment: Qt.AlignTop

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: { notificationService.dismiss(model.notification) }
                                }
                            }
                        }

                        // Summary
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            Rectangle {
                                Layout.preferredWidth: 3
                                Layout.preferredHeight: 30
                                radius: 2
                                color: Config.Theme.primary
                            }

                            Text {
                                Layout.fillWidth: true
                                text: model.summary
                                color: Config.Theme.text
                                wrapMode: Text.WordWrap

                                font {
                                    family: Config.Theme.fontFamily
                                    pixelSize: Config.Theme.fontSize
                                }
                            }
                        }

                        // Body
                        Text {
                            Layout.fillWidth: true
                            text: model.body
                            color: Config.Theme.textMuted
                            wrapMode: Text.WordWrap

                            font {
                                family: Config.Theme.fontFamily
                                pixelSize: Config.Theme.fontSmall
                            }
                        }
                    }
                }
            }
        }
    }
}