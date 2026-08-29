import QtQuick

import "../theme"

Rectangle {
    id: searchBar

    property alias searchText: searchInput.text

    anchors {
        left: parent.left
        right: parent.right
        top: parent.top

        leftMargin: Theme.spacingLarge
        rightMargin: Theme.spacingLarge
        topMargin: 10
    }

    height: 40
    radius: Theme.radiusLarge

    color: Theme.surface

    border {
        width: 1
        color: Theme.border
    }

    // Search icon
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

    // Actual input
    TextInput {
        id: searchInput
        focus: true

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter

            leftMargin: 30
            rightMargin: Theme.spacingLarge
        }

        color: Theme.text
        selectionColor: Theme.primary

        font {
            family: Theme.fontFamily
            pixelSize: Theme.fontSmall
        }

        clip: true

        // Placeholder
        Text {
            anchors.fill: parent

            text: "Search Applications..."
            color: Theme.textMuted

            font: parent.font

            visible: !parent.text && !parent.activeFocus
        }
    }
}