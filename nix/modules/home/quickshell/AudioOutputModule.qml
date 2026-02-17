import QtQuick
import Quickshell
import Quickshell.Io
import "." as Local

Item {
    id: audioOutputModule
    
    property var devices: []
    property string currentDevice: ""
    property string currentDeviceId: ""
    property int currentVolume: 0
    
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
        setVolumeProcess.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", (vol / 100).toFixed(2)];
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
        muteProcess.command = ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"];
        muteProcess.running = true;
    }
    
    Process {
        id: devicesProcess
        command: ["bash", "-c", "wpctl status | awk '/├─ Sinks:/{flag=1} /├─ Sources:/{flag=0} flag && /^[[:space:]│]+[[:space:]]*\\*?[[:space:]]*[0-9]+\\..*\\[vol:/'"]
        running: true
        
        stdout: SplitParser {
            onRead: data => {
                if (!data || data.trim() === "") return;
                
                let lines = data.trim().split('\n');
                let newDevices = [];
                
                for (let line of lines) {
                    // Skip empty lines and the Sources: line
                    if (!line.trim() || line.includes('Sources:')) continue;
                    
                    // Check if this is the default device (has * before the number)
                    let isDefault = line.includes('*');
                    
                    // Remove leading pipe and spaces, preserve the rest
                    let cleanLine = line.replace(/^[│\s]+/, '');
                    // Remove the asterisk if present
                    if (isDefault) {
                        cleanLine = cleanLine.replace(/^\*\s*/, '');
                    }
                    
                    // Parse the device info: "107. Audeze Maxwell Dongle Analog Stereo [vol: 0.84]"
                    let match = cleanLine.match(/^(\d+)\.\s+(.+?)\s+\[vol:\s*([\d.]+)\]$/);
                    
                    if (match) {
                        let device = {
                            id: match[1],
                            name: match[2].trim(),
                            volume: match[3] ? Math.round(parseFloat(match[3]) * 100) : 50,
                            isDefault: isDefault
                        };
                        
                        newDevices.push(device);
                        
                        if (isDefault) {
                            currentDevice = device.name;
                            currentDeviceId = device.id;
                            currentVolume = device.volume;
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