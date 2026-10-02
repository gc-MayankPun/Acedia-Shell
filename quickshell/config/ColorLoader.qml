pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    readonly property string colorsPath: Quickshell.env("HOME") + "/.config/quickshell/config/colors.json"

    // true  = use matugen's Material You colors exactly as generated (old look)
    // false = derive a more cohesive, more saturated palette from the wallpaper hue
    property bool useMaterial: false

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

    // Helpers (h, s, l are all 0..1; hue wraps around)
    function hsla(h, s, l) {
        return Qt.hsla(((h % 1) + 1) % 1, s, l, 1.0)
    }

    function hueOf(hex) {
        const h = Qt.color(hex).hslHue
        return h < 0 ? 0 : h
    }

    // Wallpaper-derived palette: one base hue, analogous accents, tinted near-black surfaces
    function applyDerived(c) {
        const h = hueOf(c.primary.dark.color)
        const hSecondary = h + 0.07   // +25 degrees
        const hTertiary = h - 0.08    // -30 degrees

        // Base
        root.background = hsla(h, 0.20, 0.065)
        root.surface = hsla(h, 0.20, 0.08)
        root.surfaceVariant = hsla(h, 0.14, 0.20)

        // Surface levels
        root.surfaceDim = hsla(h, 0.20, 0.05)
        root.surfaceBright = hsla(h, 0.16, 0.20)
        root.surfaceContainer = hsla(h, 0.18, 0.105)
        root.surfaceContainerLow = hsla(h, 0.19, 0.09)
        root.surfaceContainerHigh = hsla(h, 0.16, 0.14)
        root.surfaceContainerHighest = hsla(h, 0.15, 0.17)

        // Text
        root.text = hsla(h, 0.15, 0.90)
        root.textMuted = hsla(h, 0.10, 0.68)
        root.surfaceContent = hsla(h, 0.15, 0.90)

        // Primary
        root.primary = hsla(h, 0.78, 0.68)
        root.primaryContainer = hsla(h, 0.50, 0.24)
        root.primaryContent = hsla(h, 0.60, 0.10)
        root.primaryContainerContent = hsla(h, 0.90, 0.88)

        // Secondary
        root.secondary = hsla(hSecondary, 0.65, 0.72)
        root.secondaryContainer = hsla(hSecondary, 0.45, 0.22)
        root.secondaryContent = hsla(hSecondary, 0.60, 0.10)
        root.secondaryContainerContent = hsla(hSecondary, 0.85, 0.88)

        // Tertiary
        root.tertiary = hsla(hTertiary, 0.70, 0.70)
        root.tertiaryContainer = hsla(hTertiary, 0.45, 0.22)
        root.tertiaryContent = hsla(hTertiary, 0.60, 0.10)
        root.tertiaryContainerContent = hsla(hTertiary, 0.85, 0.88)

        // Borders
        root.border = hsla(h, 0.12, 0.40)
        root.borderVariant = hsla(h, 0.12, 0.25)

        // Error (kept from matugen so it always reads as "error")
        root.errorColor = c.error.dark.color
        root.errorContainer = c.error_container.dark.color
        root.errorContent = c.on_error.dark.color
        root.errorContainerContent = c.on_error_container.dark.color
    }

    // Plain matugen Material You colors (previous behaviour)
    function applyMaterial(c) {
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
    }

    // Parser
    function loadColors() {
        try {
            const json = JSON.parse(colorFile.text())
            const c = json.colors

            if (root.useMaterial)
                root.applyMaterial(c)
            else
                root.applyDerived(c)

            console.log(
                "ColorLoader: colors updated",
                "| mode:", root.useMaterial ? "material" : "derived",
                "| primary:", root.primary,
                "| background:", root.background
            )

        } catch (error) {
            console.log("ColorLoader: JSON parse failed:", error)
        }
    }
}