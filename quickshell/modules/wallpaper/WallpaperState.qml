pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import QtCore

QtObject {
    id: root

    property bool wallpaperVisible: false

    property string folderPath: "$HOME/Pictures/Wallpapers"
    property string monitorOutput: "eDP-1"

    property var wallpapers: []
    property int selectedIndex: 0
    property string currentWallpaper: ""

    property string wallpaperSavePath: Quickshell.env("HOME") + "/.config/quickshell/modules/wallpaper/current"
    property FileView wallpaperFile: FileView {
        path: root.wallpaperSavePath

        onLoaded: {
            const path = text().trim()

            if (path === "") {
                console.log("Saved wallpaper is empty")
                return
            }

            root.currentWallpaper = "file://" + path
            console.log("Loaded wallpaper:", path)

            root.restoreWallpaper()
        }

        onLoadFailed: function(error) { console.log("No saved wallpaper found") }
        onSaved: { console.log("Wallpaper saved successfully") }
        onSaveFailed: function(error) { console.log("Wallpaper save failed:", error) }
    }

    property Process scanProc: Process {
        command: [
            "bash",
            "-c",
            "find \"" + root.folderPath + "\" -maxdepth 1 -type f " +
            "\\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' " +
            "-o -iname '*.gif' -o -iname '*.webp' -o -iname '*.bmp' \\) " +
            "-print"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim()
                    .split("\n")
                    .filter(line => line.length > 0)

                root.wallpapers = lines.map(path => "file://" + path)

                if (root.currentWallpaper !== "") {
                    const index = root.wallpapers.indexOf(root.currentWallpaper)

                    if (index !== -1) root.selectedIndex = index
                }

                if (root.selectedIndex >= root.wallpapers.length) root.selectedIndex = 0

                console.log("Wallpapers:", root.wallpapers.length)
            }
        }
    }

    property Process wallpaperProc: Process {
        command: []
    }

    Component.onCompleted: { scanProc.running = true }

    function toggle() { wallpaperVisible = !wallpaperVisible }
    function show() { wallpaperVisible = true }
    function hide() { wallpaperVisible = false }

    function rescan() {
        if (!scanProc.running) scanProc.running = true
    }

    function next() {
        if (wallpapers.length === 0) return

        if (selectedIndex < wallpapers.length - 1) selectedIndex++
    }

    function previous() {
        if (wallpapers.length === 0) return

        if (selectedIndex > 0) selectedIndex--
    }

    function saveWallpaper(path) {
        wallpaperFile.setText(path)
        console.log("Saved wallpaper:", path)
    }

    function applySelected() {
        if (wallpapers.length === 0) return

        let path = wallpapers[selectedIndex].toString()

        if (path.startsWith("file://"))
            path = path.substring(7)

        let wallpaperUrl = "file://" + path

        // Already applied
        if (wallpaperUrl === currentWallpaper) {
            console.log("Wallpaper already active:", path)
            return
        }

        currentWallpaper = wallpaperUrl
        saveWallpaper(path)

        console.log("Setting wallpaper:", path)

        wallpaperProc.command = [
            "awww",
            "img",
            "--transition-type",
            "random",
            "--transition-pos",
            "0.854, 0.977",
            "--transition-step",
            "150",
            path
        ]

        wallpaperProc.running = true
    }

    function restoreWallpaper() {
        if (currentWallpaper === "") return

        let path = currentWallpaper

        if (path.startsWith("file://")) path = path.substring(7)

        console.log("Restoring wallpaper:", path)

        wallpaperProc.command = [
            "awww",
            "img",
            path,
            "--transition-type",
            "fade",
            "--transition-step",
            "150"
        ]

        wallpaperProc.running = true
    }
}