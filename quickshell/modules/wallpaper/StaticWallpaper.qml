import Quickshell
import QtQuick

import "../../config" as Config

Image {
    anchors.fill: parent

    source: modelData
    fillMode: Image.PreserveAspectCrop
    asynchronous: true
    cache: true
    rotation: rotationValue

    Behavior on rotation {
        NumberAnimation {
            duration: Config.Theme.animVerySlow
            easing.type: Config.Theme.smoothEasing
        }
    }
}