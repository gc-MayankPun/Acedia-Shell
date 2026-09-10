import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../../../config" as Config

RowLayout {
    id: root

    anchors.fill: parent
    spacing: 10

    property ListModel devicesModel: ListModel {}

    function rebuildDevices() {
        devicesModel.clear()

        const seen = {}

        for (const network of WifiState.savedNetworks) {
            if (!network.name || seen[network.name]) continue
            seen[network.name] = true
            devicesModel.append({ name: network.name, isConnected: network.isConnected })
        }

        for (const network of WifiState.availableNetworks) {
            if (!network.name || seen[network.name]) continue
            seen[network.name] = true
            devicesModel.append({ name: network.name, isConnected: network.isConnected })
        }
    }

    Connections {
        target: WifiState
        function onSavedNetworksChanged() { root.rebuildDevices() }
        function onAvailableNetworksChanged() { root.rebuildDevices() }
        function onNetworksChanged() { root.rebuildDevices() }
    }

    Component.onCompleted: rebuildDevices()

    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true

        color: "transparent"

        ColumnLayout {
            anchors.fill: parent

            anchors.leftMargin: 10
            anchors.topMargin: 10
            anchors.rightMargin: 10
            anchors.bottomMargin: 10

            spacing: 10

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    Layout.fillWidth: true

                    text: "Wi-Fi networks"

                    color: Config.Theme.text

                    font {
                        family: Config.Theme.fontFamily
                        pixelSize: Config.Theme.fontSmall
                    }
                }

                Text {
                    visible: WifiState.loading

                    text: "Refreshing…"

                    color: Config.Theme.textMuted

                    font {
                        family: Config.Theme.fontFamily
                        pixelSize: Config.Theme.fontSmall - 2
                    }
                }

                Rectangle {
                    width: 30
                    height: 30

                    color: "transparent"

                    Text {
                        anchors.centerIn: parent

                        text: "\udb81\udc53"

                        color: Config.Theme.text

                        font {
                            family: Config.Theme.fontFamily
                            pixelSize: Config.Theme.fontSize
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        propagateComposedEvents: false
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { WifiState.update() }
                    }
                }
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                clip: true

                ScrollBar.vertical.policy: ScrollBar.AsNeeded

                ColumnLayout {
                    width: parent.width - 12
                    spacing: 10

                    Repeater {
                        model: root.devicesModel

                        Rectangle {
                            id: deviceRow

                            readonly property bool isPending:
                                WifiState.pendingNetwork === name

                            Layout.fillWidth: true
                            height: 40

                            color: "transparent"

                            Rectangle {
                                id: deviceIcon

                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter

                                width: 30
                                height: 30

                                color: Config.Theme.surfaceAlt
                                radius: Config.Theme.radiusMedium

                                Text {
                                    anchors.centerIn: parent
                                    text: "\uf1eb"
                                    color: Config.Theme.text
                                    font {
                                        family: Config.Theme.fontFamily
                                        pixelSize: Config.Theme.fontSize
                                    }
                                }
                            }

                            ColumnLayout {
                                anchors.left: deviceIcon.right
                                anchors.leftMargin: 10
                                anchors.right: deviceAction.left
                                anchors.rightMargin: 10
                                anchors.verticalCenter: parent.verticalCenter

                                spacing: 0

                                Text {
                                    Layout.fillWidth: true
                                    text: name
                                    color: Config.Theme.text
                                    elide: Text.ElideRight
                                    font {
                                        family: Config.Theme.fontFamily
                                        pixelSize: Config.Theme.fontSmall - 1
                                    }
                                }
                            }

                            Text {
                                anchors.right: deviceAction.left
                                anchors.rightMargin: 10
                                anchors.verticalCenter: parent.verticalCenter

                                text: deviceRow.isPending
                                    ? (WifiState.pendingAction === "connecting" ? "Connecting…" : "Disconnecting…")
                                    : (isConnected ? "Connected" : "Available")

                                color: deviceRow.isPending
                                    ? Config.Theme.textMuted
                                    : (isConnected ? Config.Theme.batCharging : Config.Theme.textMuted)

                                font {
                                    family: Config.Theme.fontFamily
                                    pixelSize: Config.Theme.fontSmall - 2
                                }
                            }

                            Rectangle {
                                id: deviceAction

                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter

                                width: 75
                                height: 30

                                color: "transparent"

                                Text {
                                    anchors.centerIn: parent

                                    text: deviceRow.isPending
                                        ? "…"
                                        : (isConnected ? "Disconnect" : "Connect")

                                    color: Config.Theme.batCharging

                                    font {
                                        family: Config.Theme.fontFamily
                                        pixelSize: Config.Theme.fontSmall - 2
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    enabled: !deviceRow.isPending
                                    acceptedButtons: Qt.LeftButton
                                    propagateComposedEvents: false
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked: {
                                        if (isConnected) {
                                            WifiState.disconnect()
                                        } else {
                                            WifiState.connect(name)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}