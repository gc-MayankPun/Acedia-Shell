import Quickshell

import "modules/bar" as BarModule
import "modules/launcher" as LauncherModule
import "modules/wallpaper" as WallpaperModule

ShellRoot {
    id: shell

    BarModule.Bar {}

    LauncherModule.AppLauncher {}

    WallpaperModule.Wallpaper {}
}