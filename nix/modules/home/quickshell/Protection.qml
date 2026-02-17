import QtQuick
import "." as Local

Rectangle {
    id: protection

    signal requestViewSwitch(string view)

    width: row.implicitWidth
    height: Local.Theme.size.barHeight - Local.Theme.spacing.normal
    radius: Local.Theme.radius.small
    color: Local.Theme.colors.transparent

    Row {
        id: row
        anchors.centerIn: parent

        Local.MaterialSymbol {
            icon: Local.AntivirusState.daemonRunning ? "shield" : "shield_with_heart"
            iconSize: Local.Theme.font.huge
            color: Local.AntivirusState.daemonRunning ? Local.Theme.colors.foreground : Local.Theme.colors.gray6
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            protection.requestViewSwitch("protection");
        }
    }
}