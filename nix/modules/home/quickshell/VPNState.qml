pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: vpnState

    property string status: "Disconnected"
    property bool connected: false
    property string currentServer: ""
    property string currentCountry: ""
    property string currentIP: ""
    property string currentProtocol: ""
    property var availableCountries: []
    property var recentConnections: []
    property bool hasScannedOnce: false
    property bool isConnecting: false
    property bool isLoggedIn: false

    function getDisplayText() {
        if (connected && currentCountry !== "") {
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
            vpnConnectProcess.command = ["nordvpn", "connect"];
            vpnConnectProcess.running = true;
        }
    }

    function connectToCountry(country) {
        if (!isConnecting) {
            isConnecting = true;
            
            let recent = recentConnections.filter(c => c !== country);
            recent.unshift(country);
            if (recent.length > 5) {
                recent = recent.slice(0, 5);
            }
            recentConnections = recent;
            
            vpnConnectProcess.command = ["nordvpn", "connect", country];
            vpnConnectProcess.running = true;
        }
    }

    function disconnect() {
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
            onRead: data => {
                if (data && data.trim() !== "") {
                    let lines = data.trim().split('\n');
                    connected = false;
                    currentServer = "";
                    currentCountry = "";
                    currentIP = "";
                    currentProtocol = "";
                    
                    for (let i = 0; i < lines.length; i++) {
                        let line = lines[i];
                        if (line.startsWith("Status:")) {
                            let statusText = line.substring(7).trim();
                            status = statusText;
                            connected = statusText === "Connected";
                            isConnecting = false;
                        } else if (line.startsWith("Server:")) {
                            currentServer = line.substring(7).trim();
                        } else if (line.startsWith("Country:")) {
                            currentCountry = line.substring(8).trim();
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
            statusRefreshTimer.start();
        }
    }

    Process {
        id: vpnDisconnectProcess
        command: ["nordvpn", "disconnect"]
        running: false

        onExited: {
            statusRefreshTimer.start();
        }
    }

    Process {
        id: vpnCountriesProcess
        command: ["nordvpn", "countries"]
        running: false

        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim() !== "") {
                    let countries = data.trim().split('\n')
                        .map(line => line.trim())
                        .filter(line => line !== "" && !line.startsWith("-"))
                        .map(country => country.replace(/_/g, " "));
                    
                    availableCountries = countries;
                    hasScannedOnce = true;
                }
            }
        }
    }

    Timer {
        id: statusRefreshTimer
        interval: 2000
        running: false
        repeat: false
        onTriggered: {
            updateStatus();
        }
    }

    Timer {
        interval: 5000
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
        
        recentConnections = ["United States", "United Kingdom", "Germany", "Netherlands", "Canada"];
    }
}