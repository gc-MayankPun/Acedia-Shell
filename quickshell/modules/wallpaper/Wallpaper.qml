import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick

import "../../config" as Config

PanelWindow {
    id: root

    property var screen
    property bool isWallpaperActive: WallpaperState.wallpaperVisible

    visible: isWallpaperActive

    IpcHandler {
        target: "wallpaper"

        function toggle() { WallpaperState.toggle() }
    }

    WlrLayershell.layer: WlrLayer.Overlay

    WlrLayershell.keyboardFocus:
    isWallpaperActive
    ? WlrKeyboardFocus.Exclusive
    : WlrKeyboardFocus.None

    WlrLayershell.namespace: "quickshell-wallpaper"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"

    Rectangle {
        anchors.centerIn: parent
        width: 500
        height: 400
        color: "transparent"
        clip: true

        Item {
            id: carousel
            anchors.fill: parent

            Repeater {
                model: WallpaperState.wallpapers

                Item {
                    id: card

                    property int distance: index - WallpaperState.selectedIndex
                    property int absDistance: Math.abs(distance)

                    // Base size of every wallpaper
                    width: 300
                    height: 200

                    // Keep every wallpaper centered around its position
                    x: carousel.width / 2
                       + distance * 160
                       - width / 2

                    y: (carousel.height - height) / 2

                    // Selected wallpaper becomes larger
                    scale: distance === 0
                           ? 1.33
                           : 0.55

                    opacity: absDistance > 5
                            ? 0
                            : Math.max(0.35, 1.0 - absDistance * 0.1)

                    z: 100 - absDistance

                    Behavior on x {
                        NumberAnimation {
                            duration: Config.Theme.animSlow
                            easing.type: Config.Theme.springEasing
                        }
                    }

                    Behavior on scale {
                        NumberAnimation {
                            duration: Config.Theme.animSlow
                            easing.type: Config.Theme.springEasing
                        }
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: Config.Theme.animSlow
                            easing.type: Config.Theme.springEasing
                        }
                    }

                    Rectangle {
                        anchors.fill: parent 
                        clip: true

                        Image {
                            anchors.fill: parent
                            source: modelData
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            cache: true 
                        }
                    }
                }
            }
        }

        focus: isWallpaperActive
        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Left) {
                WallpaperState.previous()
                event.accepted = true
            }
            else if (event.key === Qt.Key_Right) {
                WallpaperState.next()
                event.accepted = true
            }
            else if (event.key === Qt.Key_Return) {
                WallpaperState.applySelected()
                WallpaperState.hide()
                event.accepted = true
            }
        }
    }
}