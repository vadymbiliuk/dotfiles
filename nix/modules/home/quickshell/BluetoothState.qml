pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: bluetoothState
    
    property bool enabled: false
    property var connectedDevices: []
    property var availableDevices: []
    property var cachedDevices: ({})
    property bool hasScannedOnce: false
    
    signal connectRequested(string address, string name)
    
    function getDisplayText() {
        if (connectedDevices.length > 0) {
            return connectedDevices.length + " device" + (connectedDevices.length > 1 ? "s" : "") + " connected";
        } else if (enabled) {
            return "Enabled";
        } else {
            return "Disabled";
        }
    }
    
    function toggleBluetooth() {
        bluetoothToggleProcess.command = ["bluetoothctl", "power", enabled ? "off" : "on"];
        bluetoothToggleProcess.running = true;
    }
    
    function scanDevices() {
        if (enabled) {
            bluetoothScanStartProcess.running = true;
            bluetoothScanProcess.running = false;
            bluetoothScanProcess.running = true;
        } else {
            availableDevices = [];
            cachedDevices = {};
            hasScannedOnce = false;
        }
    }
    
    function refreshDeviceList() {
        updateDeviceCache([]);
        scanDevices();
    }
    
    function connectToDevice(address, name) {
        bluetoothConnectProcess.command = ["bluetoothctl", "connect", address];
        bluetoothConnectProcess.running = true;
    }
    
    function disconnectDevice(address) {
        bluetoothDisconnectProcess.command = ["bluetoothctl", "disconnect", address];
        bluetoothDisconnectProcess.running = true;
    }
    
    function updateDeviceCache(newDevices) {
        let updatedCache = {};

        for (let i = 0; i < newDevices.length; i++) {
            let device = newDevices[i];
            updatedCache[device.address] = {
                address: device.address,
                name: device.name,
                connected: device.connected,
                paired: device.paired,
                lastSeen: Date.now()
            };
        }

        for (let i = 0; i < connectedDevices.length; i++) {
            let device = connectedDevices[i];
            if (!updatedCache[device.address]) {
                updatedCache[device.address] = {
                    address: device.address,
                    name: device.name,
                    connected: true,
                    paired: true,
                    lastSeen: Date.now()
                };
            }
        }

        for (let address in cachedDevices) {
            if (!updatedCache[address]) {
                let timeSinceLastSeen = Date.now() - cachedDevices[address].lastSeen;
                if (timeSinceLastSeen < 300000) {
                    updatedCache[address] = cachedDevices[address];
                }
            }
        }

        cachedDevices = updatedCache;

        let devicesList = [];
        for (let address in cachedDevices) {
            devicesList.push(cachedDevices[address]);
        }

        devicesList.sort((a, b) => {
            if (a.connected !== b.connected) {
                return b.connected - a.connected;
            }
            return a.name.localeCompare(b.name);
        });
        
        availableDevices = devicesList;
        hasScannedOnce = true;
    }

    Process {
        id: bluetoothStatusProcess
        command: ["bluetoothctl", "show"]
        running: true

        stdout: SplitParser {
            onRead: line => {
                if (line && line.trim() !== "") {
                    if (line.includes("Powered: yes")) {
                        enabled = true;
                        bluetoothConnectedProcess.running = true;
                    } else if (line.includes("Powered: no")) {
                        enabled = false;
                        connectedDevices = [];
                    }
                }
            }
        }
    }

    Process {
        id: bluetoothConnectedProcess
        command: ["bash", "-c", "bluetoothctl devices Connected"]
        running: false

        stdout: SplitParser {
            onRead: line => {
                if (line && line.trim() !== "") {
                    let devices = [];
                    let lines = line.trim().split('\n');
                    for (let i = 0; i < lines.length; i++) {
                        let parts = lines[i].trim().split(' ');
                        if (parts.length >= 3 && parts[0] === "Device") {
                            let address = parts[1];
                            let name = parts.slice(2).join(' ');
                            devices.push({
                                address: address,
                                name: name
                            });
                        }
                    }
                    connectedDevices = devices;
                }
            }
        }

        onExited: {
            if (hasScannedOnce) {
                updateDeviceCache([]);
            }
        }
    }

    Process {
        id: bluetoothToggleProcess
        running: false

        onExited: {
            bluetoothStatusProcess.running = false;
            bluetoothStatusProcess.running = true;
        }
    }

    Process {
        id: bluetoothScanStartProcess
        command: ["bluetoothctl", "scan", "on"]
        running: false
    }

    Process {
        id: bluetoothScanProcess
        command: ["bash", "-c", "bluetoothctl devices | head -20"]
        running: false

        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim() !== "") {
                    let devices = [];
                    let lines = data.trim().split('\n');
                    for (let i = 0; i < lines.length; i++) {
                        let parts = lines[i].trim().split(' ');
                        if (parts.length >= 3 && parts[0] === "Device") {
                            let address = parts[1];
                            let name = parts.slice(2).join(' ');
                            let isConnected = connectedDevices.some(d => d.address === address);
                            devices.push({
                                address: address,
                                name: name,
                                connected: isConnected,
                                paired: true
                            });
                        }
                    }
                    updateDeviceCache(devices);
                }
            }
        }
    }

    Process {
        id: bluetoothConnectProcess
        running: false

        onExited: function(exitCode, exitStatus) {
            if (exitCode === 0) {
                bluetoothStatusRefreshTimer.start();
            }
            refreshDeviceList();
        }
    }

    Process {
        id: bluetoothDisconnectProcess
        running: false

        onExited: function(exitCode, exitStatus) {
            bluetoothStatusRefreshTimer.start();
            refreshDeviceList();
        }
    }

    Timer {
        id: bluetoothStatusRefreshTimer
        interval: 2000
        running: false
        repeat: false
        onTriggered: {
            bluetoothStatusProcess.running = false;
            bluetoothStatusProcess.running = true;
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: {
            bluetoothStatusProcess.running = false;
            bluetoothStatusProcess.running = true;
        }
    }
}