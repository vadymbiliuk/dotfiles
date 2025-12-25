import QtQuick
import "." as Local

Rectangle {
    id: bluetooth

    signal requestViewSwitch(string view)

    width: row.implicitWidth
    height: Local.Theme.size.barHeight - Local.Theme.spacing.normal
    radius: Local.Theme.radius.small
    color: Local.Theme.colors.transparent

    Row {
        id: row
        anchors.centerIn: parent

        Local.MaterialSymbol {
            icon: Local.BluetoothState.enabled ? "bluetooth" : "bluetooth_disabled"
            iconSize: Local.Theme.font.huge
            color: Local.BluetoothState.enabled ? Local.Theme.colors.foreground : Local.Theme.colors.gray6
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            bluetooth.requestViewSwitch("bluetooth");
        }
    }
}