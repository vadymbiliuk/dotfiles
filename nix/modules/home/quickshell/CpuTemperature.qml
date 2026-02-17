import QtQuick
import Quickshell
import Quickshell.Io
import "." as Local

Rectangle {
    id: cpuTemperature

    property string temperature: "0"

    width: row.implicitWidth
    height: Local.Theme.size.barHeight - Local.Theme.spacing.normal
    radius: Local.Theme.radius.small
    color: Local.Theme.colors.transparent

    Process {
        id: cpuTempProcess
        command: ["bash", "-c", "cat /sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon2/temp1_input | awk '{print int($1/1000)}'"]
        running: true

        stdout: SplitParser {
            onRead: line => {
                if (line && line.trim() !== "") {
                    cpuTemperature.temperature = line.trim();
                }
            }
        }
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            cpuTempProcess.running = false;
            cpuTempProcess.running = true;
        }
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: Local.Theme.spacing.small

        Local.MaterialSymbol {
            icon: "memory"
            iconSize: Local.Theme.font.huge
            color: Local.Theme.colors.foreground
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: cpuTemperature.temperature + "°C"
            font.family: Local.Theme.font.family
            font.pixelSize: Local.Theme.font.large
            color: Local.Theme.colors.foreground
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
