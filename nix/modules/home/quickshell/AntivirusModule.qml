import QtQuick
import "." as Local

Item {
    id: antivirusModule

    property string status: Local.AntivirusState.getDisplayText()
    property bool enabled: Local.AntivirusState.daemonRunning
    property bool daemonEnabled: Local.AntivirusState.daemonEnabled
    property bool updaterEnabled: Local.AntivirusState.updaterEnabled
    property string lastScanDate: Local.AntivirusState.lastScanDate
    property string virusDefinitionDate: Local.AntivirusState.virusDefinitionDate
    property int threatCount: Local.AntivirusState.threatCount
    property bool isScanning: Local.AntivirusState.isScanning
    property string scanProgress: Local.AntivirusState.scanProgress
    property var scanHistory: Local.AntivirusState.scanHistory

    function getDisplayText() {
        return Local.AntivirusState.getDisplayText();
    }

    function toggleProtection() {
        Local.AntivirusState.toggleProtection();
    }

    function startDaemon() {
        Local.AntivirusState.startDaemon();
    }

    function stopDaemon() {
        Local.AntivirusState.stopDaemon();
    }

    function updateVirusDefinitions() {
        Local.AntivirusState.updateVirusDefinitions();
    }

    function quickScan() {
        Local.AntivirusState.quickScan();
    }

    function fullScan() {
        Local.AntivirusState.fullScan();
    }

    function scanDirectory(path) {
        Local.AntivirusState.scanDirectory(path);
    }
}