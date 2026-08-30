import Quickshell 
import Quickshell.Wayland

import "./bar" 
import "./app_launcher"

ShellRoot {
    id: shell 

    Bar {}
    
    AppLauncher {}
}