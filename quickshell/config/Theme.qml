pragma Singleton

import QtQuick 

QtObject { 
    // Backgrounds
    readonly property color background: "#0B0E14"
    readonly property color surface: "#11151D"
    readonly property color surfaceAlt: "#171C26"

    // Accents
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

    // App Launcher
    readonly property color colBg: "#070000"
    readonly property color colFg: "#FFF9E5"

    readonly property color colBlack: "#070000"
    readonly property color colRed: "#775532"
    readonly property color colGreen: "#88785C"
    readonly property color colYellow: "#B98846"
    readonly property color colBlue: "#BAB187"
    readonly property color colPurple: "#F4BD82"
    readonly property color colCyan: "#FFEFB4"
    readonly property color colWhite: "#F6EFD1"

    readonly property color colBrightBlack: "#ADA792"
    readonly property color colBrightRed: "#775532"
    readonly property color colBrightGreen: "#88785C"
    readonly property color colBrightYellow: "#B98846"
    readonly property color colBrightBlue: "#BAB187"
    readonly property color colBrightPurple: "#F4BD82"
    readonly property color colBrightCyan: "#FFEFB4"
    readonly property color colBrightWhite: "#F6EFD1"

    // Text
    readonly property color text: "#E2E8F0"
    readonly property color textMuted: "#94A3B8"
    readonly property color textDisabled: "#475569"
    readonly property color textHover: '#97cbff'

    // Borders / separators
    readonly property color border: "#252B36"
    readonly property color borderActive: "#7C5CFC"

    // Shapes
    readonly property int cornerRadius: 17
    readonly property int radiusSmall: 6
    readonly property int radiusMedium: 10
    readonly property int radiusLarge: 16
    readonly property int radiusPill: 999
    // readonly property int notchHeight: 30

    // Spacing
    readonly property int spacingSmall: 4
    readonly property int spacingMedium: 8
    readonly property int spacingLarge: 12
    readonly property int spacingXLarge: 16

    // Bar
    readonly property int barHeight: 10
    readonly property int barWidth: 30
    readonly property int notchHeight: 30

    // Typography
    readonly property string fontFamily: "JetBrainsMono Nerd Font"

    readonly property int fontSize: 14
    readonly property int fontSmall: 12
    readonly property int fontLarge: 18

    // Animation
    readonly property int animFast: 120
    readonly property int animNormal: 200
    readonly property int animSlow: 350
    readonly property int smoothEasing: Easing.OutCubic
    readonly property int springEasing: Easing.OutBack

    // Notch
    property int notchPadding: 16
    // readonly property int notchRadius: 15
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