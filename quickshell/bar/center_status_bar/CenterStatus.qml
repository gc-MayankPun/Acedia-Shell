import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
    Clock {
        id: clock
        anchors.centerIn: parent
    }

    Media {
        id: media

        anchors {
            right: clock.left
            rightMargin: 5
            verticalCenter: clock.verticalCenter
        }
    }
}