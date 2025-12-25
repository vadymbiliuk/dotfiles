import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "." as Local

Item {
    id: ethernetModule

    property string status: "Disconnected"
    property string connectionName: ""
    property string ipAddress: ""
    property string subnetMask: ""
    property string gateway: ""
    property string dnsServers: ""
    property string macAddress: ""
    property string linkSpeed: ""
    property string duplex: ""
    property string mtu: ""
    property bool connected: false

    function getDisplayText() {
        if (connected && connectionName !== "") {
            return "Connected " + (linkSpeed !== "" ? linkSpeed : "");
        } else {
            return "Disconnected";
        }
    }

    function refreshNetworkInfo() {
        ethernetStatusProcess.running = false;
        ethernetStatusProcess.running = true;
    }

    property bool ethernetFound: false

    Process {
        id: ethernetStatusProcess
        command: ["bash", "-c", "nmcli -t -f TYPE,STATE,CONNECTION,DEVICE device status"]
        running: true

        onStarted: {
            ethernetFound = false;
        }

        stdout: SplitParser {
            onRead: line => {
                if (line && line.trim() !== "" && !ethernetFound) {
                    let parts = line.trim().split(':');
                    
                    if (parts.length >= 4 && (parts[0] === "ethernet" || parts[0] === "802-3-ethernet")) {
                        if (parts[1] === "connected" && parts[2] !== "--" && parts[2] !== "") {
                            status = "Connected";
                            connectionName = parts[2];
                            connected = true;
                            ethernetFound = true;
                            ethernetDetailsProcess.command = ["nmcli", "-t", "-f", "IP4.ADDRESS,IP4.GATEWAY,IP4.DNS", "connection", "show", connectionName];
                            ethernetDetailsProcess.running = true;
                            ethernetInterfaceProcess.command = ["bash", "-c", "nmcli -t -f GENERAL.HWADDR,WIRED-PROPERTIES.SPEED,WIRED-PROPERTIES.DUPLEX device show " + parts[3]];
                            ethernetInterfaceProcess.running = true;
                        }
                    }
                }
            }
        }

        onExited: {
            if (!ethernetFound) {
                status = "Disconnected";
                connectionName = "";
                connected = false;
                clearNetworkInfo();
            }
        }
    }

    Process {
        id: ethernetDetailsProcess
        running: false

        onStarted: {
            resetDetailedInfo();
        }

        stdout: SplitParser {
            onRead: line => {
                if (line && line.trim() !== "") {
                    let lines = line.trim().split('\n');
                    for (let i = 0; i < lines.length; i++) {
                        let parts = lines[i].split(':');
                        if (parts.length >= 2) {
                            if (parts[0].startsWith("IP4.ADDRESS")) {
                                let ipInfo = parts[1].split('/');
                                if (ipInfo.length >= 2) {
                                    ipAddress = ipInfo[0];
                                    let cidr = parseInt(ipInfo[1]);
                                    subnetMask = cidrToSubnetMask(cidr);
                                }
                            } else if (parts[0] === "IP4.GATEWAY") {
                                gateway = parts[1];
                            } else if (parts[0].startsWith("IP4.DNS")) {
                                if (dnsServers === "") {
                                    dnsServers = parts[1];
                                } else {
                                    dnsServers += ", " + parts[1];
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Process {
        id: ethernetInterfaceProcess
        running: false

        onStarted: {
            macAddress = "";
            linkSpeed = "";
            duplex = "";
        }

        stdout: SplitParser {
            onRead: line => {
                if (line && line.trim() !== "") {
                    let lines = line.trim().split('\n');
                    for (let i = 0; i < lines.length; i++) {
                        let parts = lines[i].split(':');
                        if (parts.length >= 2) {
                            if (parts[0] === "GENERAL.HWADDR") {
                                macAddress = parts[1];
                            } else if (parts[0] === "WIRED-PROPERTIES.SPEED") {
                                linkSpeed = parts[1] + " Mb/s";
                            } else if (parts[0] === "WIRED-PROPERTIES.DUPLEX") {
                                duplex = parts[1];
                            }
                        }
                    }
                    // Get MTU
                    ethernetMtuProcess.running = true;
                }
            }
        }
    }

    Process {
        id: ethernetMtuProcess
        command: ["bash", "-c", "ip link show | grep -A1 'state UP' | grep mtu | head -1 | sed 's/.*mtu \\([0-9]*\\).*/\\1/'"]
        running: false

        onStarted: {
            mtu = "";
        }

        stdout: SplitParser {
            onRead: line => {
                if (line && line.trim() !== "") {
                    mtu = line.trim();
                }
            }
        }
    }

    function clearNetworkInfo() {
        ipAddress = "";
        subnetMask = "";
        gateway = "";
        dnsServers = "";
        macAddress = "";
        linkSpeed = "";
        duplex = "";
        mtu = "";
    }

    function resetDetailedInfo() {
        clearNetworkInfo();
    }

    function cidrToSubnetMask(cidr) {
        let mask = [0, 0, 0, 0];
        for (let i = 0; i < cidr; i++) {
            mask[Math.floor(i / 8)] |= 1 << (7 - (i % 8));
        }
        return mask.join('.');
    }

    Timer {
        interval: 5000
        running: ethernetModule.parent && (ethernetModule.parent.isVisible ?? true)
        repeat: true
        onTriggered: {
            refreshNetworkInfo();
        }
    }

    Timer {
        interval: 10000
        running: ethernetModule.parent && (ethernetModule.parent.isVisible ?? true) && (ethernetModule.parent.currentView === "ethernet" || !ethernetModule.parent.currentView)
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            refreshNetworkInfo();
        }
    }
}