import QtQuick
import Quickshell
import Quickshell.Io
import "." as Local

Item {
    id: audioInputModule
    
    property var devices: []
    property string currentDevice: ""
    property string currentDeviceId: ""
    property int currentVolume: 0
    property bool muted: false
    
    function refreshDevices() {
        devicesProcess.running = false;
        devicesProcess.running = true;
    }
    
    function setDevice(deviceId) {
        setDeviceProcess.command = ["wpctl", "set-default", deviceId];
        setDeviceProcess.running = true;
    }
    
    function setVolume(volume) {
        let vol = Math.max(0, Math.min(100, volume));
        setVolumeProcess.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SOURCE@", (vol / 100).toFixed(2)];
        setVolumeProcess.running = true;
        currentVolume = vol;
    }
    
    function increaseVolume() {
        setVolume(currentVolume + 5);
    }
    
    function decreaseVolume() {
        setVolume(currentVolume - 5);
    }
    
    function toggleMute() {
        muteProcess.command = ["wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle"];
        muteProcess.running = true;
        muted = !muted;
    }
    
    Process {
        id: devicesProcess
        command: ["bash", "-c", "wpctl status | awk '/├─ Sources:/{flag=1} /├─ Filters:/{flag=0} flag && /^[[:space:]│]+[[:space:]]*\\*?[[:space:]]*[0-9]+\\..*\\[vol:/'"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                if (!data || data.trim() === "") return;

                let lines = data.trim().split('\n');
                let newDevices = [];

                for (let line of lines) {
                    if (!line.trim()) continue;

                    let isDefault = line.includes('*');

                    let cleanLine = line.replace(/^[│\s]+/, '');
                    if (isDefault) {
                        cleanLine = cleanLine.replace(/^\*\s*/, '');
                    }

                    let match = cleanLine.match(/^(\d+)\.\s+(.+?)\s+\[vol:\s*([\d.]+)\](?:\s+\[MUTED\])?$/);

                    if (match) {
                        let isMuted = line.includes("[MUTED]");
                        let device = {
                            id: match[1],
                            name: match[2].trim(),
                            volume: match[3] ? Math.round(parseFloat(match[3]) * 100) : 100,
                            muted: isMuted,
                            isDefault: isDefault
                        };

                        newDevices.push(device);

                        if (isDefault) {
                            currentDevice = device.name;
                            currentDeviceId = device.id;
                            currentVolume = device.volume;
                            muted = isMuted;
                        }
                    }
                }

                newDevices.sort((a, b) => {
                    if (a.isDefault && !b.isDefault) return -1;
                    if (!a.isDefault && b.isDefault) return 1;
                    return parseInt(a.id) - parseInt(b.id);
                });

                devices = newDevices;
            }
        }
    }
    
    Process {
        id: setDeviceProcess
        running: false
        
        onExited: {
            refreshDevices();
        }
    }
    
    Process {
        id: setVolumeProcess
        running: false
    }
    
    Process {
        id: muteProcess
        running: false
    }
    
    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: refreshDevices()
    }
    
    Component.onCompleted: {
        refreshDevices();
    }
}