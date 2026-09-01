import Quickshell

import "modules/bar" as BarModule
import "modules/launcher" as LauncherModule

ShellRoot {
    id: shell

    BarModule.Bar {}

    LauncherModule.AppLauncher {}
}