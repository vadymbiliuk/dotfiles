pragma Singleton
import QtQuick

QtObject {
    readonly property QtObject colors: QtObject {
        readonly property color background: "#0a0a0a"
        readonly property color foreground: "#deeeed"
        readonly property color accent: "#7788aa"
        readonly property color orange: "#ffaa88"
        readonly property color green: "#789978"
        readonly property color red: "#d70000"
        readonly property color blue: "#7788aa"

        readonly property color gray0: "#000000"
        readonly property color gray1: "#080808"
        readonly property color gray2: "#191919"
        readonly property color gray3: "#2a2a2a"
        readonly property color gray4: "#444444"
        readonly property color gray5: "#555555"
        readonly property color gray6: "#7a7a7a"
        readonly property color gray7: "#aaaaaa"
        readonly property color gray8: "#cccccc"
        readonly property color gray9: "#dddddd"

        readonly property color workspaceActive: foreground
        readonly property color workspaceOccupied: gray6
        readonly property color workspaceEmpty: gray4

        readonly property color transparent: "transparent"
    }

    readonly property QtObject spacing: QtObject {
        readonly property int tiny: 2
        readonly property int small: 5
        readonly property int normal: 10
        readonly property int large: 15
        readonly property int huge: 20
    }

    readonly property QtObject radius: QtObject {
        readonly property int small: 6
        readonly property int normal: 10
        readonly property int large: 15
        readonly property int full: 999
    }

    readonly property QtObject border: QtObject {
        readonly property int thin: 1
        readonly property int normal: 2
        readonly property int thick: 3
        readonly property color color: Qt.rgba(0.165, 0.165, 0.165, 0.4)
    }

    readonly property color panelBackground: Qt.rgba(0.04, 0.04, 0.04, 0.6)

    readonly property QtObject size: QtObject {
        readonly property int barHeight: 40
        readonly property int workspaceWidth: 12
        readonly property int workspaceActiveWidth: 30
        readonly property int workspaceHeight: 12
    }

    readonly property QtObject font: QtObject {
        readonly property string family: "BerkeleyMonoMinazuki Nerd Font Mono"
        readonly property int small: 12
        readonly property int normal: 14
        readonly property int large: 16
        readonly property int huge: 20
    }

    readonly property string osIcon: ""
}
