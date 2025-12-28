import QtQuick
import Quickshell
import Quickshell.Io
import "." as Local

Rectangle {
    id: outputVolume

    property string volume: "0"
    signal requestViewSwitch(string view)

    width: row.implicitWidth
    height: Local.Theme.size.barHeight - Local.Theme.spacing.normal
    radius: Local.Theme.radius.small
    color: Local.Theme.colors.transparent

    Process {
        id: outputVolumeProcess
        command: ["bash", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}'"]
        running: true

        stdout: SplitParser {
            onRead: line => {
                if (line && line.trim() !== "") {
                    outputVolume.volume = line.trim();
                }
            }
        }
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            outputVolumeProcess.running = false;
            outputVolumeProcess.running = true;
        }
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: Local.Theme.spacing.small

        Local.MaterialSymbol {
            icon: "volume_up"
            iconSize: Local.Theme.font.huge
            color: Local.Theme.colors.foreground
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: outputVolume.volume + "%"
            font.family: Local.Theme.font.family
            font.pixelSize: Local.Theme.font.large
            color: Local.Theme.colors.foreground
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    
    MouseArea {
        id: outputVolumeMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            outputVolume.requestViewSwitch("output");
        }
    }
}