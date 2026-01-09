import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import "." as Local

PanelWindow {
    id: notificationArea
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.exclusiveZone: 0
    anchors {
        right: true
        top: true
    }
    implicitWidth: 400
    implicitHeight: 600
    margins {
        right: 12
        top: 12
    }
    color: "transparent"
    visible: true

    Column {
        anchors.fill: parent
        spacing: Local.Theme.spacing.small

        Repeater {
            model: Local.NotificationService.activePopups

            Rectangle {
                required property var modelData
                required property int index

                width: parent.width
                height: notifContent.implicitHeight + Local.Theme.spacing.large + (modelData.actions && modelData.actions.length > 0 ? Local.Theme.spacing.normal : Local.Theme.spacing.large)
                color: Local.Theme.panelBackground
                radius: Local.Theme.radius.normal
                border.width: Local.Theme.border.thick
                border.color: Local.Theme.border.color
                visible: true

                Column {
                    id: notifContent
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: Local.Theme.spacing.large
                    anchors.leftMargin: Local.Theme.spacing.large
                    anchors.rightMargin: Local.Theme.spacing.large
                    spacing: Local.Theme.spacing.normal

                    Row {
                        width: parent.width
                        spacing: Local.Theme.spacing.normal

                        Rectangle {
                            property string iconSource: parent.parent.parent.modelData.image || parent.parent.parent.modelData.appIcon || ""
                            width: 48
                            height: 48
                            radius: 6
                            color: iconSource === "" ? Local.Theme.colors.gray3 : "transparent"
                            clip: true
                            anchors.verticalCenter: parent.verticalCenter

                            IconImage {
                                anchors.fill: parent
                                anchors.margins: 4
                                source: parent.iconSource
                                visible: parent.iconSource !== ""
                                onStatusChanged: {
                                    if (status === Image.Error) {
                                        console.log("Failed to load icon:", source);
                                    }
                                }
                            }

                            Local.MaterialSymbol {
                                icon: "notifications"
                                iconSize: 20
                                anchors.centerIn: parent
                                visible: parent.iconSource === ""
                                color: Local.Theme.colors.gray6
                            }
                        }

                        Column {
                            width: parent.width - parent.children[0].width - closeButton.width - parent.spacing * 2
                            spacing: Local.Theme.spacing.small

                            Text {
                                text: parent.parent.parent.parent.modelData.summary
                                font.family: Local.Theme.font.family
                                font.pixelSize: Local.Theme.font.large
                                font.weight: Font.Bold
                                color: Local.Theme.colors.foreground
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }

                            Text {
                                text: parent.parent.parent.parent.modelData.body
                                font.family: Local.Theme.font.family
                                font.pixelSize: Local.Theme.font.normal
                                color: Local.Theme.colors.foreground
                                wrapMode: Text.WordWrap
                                width: parent.width
                                visible: text.length > 0
                            }
                        }

                        Rectangle {
                            id: closeButton
                            width: 20
                            height: 20
                            radius: 10
                            color: closeMouse.containsMouse ? Local.Theme.colors.gray4 : Local.Theme.colors.gray3
                            anchors.top: parent.top

                            Local.MaterialSymbol {
                                icon: "close"
                                iconSize: 12
                                color: Local.Theme.colors.foreground
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                id: closeMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    Local.NotificationService.removeNotification(parent.parent.parent.parent.modelData);
                                }
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Local.Theme.colors.gray3
                        visible: parent.parent.modelData.actions && parent.parent.modelData.actions.length > 0
                    }

                    Row {
                        width: parent.width
                        height: 32
                        spacing: Local.Theme.spacing.small
                        visible: parent.parent.modelData.actions && parent.parent.modelData.actions.length > 0
                        layoutDirection: Qt.RightToLeft

                        Repeater {
                            model: parent.parent.parent.modelData.actions || []

                            Rectangle {
                                required property var modelData
                                required property int index
                                property var notificationItem: parent.parent.parent.modelData

                                width: actionText.implicitWidth + Local.Theme.spacing.normal * 2
                                height: 28
                                radius: Local.Theme.radius.small
                                color: actionMouse.containsMouse ? Local.Theme.colors.gray2 : Local.Theme.colors.gray1
                                border.width: 1
                                border.color: Local.Theme.colors.gray3

                                Text {
                                    id: actionText
                                    text: parent.modelData.text
                                    font.family: Local.Theme.font.family
                                    font.pixelSize: Local.Theme.font.small
                                    color: Local.Theme.colors.foreground
                                    anchors.centerIn: parent
                                }

                                MouseArea {
                                    id: actionMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        parent.modelData.invoke();
                                        Local.NotificationService.removeNotification(parent.notificationItem);
                                    }
                                }
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.bottomMargin: parent.modelData.actions && parent.modelData.actions.length > 0 ? 45 : 0
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Local.NotificationService.removeNotification(parent.modelData)
                }
            }
        }
    }
}
