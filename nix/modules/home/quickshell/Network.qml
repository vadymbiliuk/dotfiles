import QtQuick
import Quickshell
import Quickshell.Io
import "." as Local

Rectangle {
    id: network

    signal requestViewSwitch(string view)

    width: row.implicitWidth
    height: Local.Theme.size.barHeight - Local.Theme.spacing.normal
    radius: Local.Theme.radius.small
    color: Local.Theme.colors.transparent

    Local.WiFiModule {
        id: wifiModule
    }

    Local.EthernetModule {
        id: ethernetModule
    }

    function getNetworkIcon() {
        if (!wifiModule.radioEnabled && !ethernetModule.connected) {
            return "public_off";
        }
        
        if (ethernetModule.connected && wifiModule.connectedNetwork !== "") {
            return "lan";
        }
        
        if (wifiModule.connectedNetwork !== "" && !ethernetModule.connected) {
            return "wifi";
        }
        
        if (ethernetModule.connected && wifiModule.connectedNetwork === "") {
            return "lan";
        }
        
        if (wifiModule.radioEnabled || ethernetModule.status !== "Disconnected") {
            return "wifi";
        }
        
        return "public_off";
    }

    function getNetworkColor() {
        if (!wifiModule.radioEnabled && !ethernetModule.connected) {
            return Local.Theme.colors.gray6;
        }
        
        if (wifiModule.connectedNetwork !== "" || ethernetModule.connected) {
            return Local.Theme.colors.foreground;
        }
        
        return Local.Theme.colors.gray6;
    }

    function getViewToSwitch() {
        let icon = getNetworkIcon();
        if (icon === "lan") {
            return "ethernet";
        } else {
            return "wifi";
        }
    }

    Row {
        id: row
        anchors.centerIn: parent

        Local.MaterialSymbol {
            icon: network.getNetworkIcon()
            iconSize: Local.Theme.font.huge
            color: network.getNetworkColor()
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            network.requestViewSwitch(network.getViewToSwitch());
        }
    }
}