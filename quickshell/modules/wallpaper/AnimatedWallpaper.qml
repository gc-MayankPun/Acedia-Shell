import Quickshell
import QtQuick

import "../../config" as Config

AnimatedImage {
    anchors.fill: parent

    source: modelData
    fillMode: Image.PreserveAspectCrop
    asynchronous: true
    cache: true
    playing: currentWallpaper ? true : false
    rotation: rotationValue

    Behavior on rotation {
        NumberAnimation {
            duration: Config.Theme.animVerySlow
            easing.type: Config.Theme.smoothEasing
        }
    }
}