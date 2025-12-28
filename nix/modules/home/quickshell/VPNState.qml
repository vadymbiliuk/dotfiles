pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Qt.labs.settings 1.0

Singleton {
    id: vpnState

    property string status: "Disconnected"
    property bool connected: false
    property string currentServer: ""
    property string currentCountry: ""
    property string currentIP: ""
    property string currentProtocol: ""
    property var availableCountries: []
    property var recentConnections: settings.recentVPNConnections || []
    property bool hasScannedOnce: false
    property bool isConnecting: false
    property bool isDisconnecting: false
    property bool isLoggedIn: false

    Settings {
        id: settings
        property var recentVPNConnections: []
    }

    function getDisplayText() {
        if (isDisconnecting) {
            return "Disconnecting...";
        } else if (connected && currentCountry !== "") {
            return currentCountry;
        } else if (isConnecting) {
            return "Connecting...";
        } else {
            return "Disconnected";
        }
    }

    function toggleVPN() {
        if (connected) {
            disconnect();
        } else {
            quickConnect();
        }
    }

    function quickConnect() {
        if (!isConnecting) {
            isConnecting = true;
            status = "Connecting...";
            vpnConnectProcess.command = ["nordvpn", "connect"];
            vpnConnectProcess.running = true;
        }
    }

    function connectToCountry(country) {
        if (!isConnecting) {
            isConnecting = true;
            status = "Connecting to " + country + "...";
            
            let recent = recentConnections.filter(c => c !== country);
            recent.unshift(country);
            if (recent.length > 5) {
                recent = recent.slice(0, 5);
            }
            recentConnections = recent;
            settings.recentVPNConnections = recent;
            
            let countryForCommand = country.replace(/ /g, "_");
            vpnConnectProcess.command = ["nordvpn", "connect", countryForCommand];
            vpnConnectProcess.running = true;
        }
    }

    function disconnect() {
        isDisconnecting = true;
        status = "Disconnecting...";
        vpnDisconnectProcess.running = true;
    }

    function refreshCountryList() {
        vpnCountriesProcess.running = false;
        vpnCountriesProcess.running = true;
    }

    function updateStatus() {
        vpnStatusProcess.running = false;
        vpnStatusProcess.running = true;
    }

    function checkLoginStatus() {
        vpnAccountProcess.running = false;
        vpnAccountProcess.running = true;
    }

    Process {
        id: vpnStatusProcess
        command: ["nordvpn", "status"]
        running: true

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                if (data && data.trim() !== "") {
                    let lines = data.trim().split('\n');
                    
                    for (let i = 0; i < lines.length; i++) {
                        let line = lines[i].trim();
                        if (line.startsWith("Status:")) {
                            let statusText = line.substring(7).trim();
                            status = statusText;
                            let newConnected = statusText.toLowerCase() === "connected";
                            
                            if (!newConnected) {
                                currentServer = "";
                                currentCountry = "";
                                currentIP = "";
                                currentProtocol = "";
                            }
                            
                            connected = newConnected;
                            isConnecting = false;
                            isDisconnecting = false;
                        } else if (line.startsWith("Server:")) {
                            currentServer = line.substring(7).trim();
                        } else if (line.startsWith("Country:")) {
                            currentCountry = line.substring(8).trim();
                            if (connected && currentCountry !== "" && !recentConnections.includes(currentCountry)) {
                                let recent = recentConnections.slice();
                                recent.unshift(currentCountry);
                                if (recent.length > 5) {
                                    recent = recent.slice(0, 5);
                                }
                                recentConnections = recent;
                                settings.recentVPNConnections = recent;
                            }
                        } else if (line.startsWith("IP:")) {
                            currentIP = line.substring(3).trim();
                        } else if (line.startsWith("Current technology:") || line.startsWith("Current protocol:")) {
                            currentProtocol = line.substring(line.indexOf(':') + 1).trim();
                        }
                    }
                    
                }
            }
        }
    }

    Process {
        id: vpnAccountProcess
        command: ["nordvpn", "account"]
        running: false

        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim() !== "") {
                    isLoggedIn = !data.includes("not logged in") && !data.includes("Please login");
                }
            }
        }

        stderr: SplitParser {
            onRead: data => {
                if (data && data.trim() !== "") {
                    isLoggedIn = false;
                }
            }
        }
    }

    Process {
        id: vpnConnectProcess
        running: false

        onExited: function(exitCode, exitStatus) {
            isConnecting = false;
            statusRefreshTimer.interval = 500;
            statusRefreshTimer.start();
        }
    }

    Process {
        id: vpnDisconnectProcess
        command: ["nordvpn", "disconnect"]
        running: false

        onExited: {
            isDisconnecting = false;
            statusRefreshTimer.interval = 500;
            statusRefreshTimer.start();
        }
    }

    Process {
        id: vpnCountriesProcess
        command: ["nordvpn", "countries"]
        running: false

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                if (data && data.trim() !== "") {
                    let countries = data.trim()
                        .split('\n')
                        .map(country => country.trim())
                        .filter(country => country !== "" && !country.startsWith("-") && country.length > 0)
                        .map(country => country.replace(/_/g, " "));
                    
                    let uniqueCountries = [...new Set(countries)].sort();
                    
                    availableCountries = uniqueCountries;
                    hasScannedOnce = true;
                }
            }
        }
    }

    Timer {
        id: statusRefreshTimer
        interval: 500
        running: false
        repeat: false
        onTriggered: {
            updateStatus();
            interval = 2000;
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            updateStatus();
        }
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            checkLoginStatus();
            if (!hasScannedOnce) {
                refreshCountryList();
            }
        }
    }

    Component.onCompleted: {
        updateStatus();
        checkLoginStatus();
        refreshCountryList();
        
        recentConnections = [];
    }
}