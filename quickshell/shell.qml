import Quickshell

import "modules/bar" as BarModule
import "modules/launcher" as LauncherModule
import "modules/wallpaper" as WallpaperModule 
import "modules/notifications" as NotificationModule
import "modules/settings" as SettingsModule 

ShellRoot {
    id: shell

    BarModule.Bar {}

    LauncherModule.AppLauncher {}

    WallpaperModule.Wallpaper {}

    NotificationModule.Notifications {} 

    SettingsModule.SettingsPopup {}
}