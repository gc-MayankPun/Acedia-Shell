import QtQuick

QtObject {
    readonly property int fast: 120
    readonly property int normal: 200
    readonly property int slow: 350

    readonly property int easing: Easing.OutCubic
}