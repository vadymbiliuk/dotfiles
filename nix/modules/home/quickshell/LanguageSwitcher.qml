import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "." as Local

Rectangle {
    id: languageSwitcher

    property string currentLayout: "US"
    property string keyboardName: "wooting-wooting-80he"
    property string lastOutput: ""

    width: languageText.implicitWidth
    height: Local.Theme.size.barHeight - Local.Theme.spacing.normal
    radius: Local.Theme.radius.small
    color: Local.Theme.colors.transparent

    Process {
        id: layoutChecker
        command: ["bash", "-c", "hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap' | head -1"]
        running: true

        stdout: SplitParser {
            onRead: line => {
                if (line && line !== lastOutput) {
                    lastOutput = line;
                    languageSwitcher.currentLayout = languageSwitcher.getShortLayout(line);
                }
            }
        }
    }

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            layoutChecker.running = false;
            layoutChecker.running = true;
        }
    }

    function getShortLayout(fullLayout) {
        if (fullLayout.includes("English") || fullLayout.includes("US"))
            return "US";
        if (fullLayout.includes("Russian"))
            return "RU";
        if (fullLayout.includes("Ukrainian"))
            return "UA";

        var parts = fullLayout.split(/[\s\(\)]+/);
        if (parts.length > 0) {
            return parts[0].substring(0, 2).toUpperCase();
        }
        return "??";
    }

    Text {
        id: languageText
        text: languageSwitcher.currentLayout
        font.family: Local.Theme.font.family
        font.pixelSize: Local.Theme.font.large
        color: Local.Theme.colors.foreground
        anchors.centerIn: parent
    }

    Process {
        id: switchProcess
        command: ["hyprctl", "switchxkblayout", keyboardName, "next"]
        running: false
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            switchProcess.running = true;
        }
    }
}
