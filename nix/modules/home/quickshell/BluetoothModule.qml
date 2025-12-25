import QtQuick
import "." as Local

Item {
    id: bluetoothModule

    property string status: Local.BluetoothState.enabled ? (Local.BluetoothState.connectedDevices.length > 0 ? "Connected" : "Enabled") : "Disabled"
    property bool enabled: Local.BluetoothState.enabled
    property var connectedDevices: Local.BluetoothState.connectedDevices
    property var availableDevices: Local.BluetoothState.availableDevices
    property bool hasScannedOnce: Local.BluetoothState.hasScannedOnce

    function getDisplayText() {
        return Local.BluetoothState.getDisplayText();
    }

    function toggleBluetooth() {
        Local.BluetoothState.toggleBluetooth();
    }

    function scanDevices() {
        Local.BluetoothState.scanDevices();
    }

    function refreshDeviceList() {
        Local.BluetoothState.refreshDeviceList();
    }

    function connectToDevice(address, name) {
        Local.BluetoothState.connectToDevice(address, name);
    }

    function disconnectDevice(address) {
        Local.BluetoothState.disconnectDevice(address);
    }
}