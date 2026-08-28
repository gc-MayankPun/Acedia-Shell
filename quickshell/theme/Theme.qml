pragma Singleton

import QtQuick

QtObject {
    // Colors
    readonly property color background: "#0D1117"
    readonly property color surface: "#161B22"
    readonly property color active: "#1E293B"

    readonly property color blue: "#7AA2F7"
    readonly property color cyan: "#0DB9D7"
    readonly property color yellow: "#E0AF68"
    readonly property color red: "#F7768E"

    readonly property color text: "#CBD5E1"
    readonly property color textMuted: "#64748B"
    readonly property color textDisabled: "#334155"

    // Typography
    readonly property string fontFamily: "JetBrainsMono Nerd Font"

    readonly property int fontSize: 14
    readonly property int titleSize: 20

    // Shape
    readonly property int radiusSmall: 6
    readonly property int radiusMedium: 10
    readonly property int radiusLarge: 16

    // Spacing
    readonly property int spacingSmall: 4
    readonly property int spacingMedium: 8
    readonly property int spacingLarge: 12
}