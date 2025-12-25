import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Quickshell
import Quickshell.Io
import "." as Local

Item {
    id: wifiModule

    property string status: "Disabled"
    property string connectedNetwork: ""
    property bool radioEnabled: false
    property var availableNetworks: []
    property var cachedNetworks: ({})
    property bool hasScannedOnce: false
    property bool connectionFound: false

    signal connectRequested(string ssid, bool secured)

    function getDisplayText() {
        if (status === "Connected" && connectedNetwork !== "") {
            return connectedNetwork;
        } else if (radioEnabled) {
            return "Enabled";
        } else {
            return "Disabled";
        }
    }

    function toggleWifi() {
        wifiToggleProcess.command = ["nmcli", "radio", "wifi", radioEnabled ? "off" : "on"];
        wifiToggleProcess.running = true;
    }

    function scanNetworks() {
        if (radioEnabled) {
            wifiScanProcess.running = false;
            wifiScanProcess.running = true;
        } else {
            availableNetworks = [];
            cachedNetworks = {};
            hasScannedOnce = false;
        }
    }

    function refreshNetworkList() {
        // Ensure connected network is in the list even without scanning
        if (status === "Connected" && connectedNetwork !== "") {
            updateNetworkCache([]);
        }
        scanNetworks();
    }

    function connectToNetwork(ssid, password) {
        if (password !== "") {
            wifiConnectProcess.command = ["bash", "-c", "nmcli device wifi connect '" + ssid + "' password '" + password + "' || nmcli connection add type wifi con-name '" + ssid + "' ssid '" + ssid + "' wifi-sec.key-mgmt wpa-psk wifi-sec.psk '" + password + "' && nmcli connection up '" + ssid + "'"];
        } else {
            wifiConnectProcess.command = ["nmcli", "device", "wifi", "connect", ssid];
        }
        
        wifiConnectProcess.running = true;
    }

    function updateNetworkCache(newNetworks) {
        let updatedCache = {};

        // Add scanned networks
        for (let i = 0; i < newNetworks.length; i++) {
            let network = newNetworks[i];
            updatedCache[network.ssid] = {
                ssid: network.ssid,
                signal: network.signal,
                security: network.security,
                lastSeen: Date.now()
            };
        }

        // Add connected network if not in scan results
        if (status === "Connected" && connectedNetwork !== "" && !updatedCache[connectedNetwork]) {
            updatedCache[connectedNetwork] = {
                ssid: connectedNetwork,
                signal: 100, // High signal for connected network
                security: true, // Assume secured if we're connected
                lastSeen: Date.now()
            };
        }

        // Keep recently seen networks
        for (let ssid in cachedNetworks) {
            if (!updatedCache[ssid]) {
                let timeSinceLastSeen = Date.now() - cachedNetworks[ssid].lastSeen;
                if (timeSinceLastSeen < 60000) {
                    updatedCache[ssid] = cachedNetworks[ssid];
                }
            }
        }

        cachedNetworks = updatedCache;

        let networksList = [];
        for (let ssid in cachedNetworks) {
            networksList.push(cachedNetworks[ssid]);
        }

        networksList.sort((a, b) => b.signal - a.signal);
        availableNetworks = networksList;
        hasScannedOnce = true;
    }

    Process {
        id: wifiRadioProcess
        command: ["nmcli", "radio", "wifi"]
        running: true

        stdout: SplitParser {
            onRead: line => {
                if (line && line.trim() !== "") {
                    radioEnabled = line.trim() === "enabled";
                    wifiDeviceProcess.running = true;
                }
            }
        }
    }

    Process {
        id: wifiDeviceProcess
        command: ["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION", "device", "status"]
        running: false

        onStarted: {
            connectionFound = false;
        }

        stdout: SplitParser {
            onRead: line => {
                if (line && line.trim() !== "" && !connectionFound) {
                    let parts = line.trim().split(':');
                    if (parts.length >= 3) {
                        if ((parts[0] === "wifi" || parts[0] === "802-11-wireless") && parts[1] === "connected" && parts[2] !== "--" && parts[2] !== "") {
                            status = "Connected";
                            connectedNetwork = parts[2];
                            connectionFound = true;
                        }
                    }
                }
            }
        }

        onExited: {
            if (!connectionFound) {
                if (radioEnabled) {
                    status = "Enabled";
                    connectedNetwork = "";
                } else {
                    status = "Disabled";
                    connectedNetwork = "";
                }
            }
            // Update cache to include connected network if any
            if (hasScannedOnce) {
                updateNetworkCache([]);
            }
        }
    }

    Process {
        id: wifiToggleProcess
        running: false

        onExited: {
            wifiRadioProcess.running = false;
            wifiRadioProcess.running = true;
        }
    }

    Process {
        id: wifiConnectProcess
        running: false

        onExited: function(exitCode, exitStatus) {
            if (exitCode === 0) {
                wifiStatusRefreshTimer.start();
            }
            
            scanNetworks();
        }
    }

    Process {
        id: wifiScanProcess
        command: ["nmcli", "-t", "-f", "SSID,SIGNAL,SECURITY", "device", "wifi", "list"]
        running: false

        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim() !== "") {
                    let networks = [];
                    let lines = data.trim().split('\n');
                    for (let i = 0; i < lines.length; i++) {
                        let parts = lines[i].split(':');
                        if (parts.length >= 3 && parts[0] !== "" && parts[0] !== "--" && parts[0] !== "SSID") {
                            networks.push({
                                ssid: parts[0],
                                signal: parseInt(parts[1]) || 0,
                                security: parts[2] !== ""
                            });
                        }
                    }
                    updateNetworkCache(networks);
                }
            }
        }
    }

    Timer {
        id: wifiStatusRefreshTimer
        interval: 2000
        running: false
        repeat: false
        onTriggered: {
            wifiRadioProcess.running = false;
            wifiRadioProcess.running = true;
        }
    }

    Timer {
        interval: 3000
        running: wifiModule.parent && (wifiModule.parent.isVisible ?? true)
        repeat: true
        onTriggered: {
            wifiRadioProcess.running = false;
            wifiRadioProcess.running = true;
        }
    }

    Timer {
        interval: 5000
        running: wifiModule.parent && (wifiModule.parent.isVisible ?? true) && (wifiModule.parent.currentView === "wifi" || !wifiModule.parent.currentView)
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            refreshNetworkList();
        }
    }

    Timer {
        interval: 15000
        running: wifiModule.parent && (wifiModule.parent.isVisible ?? true) && radioEnabled
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!wifiModule.parent || !wifiModule.parent.currentView || wifiModule.parent.currentView !== "wifi") {
                refreshNetworkList();
            }
        }
    }
}