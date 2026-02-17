pragma Singleton
import QtQuick
import QtCore
import Quickshell
import Quickshell.Io

Singleton {
    id: dndState
    
    property bool enabled: configAdapter.dndEnabled
    property string profile: configAdapter.dndProfile
    property string configPath: StandardPaths.writableLocation(StandardPaths.HomeLocation) + "/.config/quickshell/dnd-config.json"
    
    property Timer writeTimer: Timer {
        id: writeTimer
        interval: 100
        repeat: false
        onTriggered: {
            configFileView.writeAdapter();
        }
    }
    
    property FileView configFileView: FileView {
        id: configFileView
        path: dndState.configPath
        watchChanges: true
        
        onLoaded: {
            updateNotificationSounds();
        }
        
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                writeAdapter();
            }
        }
        
        JsonAdapter {
            id: configAdapter
            property bool dndEnabled: false
            property string dndProfile: "silent"
        }
    }
    
    function toggle() {
        configAdapter.dndEnabled = !configAdapter.dndEnabled;
        writeTimer.restart();
        updateNotificationSounds();
    }
    
    function setProfile(newProfile) {
        configAdapter.dndProfile = newProfile;
        writeTimer.restart();
        updateNotificationSounds();
    }
    
    function updateNotificationSounds() {
        soundToggleProcess.command = ["/home/zooki/.config/nix/modules/home/quickshell/toggle-notification-sounds.sh", 
                                       configAdapter.dndEnabled ? "off" : "on",
                                       configAdapter.dndProfile];
        soundToggleProcess.running = true;
    }
    
    property Process soundToggleProcess: Process {
        id: soundToggleProcess
        running: false
    }
    
    property Process audioMonitorProcess: Process {
        id: audioMonitorProcess
        command: ["/home/zooki/.config/nix/modules/home/quickshell/dnd-audio-monitor.sh"]
        running: true
    }
}