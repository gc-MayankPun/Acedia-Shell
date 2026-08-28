import Quickshell 
import Quickshell.Wayland

import "./bar"

ShellRoot {
    id: shell

    property string title: "Hello from Quickshell!"
    
    Bar {
        title: shell.title
    }
}