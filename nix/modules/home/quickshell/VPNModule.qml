import QtQuick
import "." as Local

Item {
    id: vpnModule

    property string status: Local.VPNState.status
    property bool enabled: Local.VPNState.connected
    property string currentServer: Local.VPNState.currentServer
    property string currentCountry: Local.VPNState.currentCountry
    property var availableCountries: Local.VPNState.availableCountries
    property var recentConnections: Local.VPNState.recentConnections
    property bool hasScannedOnce: Local.VPNState.hasScannedOnce

    function getDisplayText() {
        return Local.VPNState.getDisplayText();
    }

    function toggleVPN() {
        Local.VPNState.toggleVPN();
    }

    function connectToCountry(country) {
        Local.VPNState.connectToCountry(country);
    }

    function disconnect() {
        Local.VPNState.disconnect();
    }

    function refreshCountryList() {
        Local.VPNState.refreshCountryList();
    }

    function quickConnect() {
        Local.VPNState.quickConnect();
    }
}