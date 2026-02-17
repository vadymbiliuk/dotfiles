import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import "." as Local

PanelWindow {
    id: bar

    property string hostname: ""

    Process {
        id: hostnameProcess
        command: ["hostname"]
        running: true
        stdout: SplitParser {
            onRead: data => bar.hostname = data.trim()
        }
    }

    signal toggleControlCenter()
    signal openControlCenterWithView(string view)
    WlrLayershell.layer: WlrLayer.Bottom
    anchors {
        left: true
        right: true
        top: true
    }
    implicitHeight: Local.Theme.size.barHeight
    margins {
        left: Local.Theme.spacing.normal
        right: Local.Theme.spacing.normal
        top: Local.Theme.spacing.normal
    }

    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: Local.Theme.panelBackground
        radius: Local.Theme.radius.normal
        border.width: Local.Theme.border.thick
        border.color: Local.Theme.border.color

        Row {
            anchors.left: parent.left
            anchors.leftMargin: Local.Theme.spacing.large
            anchors.verticalCenter: parent.verticalCenter
            spacing: Local.Theme.spacing.large

            Rectangle {
                width: systemRow.implicitWidth
                height: Local.Theme.size.barHeight - Local.Theme.spacing.normal
                radius: Local.Theme.radius.small
                color: Local.Theme.colors.transparent

                Row {
                    id: systemRow
                    anchors.centerIn: parent
                    spacing: Local.Theme.spacing.large

                    Text {
                        text: Local.Theme.osIcon
                        font.family: Local.Theme.font.family
                        font.pixelSize: Local.Theme.font.huge
                        color: Local.Theme.colors.foreground
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: Quickshell.env("USER") + "@" + bar.hostname
                        font.family: Local.Theme.font.family
                        font.pixelSize: Local.Theme.font.large
                        color: Local.Theme.colors.foreground
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -1
                    }
                }
            }

            Rectangle {
                width: workspaceRow.implicitWidth
                height: Local.Theme.size.barHeight - Local.Theme.spacing.normal
                radius: Local.Theme.radius.small
                color: Local.Theme.colors.transparent

                Row {
                    id: workspaceRow
                    anchors.centerIn: parent
                    spacing: Local.Theme.spacing.small

                    Repeater {
                        model: 10

                        Rectangle {
                            property int workspaceId: index + 1
                            property bool isActive: workspaceId === (Hyprland.focusedWorkspace?.id ?? 0)
                            property bool hasWindows: {
                                if (!Hyprland.workspaces)
                                    return false;
                                for (let i = 0; i < Hyprland.workspaces.length; i++) {
                                    let workspace = Hyprland.workspaces[i];
                                    if (workspace.id === workspaceId && workspace.windows > 0) {
                                        return true;
                                    }
                                }
                                return false;
                            }

                            width: isActive ? Local.Theme.size.workspaceActiveWidth : Local.Theme.size.workspaceWidth
                            height: Local.Theme.size.workspaceHeight
                            radius: Local.Theme.radius.small

                            color: {
                                if (isActive)
                                    return Local.Theme.colors.workspaceActive;
                                if (hasWindows)
                                    return Local.Theme.colors.workspaceOccupied;
                                return Local.Theme.colors.workspaceEmpty;
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Hyprland.dispatch("workspace " + (index + 1).toString())
                            }

                            Behavior on width {
                                NumberAnimation {
                                    duration: 200
                                }
                            }
                        }
                    }
                }
            }
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: Local.Theme.spacing.large
            anchors.verticalCenter: parent.verticalCenter
            spacing: Local.Theme.spacing.large

            Local.SystemTray {
                anchors.verticalCenter: parent.verticalCenter
            }

            Local.Network {
                anchors.verticalCenter: parent.verticalCenter
                onRequestViewSwitch: view => {
                    bar.openControlCenterWithView(view);
                }
            }

            Local.Bluetooth {
                anchors.verticalCenter: parent.verticalCenter
                onRequestViewSwitch: view => {
                    bar.openControlCenterWithView(view);
                }
            }

            Local.Protection {
                anchors.verticalCenter: parent.verticalCenter
                onRequestViewSwitch: view => {
                    bar.openControlCenterWithView(view);
                }
            }

            Local.DndWidget {
                anchors.verticalCenter: parent.verticalCenter
                onRequestViewSwitch: view => {
                    bar.openControlCenterWithView(view);
                }
            }

            Local.OutputVolume {
                anchors.verticalCenter: parent.verticalCenter
                onRequestViewSwitch: view => {
                    bar.openControlCenterWithView(view);
                }
            }

            Local.InputVolume {
                anchors.verticalCenter: parent.verticalCenter
                onRequestViewSwitch: view => {
                    bar.openControlCenterWithView(view);
                }
            }

            Local.Weather {
                anchors.verticalCenter: parent.verticalCenter
            }

            Local.GpuTemperature {
                anchors.verticalCenter: parent.verticalCenter
            }

            Local.CpuTemperature {
                anchors.verticalCenter: parent.verticalCenter
            }

            Local.LanguageSwitcher {
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: timestampText
                text: Qt.formatDateTime(new Date(), "hh:mm | MMM d")
                font.family: Local.Theme.font.family
                font.pixelSize: Local.Theme.font.large
                color: Local.Theme.colors.foreground
                anchors.verticalCenter: parent.verticalCenter

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: timestampText.text = Qt.formatDateTime(new Date(), "hh:mm | MMM d")
                }
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: bar.openControlCenterWithView("main")
                }
            }
        }
    }
}
