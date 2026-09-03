pragma Singleton

import QtQuick  

QtObject { 
    // Backgrounds
    readonly property color background: ColorLoader.background
    readonly property color surface: ColorLoader.surface
    readonly property color surfaceAlt: ColorLoader.surfaceVariant

    // Accents
    readonly property color primary: ColorLoader.primary
    readonly property color primaryBright: ColorLoader.primaryContent

    readonly property color secondary: ColorLoader.secondary
    readonly property color tertiary: ColorLoader.tertiary
    readonly property color error: ColorLoader.errorColor

    // Workspace
    readonly property color workspaceActive: ColorLoader.primary
    readonly property color workspaceOccupied: ColorLoader.secondary
    readonly property color workspaceHover: ColorLoader.tertiary
    readonly property color workspaceEmpty: ColorLoader.surfaceVariant

    readonly property color workspaceTextActive: ColorLoader.primaryContent
    readonly property color workspaceTextOccupied: ColorLoader.primary
    readonly property color workspaceTextEmpty: ColorLoader.border

    // Battery
    readonly property color batCharging: "#7ad9a8"
    readonly property color batDischarging: ColorLoader.tertiary
    readonly property color batLow: "#ff5048"

    // Text
    readonly property color text: ColorLoader.text
    readonly property color textMuted: ColorLoader.textMuted
    readonly property color textDisabled: ColorLoader.textMuted
    readonly property color textHover: ColorLoader.primary

    // Borders
    readonly property color border: ColorLoader.border
    readonly property color borderActive: ColorLoader.primary

    // Shapes
    readonly property int cornerRadius: 17
    readonly property int radiusSmall: 6
    readonly property int radiusMedium: 10
    readonly property int radiusLarge: 16
    readonly property int radiusPill: 999 

    // Spacing
    readonly property int spacingSmall: 4
    readonly property int spacingMedium: 8
    readonly property int spacingLarge: 12
    readonly property int spacingXLarge: 16

    // Bar
    readonly property int barHeight: 10
    readonly property int barWidth: 35
    readonly property int notchHeight: 35

    // Typography
    readonly property string fontFamily: "JetBrainsMono Nerd Font"

    readonly property int fontSize: 15
    readonly property int fontSmall: 12
    readonly property int fontLarge: 18

    // Animation
    readonly property int animFast: 120
    readonly property int animNormal: 200
    readonly property int animSlow: 350
    readonly property int animVerySlow: 500
    readonly property int smoothEasing: Easing.OutCubic
    readonly property int springEasing: Easing.OutBack

    // Notch
    property int notchPadding: 16 
    readonly property int notchRadius: 18
    property int notchHorizontalPadding: 20
    property int notchVerticalPadding: 10
    property int notchSideMargin: 10

    property int lNotchMinWidth: 180
    property int lNotchMaxWidth: 360

    property int cNotchMinWidth: 300
    property int cNotchMaxWidth: 360

    property int rNotchMinWidth: 180
    property int rNotchMaxWidth: 360
}