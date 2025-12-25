pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    property int volume: 0
    property bool muted: false
    property int brightness: 0

    property Process volumeProcess: Process {
        command: ["pamixer", "--get-volume"]
        onExited: {
            console.log("Volume process exited:", exitCode, "output:", stdout.trim());
            if (exitCode === 0) {
                var newVolume = parseInt(stdout.trim());
                console.log("Current volume:", volume, "New volume:", newVolume);
                if (newVolume !== volume) {
                    volume = newVolume;
                    checkVolumeChange();
                }
            }
        }
    }

    property Process muteProcess: Process {
        command: ["pamixer", "--get-mute"]
        onExited: {
            if (exitCode === 0) {
                var newMuted = stdout.trim() === "true";
                if (newMuted !== muted) {
                    muted = newMuted;
                    checkVolumeChange();
                }
            }
        }
    }

    property Process brightnessProcess: Process {
        command: ["brightnessctl", "get"]
        onExited: {
            if (exitCode === 0) {
                var current = parseInt(stdout.trim());
                brightnessMaxProcess.start();
            }
        }
    }

    property Process brightnessMaxProcess: Process {
        command: ["brightnessctl", "max"]
        onExited: {
            if (exitCode === 0) {
                var max = parseInt(stdout.trim());
                var current = parseInt(brightnessProcess.stdout.trim());
                var newBrightness = Math.round((current / max) * 100);
                if (newBrightness !== brightness) {
                    brightness = newBrightness;
                    Local.OsdService.showBrightness(brightness);
                }
            }
        }
    }

    property Timer pollTimer: Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            console.log("SystemMonitor: Polling for changes");
            if (!volumeProcess.running)
                volumeProcess.start();
            if (!muteProcess.running)
                muteProcess.start();
            if (!brightnessProcess.running)
                brightnessProcess.start();
        }
    }

    function checkVolumeChange() {
        Local.OsdService.showVolume(volume, muted);
    }

    Component.onCompleted: {
        pollTimer.start();
    }
}
