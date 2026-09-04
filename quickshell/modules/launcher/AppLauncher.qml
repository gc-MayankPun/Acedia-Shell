import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick

import "../../config" as Config 
import "../../components" as Components

PanelWindow {
    id: root
    property var screen

    IpcHandler {
        target: "applauncher"
        function toggle() {
            AppLauncherState.toggle();
        }
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: AppLauncherState.launcherVisible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    WlrLayershell.namespace: "quickshell-launcher"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    mask: Region {
        item: AppLauncherState.launcherVisible ? maskCover : null
    }
    Item {
        id: maskCover
        anchors.fill: parent
    }

    color: "transparent"

    // State 
    property string searchQuery: ""
    property int selectedIndex: 0
    readonly property bool isSearching: searchQuery.trim() !== ""

    property var filteredApps: {
        var q = searchQuery.trim().toLowerCase();
        var vals = DesktopEntries.applications.values;

        if (q !== "") {
            // Search mode: filter by name / genericName / keywords, alpha sort
            return vals.filter(function (e) {
                if (e.name.toLowerCase().indexOf(q) !== -1)
                    return true;
                if (e.genericName && e.genericName.toLowerCase().indexOf(q) !== -1)
                    return true;
                for (var i = 0; i < e.keywords.length; i++)
                    if (e.keywords[i].toLowerCase().indexOf(q) !== -1)
                        return true;
                return false;
            }).sort(function (a, b) {
                return a.name.localeCompare(b.name);
            });
        }

        // Default mode: recent apps first, then alphabetical
        var recent = AppLauncherState.recentIds;
        return vals.slice().sort(function (a, b) {
            var ai = recent.indexOf(a.id);
            var bi = recent.indexOf(b.id);
            if (ai !== -1 && bi !== -1)
                return ai - bi;
            if (ai !== -1)
                return -1;
            if (bi !== -1)
                return 1;
            return a.name.localeCompare(b.name);
        });
    }

    onFilteredAppsChanged: selectedIndex = 0

    // Launch 
    function launchEntry(entry) {
        AppLauncherState.recordLaunch(entry.id);
        entry.execute();
        AppLauncherState.hide();
    }

    // Navigation 
    function navigate(delta) {
        if (filteredApps.length === 0)
            return;
        selectedIndex = (selectedIndex + delta + filteredApps.length) % filteredApps.length;
        listView.positionViewAtIndex(selectedIndex, ListView.Contain);
    }

    Connections {
        target: AppLauncherState
        function onLauncherVisibleChanged() {
            if (AppLauncherState.launcherVisible) {
                searchInput.text = "";
                root.searchQuery = "";
                root.selectedIndex = 0;
                searchInput.forceActiveFocus();
            }
        }
    }

    // Accent colours
    readonly property color accentFill: Qt.rgba(Config.Theme.secondary.r, Config.Theme.secondary.g, Config.Theme.secondary.b, 0.18)
    readonly property color accentIcon: Qt.rgba(Config.Theme.secondary.r, Config.Theme.secondary.g, Config.Theme.secondary.b, 0.28)
    readonly property color fgDim: Qt.rgba(Config.Theme.text.r, Config.Theme.text.g, Config.Theme.text.b, 0.65)

    // Panel geometry
    readonly property int maxVisible: 7
    readonly property int itemH: 42
    readonly property int panelW: 440 
    readonly property int panelH: 88 + Math.min(filteredApps.length, maxVisible) * itemH + (root.filteredApps.length === 0 ? 20 : 0)

    // Click outside → close
    MouseArea {
        anchors.fill: parent
        enabled: AppLauncherState.launcherVisible
        onClicked: AppLauncherState.hide()
    }

    // Panel
    Item {
        id: panel

        width: root.panelW
        height: root.panelH

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom 
        }

        // Background shape
        Components.PopupShape {
            id: background

            anchors.fill: parent
            attachedEdge: "bottom"
            color: Config.Theme.background
            radius: 18
            flareWidth: 18
            flareHeight: 18
        }

        // Content
        Column {
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right

                topMargin: 12
                leftMargin: 30
                rightMargin: 30
            }

            spacing: 0

            // your existing handle
            Rectangle {
                width: 36
                height: 4
                radius: 2
                anchors.horizontalCenter: parent.horizontalCenter
                color: Qt.rgba(1, 1, 1, 0.22)
            }

            Item {
                width: 1
                height: 8
            }

            // Search box
            Rectangle {
                width: parent.width
                height: 44
                radius: 10
                color: Qt.rgba(1, 1, 1, 0.07)

                Rectangle {
                    anchors.fill: parent
                    radius: 10
                    color: "transparent"
                    border.color: Config.Theme.secondary
                    border.width: 1
                    opacity: searchInput.activeFocus ? 0.55 : 0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: Config.Theme.animFast
                        }
                    }
                }

                Row {
                    anchors {
                        fill: parent
                        leftMargin: 14
                        rightMargin: 14
                    }
                    spacing: 10 

                    Item {
                        width: parent.width - 40
                        height: parent.height

                        Text {
                            anchors.fill: parent
                            text: root.isSearching ? "" : "Search apps…"
                            color: Config.Theme.text
                            opacity: 0.28
                            font {
                                pixelSize: Config.Theme.fontSmall
                                family: Config.Theme.fontFamily
                            }
                            verticalAlignment: Text.AlignVCenter
                            visible: searchInput.text === ""
                        }

                        TextInput {
                            id: searchInput
                            anchors.fill: parent
                            color: Config.Theme.text
                            selectionColor: root.accentFill
                            font {
                                pixelSize: Config.Theme.fontSmall
                                family: Config.Theme.fontFamily
                            }
                            verticalAlignment: TextInput.AlignVCenter
                            clip: true

                            onTextChanged: root.searchQuery = text

                            Keys.onPressed: function (event) {
                                if (event.key === Qt.Key_Up) {
                                    root.navigate(-1);
                                    event.accepted = true;
                                } else if (event.key === Qt.Key_Down) {
                                    root.navigate(1);
                                    event.accepted = true;
                                } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                    if (root.filteredApps.length > 0)
                                        root.launchEntry(root.filteredApps[root.selectedIndex]);
                                    event.accepted = true;
                                } else if (event.key === Qt.Key_Escape) {
                                    AppLauncherState.hide();
                                    event.accepted = true;
                                }
                            }
                        }
                    }
                }
            }

            Item {
                width: 1
                height: 8
            }

            // App list 
            ListView {
                id: listView
                width: parent.width
                height: Math.min(root.filteredApps.length, root.maxVisible) * root.itemH
                model: root.filteredApps
                clip: true
                interactive: false

                // Wheel on list (belt-and-suspenders alongside panel MouseArea)
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onWheel: function (wheel) {
                        if (wheel.angleDelta.y < 0)
                            root.navigate(1);
                        else
                            root.navigate(-1);
                    }
                }

                delegate: Item {
                    id: appRow
                    width: listView.width
                    height: root.itemH

                    readonly property bool sel: root.selectedIndex === index
                    // readonly property bool isRecent: !root.isSearching && AppLauncherState.recentIds.indexOf(modelData.id) !== -1 && AppLauncherState.recentIds.indexOf(modelData.id) < 5

                    Rectangle {
                        anchors {
                            fill: parent
                            topMargin: 2
                            bottomMargin: 2
                        }
                        radius: 10
                        color: appRow.sel ? root.accentFill : "transparent"
                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                            }
                        }

                        Row {
                            anchors {
                                fill: parent
                                rightMargin: 8
                            }
                            spacing: 12

                            // Icon bubble
                            Rectangle {
                                width: 36
                                height: 36
                                radius: 9
                                anchors.verticalCenter: parent.verticalCenter
                                color: appRow.sel ? root.accentIcon : Qt.rgba(1, 1, 1, 0.08)
                                
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 100
                                    }
                                }

                                Image {
                                    id: appIcon
                                    anchors.centerIn: parent
                                    width: 22
                                    height: 22
                                    source: modelData.icon !== "" ? "image://icon/" + modelData.icon : ""
                                    smooth: true
                                    mipmap: true
                                }

                                Text {
                                    anchors.centerIn: parent
                                    visible: appIcon.status !== Image.Ready
                                    text: modelData.name.charAt(0).toUpperCase()
                                    font {
                                        pixelSize: 15
                                        family: Config.Theme.fontFamily
                                        weight: Font.Bold
                                    }
                                    color: appRow.sel ? Config.Theme.secondary : Config.Theme.text
                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 100
                                        }
                                    }
                                }
                            }

                            // Name + subtitle
                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 2

                                Text {
                                    text: modelData.name
                                    font {
                                        pixelSize: Config.Theme.fontSmall
                                        family: Config.Theme.fontFamily
                                        weight: appRow.sel ? Font.Medium : Font.Normal
                                    }
                                    color: appRow.sel ? Config.Theme.text : root.fgDim
                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 100
                                        }
                                    }
                                }

                                Text {
                                        visible: modelData.genericName !== ""
                                        text: modelData.genericName
                                        font {
                                            pixelSize: 11
                                            family: Config.Theme.fontFamily
                                        }
                                        color: Config.Theme.text
                                        opacity: 0.35 
                                } 
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: root.selectedIndex = index
                            onClicked: root.launchEntry(modelData)
                            onWheel: function (wheel) {
                                if (wheel.angleDelta.y < 0)
                                    root.navigate(1);
                                else
                                    root.navigate(-1);
                            }
                        }
                    }
                }
            }

            // No Apps Found message
            Rectangle { 
                visible: root.filteredApps.length === 0
                height: 20
                width: parent.width
                color: "transparent"

                Text {  
                    anchors.centerIn: parent
                    text: "No apps found"
                    color: Config.Theme.text
                    opacity: 0.28
                    font {
                        pixelSize: Config.Theme.fontSmall
                        family: Config.Theme.fontFamily
                    }
                }
            } 

            Item {
                width: 1
                height: 4
            }
        }

        // Smooth height shrink/grow when filteredApps count changes
        Behavior on height {
            NumberAnimation {
                duration: Config.Theme.animVerySlow
                easing.type: Config.Theme.smoothEasing
            }
        }

        // Slide up / down
        transform: Translate {
            y: AppLauncherState.launcherVisible ? 0 : root.panelH + 6
            Behavior on y {
                NumberAnimation {
                    duration: Config.Theme.animVerySlow
                    easing.type: Config.Theme.smoothEasing
                }
            }
        } 
    }
}
