import QtQuick
import "." as Local

Rectangle {
    id: dndWidget
    
    width: row.implicitWidth
    height: Local.Theme.size.barHeight - Local.Theme.spacing.normal
    radius: Local.Theme.radius.small
    color: Local.Theme.colors.transparent
    visible: Local.DNDState.enabled

    Row {
        id: row
        anchors.centerIn: parent

        Local.MaterialSymbol {
            icon: Local.DNDState.profile === "work" ? "work" : "nightlight"
            iconSize: Local.Theme.font.huge
            color: Local.Theme.colors.foreground
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    signal requestViewSwitch(string view)

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            dndWidget.requestViewSwitch("silent");
        }
    }
}