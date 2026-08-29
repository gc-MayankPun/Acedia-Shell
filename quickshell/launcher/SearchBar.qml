import QtQuick

import "../theme"

Rectangle {
    id: searchBar

    anchors {
        left: parent.left
        right: parent.right
        top: parent.top

        leftMargin: Theme.spacingLarge
        rightMargin: Theme.spacingLarge
        topMargin: 20
    }

    height: 40
    radius: Theme.radiusLarge
    color: Theme.surface

    border {
        width: 1
        color: Theme.border
    }

    Text {
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter

            leftMargin: Theme.spacingLarge
        }

        text: "󰍉"
        color: Theme.textMuted

        font {
            family: Theme.fontFamily
            pixelSize: Theme.fontSize
        }
    }

    Text {
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter

            leftMargin: 30
        }

        text: "Search Applications..."
        color: Theme.textMuted

        font {
            family: Theme.fontFamily
            pixelSize: Theme.fontSmall
        }
    }
}