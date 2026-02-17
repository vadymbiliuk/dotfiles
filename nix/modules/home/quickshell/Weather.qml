import QtQuick
import Quickshell
import Quickshell.Io
import "." as Local

Rectangle {
    id: weather

    property string temperature: "N/A"
    property string condition: ""
    property string icon: "thermometer"

    width: row.implicitWidth
    height: Local.Theme.size.barHeight - Local.Theme.spacing.normal
    radius: Local.Theme.radius.small
    color: Local.Theme.colors.transparent

    Process {
        id: weatherProcess
        command: ["sh", "-c", "curl -s 'wttr.in/Kyiv?format=%t|%C' 2>/dev/null || echo 'N/A|'"]
        running: true

        stdout: SplitParser {
            onRead: line => {
                if (line && line.trim() !== "") {
                    let parts = line.trim().split("|");
                    if (parts.length >= 1) {
                        weather.temperature = parts[0].trim();
                    }
                    if (parts.length >= 2) {
                        weather.condition = parts[1].trim();
                        weather.icon = getWeatherIcon(parts[1].toLowerCase());
                    }
                }
            }
        }
    }

    Timer {
        interval: 600000
        running: true
        repeat: true
        onTriggered: {
            weatherProcess.running = false;
            weatherProcess.running = true;
        }
    }

    function getWeatherIcon(condition) {
        if (condition.includes("clear") || condition.includes("sunny")) {
            return "sunny";
        } else if (condition.includes("cloud") || condition.includes("overcast")) {
            return "cloud";
        } else if (condition.includes("rain") || condition.includes("drizzle") || condition.includes("shower")) {
            return "rainy";
        } else if (condition.includes("snow") || condition.includes("sleet")) {
            return "weather_snowy";
        } else if (condition.includes("fog") || condition.includes("mist") || condition.includes("haze")) {
            return "foggy";
        } else if (condition.includes("thunder") || condition.includes("storm")) {
            return "thunderstorm";
        } else {
            return "thermometer";
        }
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: Local.Theme.spacing.small

        Local.MaterialSymbol {
            icon: weather.icon
            iconSize: Local.Theme.font.huge
            color: Local.Theme.colors.foreground
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: weather.temperature
            font.family: Local.Theme.font.family
            font.pixelSize: Local.Theme.font.large
            color: Local.Theme.colors.foreground
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
            weatherProcess.running = false;
            weatherProcess.running = true;
        }
    }
}