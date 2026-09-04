pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    readonly property string colorsPath: Quickshell.env("HOME") + "/.config/quickshell/config/colors.json"

    // Background
    property color background
    property color surface
    property color surfaceVariant

    // Surface levels
    property color surfaceDim
    property color surfaceBright
    property color surfaceContainer
    property color surfaceContainerLow
    property color surfaceContainerHigh
    property color surfaceContainerHighest

    // Text/content
    property color text
    property color textMuted
    property color surfaceContent

    // Primary
    property color primary
    property color primaryContainer
    property color primaryContent
    property color primaryContainerContent

    // Secondary
    property color secondary
    property color secondaryContainer
    property color secondaryContent
    property color secondaryContainerContent

    // Tertiary
    property color tertiary
    property color tertiaryContainer
    property color tertiaryContent
    property color tertiaryContainerContent

    // Outline
    property color border
    property color borderVariant

    // Error
    property color errorColor
    property color errorContainer
    property color errorContent
    property color errorContainerContent
 
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