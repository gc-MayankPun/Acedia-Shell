pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    readonly property string colorsPath: Quickshell.env("HOME") + "/.config/quickshell/config/colors.json"

    // Background
    property color background: "#1E1E2E"
    property color surface: "#181825"
    property color surfaceVariant: "#313244"

    // Surface levels
    property color surfaceDim: "#14141F"
    property color surfaceBright: "#45475A"
    property color surfaceContainer: "#1C1C2B"
    property color surfaceContainerLow: "#181824"
    property color surfaceContainerHigh: "#252536"
    property color surfaceContainerHighest: "#313244"

    // Text/content
    property color text: "#CDD6F4"
    property color textMuted: "#A6ADC8"
    property color surfaceContent: "#CDD6F4"

    // Primary
    property color primary: "#89B4FA"
    property color primaryContainer: "#1E3A5F"
    property color primaryContent: "#FFFFFF"
    property color primaryContainerContent: "#D6E4FF"

    // Secondary
    property color secondary: "#F5C2E7"
    property color secondaryContainer: "#4A3045"
    property color secondaryContent: "#FFFFFF"
    property color secondaryContainerContent: "#FFD6F5"

    // Tertiary
    property color tertiary: "#94E2D5"
    property color tertiaryContainer: "#254943"
    property color tertiaryContent: "#FFFFFF"
    property color tertiaryContainerContent: "#C8FFF6"

    // Outline
    property color border: "#6C7086"
    property color borderVariant: "#45475A"

    // Error
    property color errorColor: "#F38BA8"
    property color errorContainer: "#5C2636"
    property color errorContent: "#FFFFFF"
    property color errorContainerContent: "#FFD9E1"
 
    // JSON file
    property FileView colorFile: FileView {
        path: root.colorsPath

        watchChanges: true

        onLoaded: {
            root.loadColors()
        }

        onFileChanged: {
            reload()
        }

        onLoadFailed: function(error) {
            console.log("ColorLoader: failed to load colors.json:", error)
        }
    }
 
    // Parser 
    function loadColors() {
        try {
            const json = JSON.parse(colorFile.text())
            const c = json.colors

            // Base
            root.background = c.background.dark.color
            root.surface = c.surface.dark.color
            root.surfaceVariant = c.surface_variant.dark.color

            // Surface levels
            root.surfaceDim = c.surface_dim.dark.color
            root.surfaceBright = c.surface_bright.dark.color
            root.surfaceContainer = c.surface_container.dark.color
            root.surfaceContainerLow = c.surface_container_low.dark.color
            root.surfaceContainerHigh = c.surface_container_high.dark.color
            root.surfaceContainerHighest = c.surface_container_highest.dark.color

            // Text
            root.text = c.on_background.dark.color
            root.textMuted = c.on_surface_variant.dark.color
            root.surfaceContent = c.on_surface.dark.color

            // Primary
            root.primary = c.primary.dark.color
            root.primaryContainer = c.primary_container.dark.color
            root.primaryContent = c.on_primary.dark.color
            root.primaryContainerContent = c.on_primary_container.dark.color

            // Secondary
            root.secondary = c.secondary.dark.color
            root.secondaryContainer = c.secondary_container.dark.color
            root.secondaryContent = c.on_secondary.dark.color
            root.secondaryContainerContent = c.on_secondary_container.dark.color

            // Tertiary
            root.tertiary = c.tertiary.dark.color
            root.tertiaryContainer = c.tertiary_container.dark.color
            root.tertiaryContent = c.on_tertiary.dark.color
            root.tertiaryContainerContent = c.on_tertiary_container.dark.color

            // Borders
            root.border = c.outline.dark.color
            root.borderVariant = c.outline_variant.dark.color

            // Error
            root.errorColor = c.error.dark.color
            root.errorContainer = c.error_container.dark.color
            root.errorContent = c.on_error.dark.color
            root.errorContainerContent = c.on_error_container.dark.color

            console.log(
                "ColorLoader: colors updated",
                "| primary:", root.primary,
                "| background:", root.background
            )

        } catch (error) {
            console.log("ColorLoader: JSON parse failed:", error)
        }
    }
}