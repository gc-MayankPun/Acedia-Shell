pragma Singleton

import QtQuick

QtObject {
    // Backgrounds
    readonly property color background: "#0B0E14"
    readonly property color surface: "#11151D"
    readonly property color surfaceAlt: "#171C26"

    // Accent
    readonly property color primary: "#A78BFA"
    readonly property color primaryBright: "#C4B5FD"

    readonly property color blue: "#7DD3FC"
    readonly property color cyan: "#67E8F9"

    readonly property color green: "#86EFAC"
    readonly property color yellow: "#FDE68A"
    readonly property color red: "#FB7185"
    readonly property color pink: "#F0ABFC"
 
    // Workspace
    readonly property color workspaceActive: "#A78BFA"
    readonly property color workspaceOccupied: "#64748B"
    readonly property color workspaceHover: "#7DD3FC"
    readonly property color workspaceEmpty: "#334155"
    
    readonly property color workspaceTextActive: "#0B0E14"
    readonly property color workspaceTextOccupied: "#CBD5E1"
    readonly property color workspaceTextEmpty: "#64748B"

    // Battery
    readonly property color batCharging: "#86EFAC"
    readonly property color batDischarging: "#FDE68A"
    readonly property color batLow: "#FB7185"

    // Clock
    readonly property color clock: "#7aa2f7"

    // Text
    readonly property color text: "#E2E8F0"
    readonly property color textMuted: "#94A3B8"
    readonly property color textDisabled: "#475569"
    readonly property color textHover: '#97cbff'

    // Borders / separators
    readonly property color border: "#252B36"
    readonly property color borderActive: "#7C5CFC"

    // Typography
    readonly property string fontFamily: "JetBrainsMono Nerd Font"

    readonly property int fontSize: 14
    readonly property int fontSmall: 12
    readonly property int fontLarge: 18

    // Shapes
    readonly property int radiusSmall: 6
    readonly property int radiusMedium: 10
    readonly property int radiusLarge: 16
    readonly property int radiusPill: 999

    // Spacing
    readonly property int spacingSmall: 4
    readonly property int spacingMedium: 8
    readonly property int spacingLarge: 12
    readonly property int spacingXLarge: 16
}