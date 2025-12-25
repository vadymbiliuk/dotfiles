import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import Quickshell.Wayland
import "." as Local

Scope {
    id: root

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Connections {
        target: Pipewire.defaultAudioSink?.audio ?? null

        function onVolumeChanged() {
            root.shouldShowOsd = true;
            hideTimer.restart();
        }

        function onMutedChanged() {
            root.shouldShowOsd = true;
            hideTimer.restart();
        }
    }

    property bool shouldShowOsd: false

    Timer {
        id: hideTimer
        interval: 2000
        onTriggered: root.shouldShowOsd = false
    }

    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            visible: true
            exclusiveZone: 0
            anchors.bottom: true
            margins.bottom: 100
            WlrLayershell.layer: WlrLayer.Overlay

            implicitWidth: 300
            implicitHeight: 80
            color: "transparent"

            mask: Region {}

            Rectangle {
                anchors.centerIn: parent
                width: 280
                height: 60
                color: Local.Theme.panelBackground
                radius: Local.Theme.radius.normal
                border.width: Local.Theme.border.thick
                border.color: Local.Theme.border.color

                Row {
                    anchors.centerIn: parent
                    spacing: Local.Theme.spacing.large

                    Local.MaterialSymbol {
                        property real volume: Pipewire.defaultAudioSink?.audio.muted ? 0 : (Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100
                        icon: {
                            if (Pipewire.defaultAudioSink?.audio.muted)
                                return "volume_off";
                            return volume > 50 ? "volume_up" : volume > 0 ? "volume_down" : "volume_off";
                        }
                        iconSize: Local.Theme.font.huge
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Rectangle {
                        width: 180
                        height: 6
                        color: Local.Theme.colors.gray4
                        radius: 3
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            property real volume: Pipewire.defaultAudioSink?.audio.muted ? 0 : (Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100
                            width: parent.width * (volume / 100)
                            height: parent.height
                            color: Pipewire.defaultAudioSink?.audio.muted ? Local.Theme.colors.red : Local.Theme.colors.foreground
                            radius: parent.radius
                        }
                    }

                    Text {
                        property real volume: Pipewire.defaultAudioSink?.audio.muted ? 0 : (Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100
                        text: Math.round(volume) + "%"
                        font.family: Local.Theme.font.family
                        font.pixelSize: Local.Theme.font.large
                        color: Local.Theme.colors.foreground
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
