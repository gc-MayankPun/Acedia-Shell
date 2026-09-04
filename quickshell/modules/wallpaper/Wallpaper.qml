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
        width: 1000
        height: 400
        color: "transparent"
        clip: true

        Item {
            id: carousel
            anchors.fill: parent

            Repeater {
                model: WallpaperState.wallpapers

                Rectangle {
                    id: card

                    property int distance: index - WallpaperState.selectedIndex
                    property int absDistance: Math.abs(distance) 
                    property bool currentWallpaper: index === WallpaperState.selectedIndex
                    property int rotationValue: currentWallpaper ? 0 : (distance < 0 ? -60 : 60)

                    color: "transparent" 
                    implicitWidth: 300 
                    height: 300
                    clip: true

                    // Keep every wallpaper centered around its position 
                    x: carousel.width / 2 + distance * 210 - width / 2
                    y: (carousel.height - height) / 2
 
                    scale: distance === 0 ? 1.33 : 1
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
                        anchors.centerIn: parent
                        color: "transparent"
                        width: parent.width 
                        height: parent.height - 128
                        rotation: -rotationValue
                        clip: true
                        radius: 10

                        Behavior on rotation {
                            NumberAnimation {
                                duration: Config.Theme.animVerySlow
                                easing: Config.Theme.smoothEasing
                            }
                        }

                        Loader {
                            anchors.centerIn: parent
                            height: parent.height
                            width: currentWallpaper ? 300 : parent.width
                            sourceComponent: modelData.toLowerCase().endsWith(".gif") ? animatedImage : normalImage

                            Behavior on width {
                                NumberAnimation {
                                    duration: Config.Theme.animVerySlow
                                    easing.type: Config.Theme.smoothEasing
                                }
                            }

                            // Static Wallpapers
                            Component {
                                id: normalImage
                                StaticWallpaper {}
                            }

                            // Animated Wallpapers
                            Component {
                                id: animatedImage
                                AnimatedWallpaper {}
                            }
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