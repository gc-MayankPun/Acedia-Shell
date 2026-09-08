pragma Singleton

import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Singleton {
    ListModel {
        id: historyModel
    }

    property bool isNotificationPopupOpen: false
    property alias history: historyModel
    property bool hasNotifications: history.count !== 0
    property int clickedNotif: -1

    NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        imageSupported: true

        onNotification: n => {
            history.insert(0, {
                summary: n.summary,
                body: n.body,
                appName: n.appName,
                urgency: n.urgency,
                time: Qt.formatDateTime(new Date(), "HH:mm")
            })
            n.tracked = true
        }
    }

    function toggle() { isNotificationPopupOpen = !isNotificationPopupOpen }
    function show() { isNotificationPopupOpen = true }
    function hide() { isNotificationPopupOpen = false }
}