import QtQuick
import QtQuick.Layouts

import "../theme"

Item {
    Layout.fillWidth: true
    Layout.preferredHeight: 50

    RowLayout {
        anchors.fill: parent
        spacing: Theme.spacingMedium

        // App image
        Rectangle {
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40

            radius: Theme.radiusMedium
            color: "red"
        }

        // App name
        Text {
            Layout.fillWidth: true
            
            text: "Firefox"
            color: Theme.text

            font {
                family: Theme.fontFamily
                pixelSize: Theme.fontSmall
            }
        }
    }
}