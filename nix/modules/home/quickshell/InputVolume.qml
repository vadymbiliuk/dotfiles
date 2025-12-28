import QtQuick
import Quickshell
import Quickshell.Io
import "." as Local

Rectangle {
    id: inputVolume

    property string volume: "0"
    signal requestViewSwitch(string view)

    width: row.implicitWidth
    height: Local.Theme.size.barHeight - Local.Theme.spacing.normal
    radius: Local.Theme.radius.small
    color: Local.Theme.colors.transparent

    Process {
        id: inputVolumeProcess
        command: ["bash", "-c", "wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print int($2*100)}'"]
        running: true

        stdout: SplitParser {
            onRead: line => {
                if (line && line.trim() !== "") {
                    inputVolume.volume = line.trim();
                }
            }
        }
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            inputVolumeProcess.running = false;
            inputVolumeProcess.running = true;
        }
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: Local.Theme.spacing.small

        Local.MaterialSymbol {
            icon: "mic"
            iconSize: Local.Theme.font.huge
            color: Local.Theme.colors.foreground
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: inputVolume.volume + "%"
            font.family: Local.Theme.font.family
            font.pixelSize: Local.Theme.font.large
            color: Local.Theme.colors.foreground
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    
    MouseArea {
        id: inputVolumeMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            inputVolume.requestViewSwitch("input");
        }
    }
}