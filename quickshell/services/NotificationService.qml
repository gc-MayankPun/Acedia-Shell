import Quickshell 
import Quickshell.Io
import Quickshell.Services.Notifications
import QtQuick

import "../config" as Config

Scope {
    id: root
    property bool centerOpen: false
    property alias history: history

    ListModel {
        id: history
    }

    NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        imageSupported: true

        onNotification: n => {
            history.insert(0, {
                notification: n,
                summary: n.summary,
                body: n.body,
                appName: n.appName,
                urgency: n.urgency,
                time: Qt.formatDateTime(new Date(), "HH:mm")
            })
            n.tracked = true
        }
    }

    function dismiss(notification) {
        notification.dismiss()

        for (let i = 0; i < history.count; i++) {
            if (history.get(i).notification === notification) {
                history.remove(i)
                break
            }
        }
    }

    IpcHandler {
        target: "notifications"

        function toggle() : void { root.centerOpen = !root.centerOpen }
        function show() : void { root.centerOpen = true }
        function hide() : void { root.centerOpen = false }
    }
}