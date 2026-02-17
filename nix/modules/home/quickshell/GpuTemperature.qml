import QtQuick
import Quickshell
import Quickshell.Io
import "." as Local

Rectangle {
    id: gpuTemperature

    property string temperature: "0"

    width: row.implicitWidth
    height: Local.Theme.size.barHeight - Local.Theme.spacing.normal
    radius: Local.Theme.radius.small
    color: Local.Theme.colors.transparent

    Process {
        id: gpuTempProcess
        command: ["nvidia-smi", "--query-gpu=temperature.gpu", "--format=csv,noheader,nounits"]
        running: true

        stdout: SplitParser {
            onRead: line => {
                if (line && line.trim() !== "") {
                    gpuTemperature.temperature = line.trim();
                }
            }
        }
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            gpuTempProcess.running = false;
            gpuTempProcess.running = true;
        }
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: Local.Theme.spacing.small

        Local.MaterialSymbol {
            icon: "developer_board"
            iconSize: Local.Theme.font.huge
            color: Local.Theme.colors.foreground
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: gpuTemperature.temperature + "°C"
            font.family: Local.Theme.font.family
            font.pixelSize: Local.Theme.font.large
            color: Local.Theme.colors.foreground
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
