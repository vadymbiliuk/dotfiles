pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: antivirusState

    property bool daemonEnabled: false
    property bool daemonRunning: false
    property bool updaterEnabled: false
    property string lastScanDate: "Never"
    property string virusDefinitionDate: "Unknown"
    property int threatCount: 0
    property bool isScanning: false
    property string scanProgress: ""
    property var scanHistory: []

    function getDisplayText() {
        if (isScanning) {
            return "Scanning...";
        } else if (daemonRunning) {
            return "Protected";
        } else if (daemonEnabled && !daemonRunning) {
            return "Starting...";
        } else {
            return "Disabled";
        }
    }

    function toggleProtection() {
        if (daemonEnabled) {
            stopDaemon();
        } else {
            startDaemon();
        }
    }

    function startDaemon() {
        daemonStartProcess.running = true;
    }

    function stopDaemon() {
        daemonStopProcess.running = true;
    }

    function updateVirusDefinitions() {
        freshclamUpdateProcess.running = true;
    }

    function scanDirectory(path) {
        if (!isScanning) {
            isScanning = true;
            scanProgress = "Initializing scan...";
            scanProcess.command = ["clamscan", "-r", "--bell", path || "/home"];
            scanProcess.running = true;
        }
    }

    function quickScan() {
        scanDirectory("/home");
    }

    function fullScan() {
        scanDirectory("/");
    }

    function updateStatus() {
        daemonStatusProcess.running = false;
        daemonStatusProcess.running = true;
        updaterStatusProcess.running = false;
        updaterStatusProcess.running = true;
    }

    Process {
        id: daemonStatusProcess
        command: ["systemctl", "is-active", "clamav-daemon.service"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim() !== "") {
                    daemonRunning = data.trim() === "active";
                }
            }
        }

        onExited: {
            daemonEnabledProcess.running = true;
        }
    }

    Process {
        id: daemonEnabledProcess
        command: ["systemctl", "is-enabled", "clamav-daemon.service"]
        running: false

        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim() !== "") {
                    let status = data.trim();
                    daemonEnabled = status === "enabled" || status === "static";
                }
            }
        }
    }

    Process {
        id: updaterStatusProcess
        command: ["systemctl", "is-enabled", "clamav-freshclam.timer"]
        running: false

        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim() !== "") {
                    let status = data.trim();
                    updaterEnabled = status === "enabled" || status === "static";
                }
            }
        }
    }

    Process {
        id: daemonStartProcess
        command: ["systemctl", "start", "clamav-daemon.service"]
        running: false

        onExited: {
            statusRefreshTimer.start();
        }
    }

    Process {
        id: daemonStopProcess
        command: ["systemctl", "stop", "clamav-daemon.service"]
        running: false

        onExited: {
            statusRefreshTimer.start();
        }
    }

    Process {
        id: freshclamUpdateProcess
        command: ["sudo", "freshclam"]
        running: false

        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim() !== "") {
                    console.log("FreshClam:", data.trim());
                }
            }
        }

        onExited: {
            virusDefDateProcess.running = true;
        }
    }

    Process {
        id: virusDefDateProcess
        command: ["sigtool", "--info=/var/lib/clamav/daily.cvd"]
        running: false

        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim() !== "") {
                    let lines = data.trim().split('\n');
                    for (let i = 0; i < lines.length; i++) {
                        if (lines[i].startsWith("Build time:")) {
                            virusDefinitionDate = lines[i].substring(12).trim();
                            break;
                        }
                    }
                }
            }
        }
    }

    Process {
        id: scanProcess
        running: false

        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim() !== "") {
                    let lines = data.trim().split('\n');
                    for (let i = 0; i < lines.length; i++) {
                        let line = lines[i].trim();
                        if (line.includes("Scanning ")) {
                            scanProgress = line;
                        } else if (line.includes("Infected files:")) {
                            let match = line.match(/Infected files: (\d+)/);
                            if (match) {
                                threatCount = parseInt(match[1]);
                            }
                        }
                    }
                }
            }
        }

        stderr: SplitParser {
            onRead: data => {
                if (data && data.trim() !== "") {
                    scanProgress = data.trim();
                }
            }
        }

        onExited: function(exitCode, exitStatus) {
            isScanning = false;
            scanProgress = "";
            lastScanDate = new Date().toLocaleDateString();
            
            let result = {
                date: lastScanDate,
                threats: threatCount,
                exitCode: exitCode
            };
            
            let history = scanHistory.slice();
            history.unshift(result);
            if (history.length > 10) {
                history = history.slice(0, 10);
            }
            scanHistory = history;
        }
    }

    Timer {
        id: statusRefreshTimer
        interval: 1000
        running: false
        repeat: false
        onTriggered: {
            updateStatus();
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            updateStatus();
        }
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            virusDefDateProcess.running = true;
        }
    }

    Component.onCompleted: {
        updateStatus();
        virusDefDateProcess.running = true;
        scanHistory = [];
    }
}