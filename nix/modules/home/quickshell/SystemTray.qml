import QtQuick
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick.Layouts
import "." as Local

Rectangle {
    id: systemTray

    width: layout.width
    height: Local.Theme.size.barHeight - Local.Theme.spacing.normal
    radius: Local.Theme.radius.small
    color: Local.Theme.colors.transparent
    visible: items.count > 0

    Row {
        id: layout
        anchors.centerIn: parent
        spacing: Local.Theme.spacing.large

        Repeater {
            id: items
            model: SystemTray.items

            delegate: Item {
                id: trayItemRoot
                required property SystemTrayItem modelData
                implicitWidth: 20
                implicitHeight: 20

                IconImage {
                    source: {
                        let icon = trayItemRoot.modelData.icon;
                        if (icon.includes("?path=")) {
                            const [name, path] = icon.split("?path=");
                            icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
                        }
                        return icon;
                    }
                    asynchronous: true
                    anchors.fill: parent
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    hoverEnabled: true

                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton) {
                            trayItemRoot.modelData.activate();
                        } else if (mouse.button === Qt.RightButton) {
                            trayItemRoot.modelData.activate();
                        }
                    }
                }
            }
        }
    }
}
