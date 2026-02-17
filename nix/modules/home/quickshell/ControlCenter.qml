import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets
import "." as Local

Item {
    id: controlCenter

    property bool isVisible: false
    property string currentView: "main"
    property bool showPasswordDialog: false
    property string selectedNetwork: ""
    property bool selectedNetworkSecurity: false
    property string networkPassword: ""
    
    Local.WiFiModule {
        id: wifiModule
    }

    Local.BluetoothModule {
        id: bluetoothModule
    }

    Local.EthernetModule {
        id: ethernetModule
    }

    Local.DNDModule {
        id: dndModule
    }

    Local.VPNModule {
        id: vpnModule
    }

    Local.AntivirusModule {
        id: antivirusModule
    }
    
    Local.AudioOutputModule {
        id: audioOutputModule
    }
    
    Local.AudioInputModule {
        id: audioInputModule  
    }

    Process {
        id: clipboardProcess
        running: false
    }
    



    property var controlsData: [
        {
            icon: "wifi",
            title: "WiFi",
            description: wifiModule.getDisplayText(),
            action: function () {
                currentView = "wifi";
            }
        },
        {
            icon: "lan",
            title: "Ethernet",
            description: ethernetModule.getDisplayText(),
            action: function () {
                currentView = "ethernet";
            }
        },
        {
            icon: "bluetooth",
            title: "Bluetooth",
            description: bluetoothModule.getDisplayText(),
            action: function () {
                currentView = "bluetooth";
            }
        },
        {
            icon: "nightlight",
            title: "Silent mode",
            description: dndModule.getDisplayText(),
            action: function () {
                currentView = "silent";
            }
        },
        {
            icon: "vpn_key",
            title: "VPN",
            description: vpnModule.getDisplayText(),
            action: function () {
                currentView = "vpn";
            }
        },
        {
            icon: "shield",
            title: "Protection",
            description: antivirusModule.getDisplayText(),
            action: function () {
                currentView = "protection";
            }
        }
    ]

    function show() {
        isVisible = true;
    }

    function hide() {
        isVisible = false;
        currentView = "main";
    }



    function connectToNetwork(ssid, secured) {
        selectedNetwork = ssid;
        selectedNetworkSecurity = secured;

        if (secured) {
            networkPassword = "";
            showPasswordDialog = true;
            passwordWindow.show();
        } else {
            wifiModule.connectToNetwork(ssid, "");
        }
    }

    function copyToClipboard(text) {
        if (text && text !== "Not assigned" && text !== "Unknown" && text !== "Not connected") {
            clipboardProcess.command = ["wl-copy", text];
            clipboardProcess.running = true;
        }
    }

    function isControlActive(controlIndex) {
        if (controlIndex >= controlsData.length) return false;
        
        const title = controlsData[controlIndex].title;
        switch(title) {
            case "WiFi":
                return wifiModule.radioEnabled && wifiModule.connectedNetwork !== "";
            case "Ethernet":
                return ethernetModule.connected;
            case "Bluetooth":
                return bluetoothModule.enabled;
            case "Silent mode":
                return dndModule.enabled;
            case "VPN":
                return vpnModule.connected;
            case "Protection":
                return antivirusModule.connected;
            default:
                return false;
        }
    }
    
    function getControlBackgroundColor(controlIndex, isHovered) {
        if (isControlActive(controlIndex)) {
            return Local.Theme.colors.gray9;
        }
        return isHovered ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2;
    }
    
    function getControlTextColor(controlIndex) {
        if (isControlActive(controlIndex)) {
            return Local.Theme.colors.gray0;
        }
        return Local.Theme.colors.foreground;
    }
    
    function getControlDescriptionColor(controlIndex) {
        if (isControlActive(controlIndex)) {
            return Local.Theme.colors.gray0;
        }
        return Local.Theme.colors.gray7;
    }




    Loader {
        active: controlCenter.isVisible
        sourceComponent: Component {
            PanelWindow {
                WlrLayershell.layer: WlrLayer.Overlay
                anchors {
                    right: true
                    top: true
                }

                implicitWidth: 600
                implicitHeight: 950
                margins {
                    top: 12
                    right: 10
                }

                color: "transparent"

                Rectangle {
                    anchors.fill: parent
                    color: Local.Theme.panelBackground
                    radius: Local.Theme.radius.normal
                    border.width: Local.Theme.border.thick
                    border.color: Local.Theme.border.color

                    Column {
                        anchors.fill: parent
                        anchors.margins: Local.Theme.spacing.large
                        spacing: 0

                        Column {
                            id: headerSection
                            width: parent.width
                            spacing: Local.Theme.spacing.large

                            Text {
                                text: "Control Center"
                                font.family: Local.Theme.font.family
                                font.pixelSize: Local.Theme.font.huge
                                color: Local.Theme.colors.foreground
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Rectangle {
                                width: parent.width
                                height: 1
                                color: Local.Theme.border.color
                            }
                        }

                        Item {
                            width: parent.width
                            height: parent.height - headerSection.height
                            clip: true

                            Column {
                                anchors.fill: parent
                                anchors.topMargin: Local.Theme.spacing.large
                                spacing: Local.Theme.spacing.large
                                visible: controlCenter.currentView === "main"

                                Row {
                                    width: parent.width
                                    height: 60

                                    Column {
                                        id: nixColumn
                                        spacing: Local.Theme.spacing.small
                                        anchors.verticalCenter: parent.verticalCenter

                                        Row {
                                            spacing: Local.Theme.spacing.small

                                            Text {
                                                text: Local.Theme.osIcon
                                                font.family: Local.Theme.font.family
                                                font.pixelSize: Local.Theme.font.huge
                                                color: Local.Theme.colors.foreground
                                                anchors.verticalCenter: parent.verticalCenter
                                            }

                                            Text {
                                                text: "NixOS"
                                                font.family: Local.Theme.font.family
                                                font.pixelSize: Local.Theme.font.large
                                                color: Local.Theme.colors.foreground
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }

                                        Text {
                                            id: uptimeText
                                            text: "up 0 minutes"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.normal
                                            color: Local.Theme.colors.gray7
                                        }
                                    }

                                    Item {
                                        width: parent.width - nixColumn.width - powerButton.width
                                        height: 1
                                    }

                                    Rectangle {
                                        id: powerButton
                                        width: 40
                                        height: 40
                                        radius: Local.Theme.radius.normal
                                        color: powerMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                        border.width: Local.Theme.border.thick
                                        border.color: Local.Theme.border.color
                                        anchors.verticalCenter: parent.verticalCenter

                                        Local.MaterialSymbol {
                                            icon: "power_settings_new"
                                            iconSize: Local.Theme.font.huge
                                            color: Local.Theme.colors.foreground
                                            anchors.centerIn: parent
                                        }

                                        MouseArea {
                                            id: powerMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {}
                                        }
                                    }
                                }

                                Timer {
                                    interval: 60000
                                    running: true
                                    repeat: true
                                    triggeredOnStart: true
                                    onTriggered: {
                                        uptimeProcess.running = true;
                                    }
                                }

                                Process {
                                    id: uptimeProcess
                                    command: ["bash", "-c", "awk '{print int($1)}' /proc/uptime"]
                                    running: false
                                    stdout: SplitParser {
                                        onRead: line => {
                                            if (line && line.trim() !== "") {
                                                let totalSeconds = parseInt(line.trim());
                                                let minutes = Math.floor(totalSeconds / 60);
                                                let hours = Math.floor(minutes / 60);
                                                let days = Math.floor(hours / 24);

                                                let result = "up ";
                                                if (days > 0) {
                                                    result += days + " day" + (days > 1 ? "s" : "");
                                                    if (hours % 24 > 0 || minutes % 60 > 0)
                                                        result += ", ";
                                                }
                                                if (hours % 24 > 0) {
                                                    result += (hours % 24) + " hour" + (hours % 24 > 1 ? "s" : "");
                                                    if (minutes % 60 > 0)
                                                        result += ", ";
                                                }
                                                if (minutes % 60 > 0 || (days === 0 && hours === 0)) {
                                                    result += (minutes % 60) + " minute" + (minutes % 60 !== 1 ? "s" : "");
                                                }

                                                uptimeText.text = result;
                                                uptimeProcess.running = false;
                                            }
                                        }
                                    }
                                }

                                Column {
                                    width: parent.width
                                    spacing: Local.Theme.spacing.normal

                                    Repeater {
                                        model: Math.ceil(controlCenter.controlsData.length / 2)

                                        Row {
                                            width: parent.width
                                            spacing: Local.Theme.spacing.normal

                                            Rectangle {
                                                width: (parent.width - parent.spacing) / 2
                                                height: 80
                                                radius: Local.Theme.radius.normal
                                                color: getControlBackgroundColor(index * 2, firstMouse.containsMouse)
                                                border.width: Local.Theme.border.thick
                                                border.color: Local.Theme.border.color

                                                Local.MaterialSymbol {
                                                    icon: controlCenter.controlsData[index * 2].icon
                                                    iconSize: 32
                                                    color: getControlTextColor(index * 2)
                                                    anchors.left: parent.left
                                                    anchors.leftMargin: Local.Theme.spacing.large
                                                    anchors.verticalCenter: parent.verticalCenter
                                                }

                                                Column {
                                                    spacing: Local.Theme.spacing.tiny
                                                    anchors.right: parent.right
                                                    anchors.rightMargin: Local.Theme.spacing.large
                                                    anchors.left: parent.left
                                                    anchors.leftMargin: 32 + Local.Theme.spacing.large * 2
                                                    anchors.verticalCenter: parent.verticalCenter

                                                    Text {
                                                        text: controlCenter.controlsData[index * 2].title
                                                        font.family: Local.Theme.font.family
                                                        font.pixelSize: Local.Theme.font.huge
                                                        font.weight: Font.Bold
                                                        color: getControlTextColor(index * 2)
                                                    }

                                                    Text {
                                                        text: controlCenter.controlsData[index * 2].description
                                                        font.family: Local.Theme.font.family
                                                        font.pixelSize: Local.Theme.font.normal
                                                        color: getControlDescriptionColor(index * 2)
                                                    }
                                                }

                                                MouseArea {
                                                    id: firstMouse
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: {
                                                        controlCenter.controlsData[index * 2].action();
                                                    }
                                                }
                                            }

                                            Rectangle {
                                                width: (parent.width - parent.spacing) / 2
                                                height: 80
                                                radius: Local.Theme.radius.normal
                                                color: getControlBackgroundColor(index * 2 + 1, secondMouse.containsMouse)
                                                border.width: Local.Theme.border.thick
                                                border.color: Local.Theme.border.color
                                                visible: index * 2 + 1 < controlCenter.controlsData.length

                                                Local.MaterialSymbol {
                                                    icon: index * 2 + 1 < controlCenter.controlsData.length ? controlCenter.controlsData[index * 2 + 1].icon : ""
                                                    iconSize: 32
                                                    color: getControlTextColor(index * 2 + 1)
                                                    anchors.left: parent.left
                                                    anchors.leftMargin: Local.Theme.spacing.large
                                                    anchors.verticalCenter: parent.verticalCenter
                                                }

                                                Column {
                                                    spacing: Local.Theme.spacing.tiny
                                                    anchors.right: parent.right
                                                    anchors.rightMargin: Local.Theme.spacing.large
                                                    anchors.left: parent.left
                                                    anchors.leftMargin: 32 + Local.Theme.spacing.large * 2
                                                    anchors.verticalCenter: parent.verticalCenter

                                                    Text {
                                                        text: index * 2 + 1 < controlCenter.controlsData.length ? controlCenter.controlsData[index * 2 + 1].title : ""
                                                        font.family: Local.Theme.font.family
                                                        font.pixelSize: Local.Theme.font.huge
                                                        font.weight: Font.Bold
                                                        color: getControlTextColor(index * 2 + 1)
                                                    }

                                                    Text {
                                                        text: index * 2 + 1 < controlCenter.controlsData.length ? controlCenter.controlsData[index * 2 + 1].description : ""
                                                        font.family: Local.Theme.font.family
                                                        font.pixelSize: Local.Theme.font.normal
                                                        color: getControlDescriptionColor(index * 2 + 1)
                                                    }
                                                }

                                                MouseArea {
                                                    id: secondMouse
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: {
                                                        if (index * 2 + 1 < controlCenter.controlsData.length) {
                                                            controlCenter.controlsData[index * 2 + 1].action();
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    width: parent.width
                                    height: 500
                                    radius: Local.Theme.radius.normal
                                    color: Local.Theme.colors.gray1
                                    border.width: Local.Theme.border.thick
                                    border.color: Local.Theme.border.color

                                    Column {
                                        anchors.fill: parent
                                        anchors.margins: Local.Theme.spacing.normal
                                        spacing: Local.Theme.spacing.normal

                                        Text {
                                            text: "Notifications"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.huge
                                            font.weight: Font.Bold
                                            color: Local.Theme.colors.foreground
                                            anchors.left: parent.left
                                            anchors.leftMargin: Local.Theme.spacing.small
                                            anchors.top: parent.top
                                            anchors.topMargin: Local.Theme.spacing.small
                                        }

                                        Rectangle {
                                            width: parent.width - Local.Theme.spacing.normal * 2
                                            height: 1
                                            color: Local.Theme.border.color
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.top: parent.top
                                            anchors.topMargin: 40
                                        }

                                        ScrollView {
                                            width: parent.width
                                            height: parent.height - 100 - Local.Theme.spacing.normal
                                            anchors.top: parent.top
                                            anchors.topMargin: 50
                                            clip: true

                                            Column {
                                                width: parent.width
                                                spacing: Local.Theme.spacing.small

                                                Repeater {
                                                    model: Local.NotificationService.notificationHistory

                                                    Rectangle {
                                                        required property var modelData
                                                        required property int index
                                                        property int notificationIndex: index

                                                        width: parent.width
                                                        height: notifContent.implicitHeight + Local.Theme.spacing.large + (modelData.actions && modelData.actions.length > 0 ? Local.Theme.spacing.normal : Local.Theme.spacing.large)
                                                        color: Local.Theme.panelBackground
                                                        radius: Local.Theme.radius.normal
                                                        border.width: Local.Theme.border.thick
                                                        border.color: Local.Theme.border.color

                                                        Column {
                                                            id: notifContent
                                                            anchors.top: parent.top
                                                            anchors.left: parent.left
                                                            anchors.right: parent.right
                                                            anchors.topMargin: Local.Theme.spacing.large
                                                            anchors.leftMargin: Local.Theme.spacing.large
                                                            anchors.rightMargin: Local.Theme.spacing.large
                                                            spacing: Local.Theme.spacing.normal

                                                            Row {
                                                                width: parent.width
                                                                spacing: Local.Theme.spacing.normal

                                                                Rectangle {
                                                                    property string iconSource: parent.parent.parent.modelData.image || parent.parent.parent.modelData.appIcon || ""
                                                                    width: 48
                                                                    height: 48
                                                                    radius: 6
                                                                    color: iconSource === "" ? Local.Theme.colors.gray3 : "transparent"
                                                                    clip: true
                                                                    anchors.verticalCenter: parent.verticalCenter

                                                                    IconImage {
                                                                        anchors.fill: parent
                                                                        anchors.margins: 4
                                                                        source: parent.iconSource
                                                                        visible: parent.iconSource !== ""
                                                                        onStatusChanged: {
                                                                            if (status === Image.Error) {
                                                                                console.log("Failed to load icon:", source);
                                                                            }
                                                                        }
                                                                    }

                                                                    Local.MaterialSymbol {
                                                                        icon: "notifications"
                                                                        iconSize: 20
                                                                        anchors.centerIn: parent
                                                                        visible: parent.iconSource === ""
                                                                        color: Local.Theme.colors.gray6
                                                                    }
                                                                }

                                                                Column {
                                                                    width: parent.width - parent.children[0].width - closeButton.width - parent.spacing * 2
                                                                    spacing: Local.Theme.spacing.small

                                                                    Text {
                                                                        text: parent.parent.parent.parent.modelData.summary
                                                                        font.family: Local.Theme.font.family
                                                                        font.pixelSize: Local.Theme.font.large
                                                                        font.weight: Font.Bold
                                                                        color: Local.Theme.colors.foreground
                                                                        wrapMode: Text.WordWrap
                                                                        width: parent.width
                                                                    }

                                                                    Text {
                                                                        text: parent.parent.parent.parent.modelData.body
                                                                        font.family: Local.Theme.font.family
                                                                        font.pixelSize: Local.Theme.font.normal
                                                                        color: Local.Theme.colors.foreground
                                                                        wrapMode: Text.WordWrap
                                                                        width: parent.width
                                                                        visible: text.length > 0
                                                                    }
                                                                }

                                                                Rectangle {
                                                                    id: closeButton
                                                                    width: 20
                                                                    height: 20
                                                                    radius: 10
                                                                    color: closeMouse.containsMouse ? Local.Theme.colors.gray4 : Local.Theme.colors.gray3
                                                                    anchors.top: parent.top

                                                                    Local.MaterialSymbol {
                                                                        icon: "close"
                                                                        iconSize: 12
                                                                        color: Local.Theme.colors.foreground
                                                                        anchors.centerIn: parent
                                                                    }

                                                                    MouseArea {
                                                                        id: closeMouse
                                                                        anchors.fill: parent
                                                                        hoverEnabled: true
                                                                        cursorShape: Qt.PointingHandCursor
                                                                        onClicked: {
                                                                            Local.NotificationService.removeFromHistory(parent.parent.parent.parent.notificationIndex);
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                        Rectangle {
                                            width: parent.width - Local.Theme.spacing.normal * 2
                                            height: 1
                                            color: Local.Theme.border.color
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.bottom: parent.bottom
                                            anchors.bottomMargin: 50
                                        }

                                        Rectangle {
                                            id: clearButton
                                            width: 80
                                            height: 28
                                            radius: Local.Theme.radius.normal
                                            color: clearMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                            border.width: Local.Theme.border.thick
                                            border.color: Local.Theme.border.color
                                            anchors.right: parent.right
                                            anchors.rightMargin: Local.Theme.spacing.normal
                                            anchors.bottom: parent.bottom
                                            anchors.bottomMargin: 10

                                            Local.MaterialSymbol {
                                                icon: "delete"
                                                iconSize: 16
                                                color: Local.Theme.colors.foreground
                                                anchors.left: parent.left
                                                anchors.leftMargin: Local.Theme.spacing.normal
                                                anchors.verticalCenter: parent.verticalCenter
                                            }

                                            Text {
                                                text: "Clear"
                                                font.family: Local.Theme.font.family
                                                font.pixelSize: Local.Theme.font.tiny
                                                font.weight: Font.Bold
                                                color: Local.Theme.colors.foreground
                                                x: 16 + Local.Theme.spacing.normal * 2
                                                anchors.verticalCenter: parent.verticalCenter
                                            }

                                            MouseArea {
                                                id: clearMouse
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    Local.NotificationService.clearHistory();
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            Column {
                                anchors.fill: parent
                                anchors.topMargin: Local.Theme.spacing.large
                                spacing: Local.Theme.spacing.large
                                visible: controlCenter.currentView === "wifi"

                                Rectangle {
                                    width: parent.width
                                    height: 60
                                    color: "transparent"

                                    Rectangle {
                                        id: backButton
                                        width: 40
                                        height: 40
                                        radius: Local.Theme.radius.normal
                                        color: backMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                        border.width: Local.Theme.border.thick
                                        border.color: Local.Theme.border.color
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter

                                        Local.MaterialSymbol {
                                            icon: "arrow_back"
                                            iconSize: Local.Theme.font.huge
                                            color: Local.Theme.colors.foreground
                                            anchors.centerIn: parent
                                        }

                                        MouseArea {
                                            id: backMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: controlCenter.currentView = "main"
                                        }
                                    }

                                    Column {
                                        spacing: Local.Theme.spacing.small
                                        anchors.left: backButton.right
                                        anchors.leftMargin: Local.Theme.spacing.large
                                        anchors.verticalCenter: parent.verticalCenter

                                        Text {
                                            text: "WiFi Settings"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.large
                                            color: Local.Theme.colors.foreground
                                        }

                                        Text {
                                            text: wifiModule.getDisplayText()
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.normal
                                            color: Local.Theme.colors.gray7
                                        }
                                    }

                                    Rectangle {
                                        id: wifiToggle
                                        width: 60
                                        height: 30
                                        radius: 15
                                        color: wifiModule.radioEnabled ? Local.Theme.colors.foreground : Local.Theme.colors.gray3
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter

                                        Rectangle {
                                            width: 24
                                            height: 24
                                            radius: 12
                                            color: Local.Theme.colors.gray1
                                            anchors.verticalCenter: parent.verticalCenter
                                            x: wifiModule.radioEnabled ? parent.width - width - 3 : 3

                                            Behavior on x {
                                                NumberAnimation {
                                                    duration: 200
                                                    easing.type: Easing.OutQuad
                                                }
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                wifiModule.toggleWifi();
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    width: parent.width
                                    height: parent.height - 120
                                    radius: Local.Theme.radius.normal
                                    color: Local.Theme.colors.gray1
                                    border.width: Local.Theme.border.thick
                                    border.color: Local.Theme.border.color

                                    Column {
                                        anchors.fill: parent
                                        anchors.margins: Local.Theme.spacing.normal

                                        Text {
                                            text: "Available Networks"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.huge
                                            font.weight: Font.Bold
                                            color: Local.Theme.colors.foreground
                                            anchors.left: parent.left
                                            anchors.leftMargin: Local.Theme.spacing.small
                                            anchors.top: parent.top
                                            anchors.topMargin: Local.Theme.spacing.small
                                        }

                                        Rectangle {
                                            width: parent.width - Local.Theme.spacing.normal * 2
                                            height: 1
                                            color: Local.Theme.border.color
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.top: parent.top
                                            anchors.topMargin: 40
                                        }

                                        ScrollView {
                                            width: parent.width
                                            height: parent.height - 60
                                            anchors.top: parent.top
                                            anchors.topMargin: 50
                                            clip: true

                                            Column {
                                                width: Math.max(parent.width, 550)
                                                spacing: Local.Theme.spacing.small

                                                Text {
                                                    text: "Enable WiFi to see available networks"
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.normal
                                                    color: Local.Theme.colors.gray7
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    anchors.topMargin: Local.Theme.spacing.large
                                                    visible: !wifiModule.radioEnabled
                                                }

                                                Text {
                                                    text: "Scanning for networks..."
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.normal
                                                    color: Local.Theme.colors.gray7
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    anchors.topMargin: Local.Theme.spacing.large
                                                    visible: wifiModule.radioEnabled && !wifiModule.hasScannedOnce
                                                }

                                                Text {
                                                    text: "No networks found"
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.normal
                                                    color: Local.Theme.colors.gray7
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    anchors.topMargin: Local.Theme.spacing.large
                                                    visible: wifiModule.radioEnabled && wifiModule.hasScannedOnce && wifiModule.availableNetworks.length === 0
                                                }

                                                Repeater {
                                                    model: wifiModule.radioEnabled ? wifiModule.availableNetworks : []

                                                    Rectangle {
                                                        required property var modelData
                                                        required property int index

                                                        width: parent.width
                                                        height: 60
                                                        radius: Local.Theme.radius.normal
                                                        color: networkMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                                        border.width: Local.Theme.border.thick
                                                        border.color: Local.Theme.border.color

                                                        Row {
                                                            anchors.fill: parent
                                                            anchors.margins: Local.Theme.spacing.normal
                                                            spacing: Local.Theme.spacing.normal

                                                            Local.MaterialSymbol {
                                                                icon: "wifi"
                                                                iconSize: 24
                                                                color: modelData.ssid === wifiModule.connectedNetwork ? Local.Theme.colors.gray9 : Local.Theme.colors.gray7
                                                                anchors.verticalCenter: parent.verticalCenter
                                                            }

                                                            Column {
                                                                spacing: Local.Theme.spacing.tiny
                                                                anchors.verticalCenter: parent.verticalCenter

                                                                Text {
                                                                    text: modelData.ssid
                                                                    font.family: Local.Theme.font.family
                                                                    font.pixelSize: Local.Theme.font.large
                                                                    font.weight: Font.Bold
                                                                    color: Local.Theme.colors.foreground
                                                                }

                                                                Text {
                                                                    text: modelData.ssid === wifiModule.connectedNetwork ? "Connected" : (modelData.security ? "Secured" : "Open")
                                                                    font.family: Local.Theme.font.family
                                                                    font.pixelSize: Local.Theme.font.normal
                                                                    color: Local.Theme.colors.gray7
                                                                }
                                                            }

                                                            Item {
                                                                width: parent.width - parent.children[0].width - parent.children[1].width - parent.children[3].width - parent.spacing * 3
                                                                height: 1
                                                            }

                                                            Local.MaterialSymbol {
                                                                icon: modelData.security ? "lock" : "lock_open"
                                                                iconSize: 20
                                                                color: Local.Theme.colors.gray6
                                                                anchors.verticalCenter: parent.verticalCenter
                                                            }
                                                        }

                                                        MouseArea {
                                                            id: networkMouse
                                                            anchors.fill: parent
                                                            hoverEnabled: modelData.ssid !== wifiModule.connectedNetwork
                                                            cursorShape: modelData.ssid === wifiModule.connectedNetwork ? Qt.ArrowCursor : Qt.PointingHandCursor
                                                            enabled: modelData.ssid !== wifiModule.connectedNetwork
                                                            onClicked: {
                                                                if (modelData.ssid !== wifiModule.connectedNetwork) {
                                                                    controlCenter.connectToNetwork(modelData.ssid, modelData.security);
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            Column {
                                anchors.fill: parent
                                anchors.topMargin: Local.Theme.spacing.large
                                spacing: Local.Theme.spacing.large
                                visible: controlCenter.currentView === "bluetooth"

                                Rectangle {
                                    width: parent.width
                                    height: 60
                                    color: "transparent"

                                    Rectangle {
                                        id: bluetoothBackButton
                                        width: 40
                                        height: 40
                                        radius: Local.Theme.radius.normal
                                        color: bluetoothBackMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                        border.width: Local.Theme.border.thick
                                        border.color: Local.Theme.border.color
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter

                                        Local.MaterialSymbol {
                                            icon: "arrow_back"
                                            iconSize: Local.Theme.font.huge
                                            color: Local.Theme.colors.foreground
                                            anchors.centerIn: parent
                                        }

                                        MouseArea {
                                            id: bluetoothBackMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: controlCenter.currentView = "main"
                                        }
                                    }

                                    Column {
                                        spacing: Local.Theme.spacing.small
                                        anchors.left: bluetoothBackButton.right
                                        anchors.leftMargin: Local.Theme.spacing.large
                                        anchors.verticalCenter: parent.verticalCenter

                                        Text {
                                            text: "Bluetooth Settings"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.large
                                            color: Local.Theme.colors.foreground
                                        }

                                        Text {
                                            text: bluetoothModule.getDisplayText()
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.normal
                                            color: Local.Theme.colors.gray7
                                        }
                                    }

                                    Rectangle {
                                        id: bluetoothToggle
                                        width: 60
                                        height: 30
                                        radius: 15
                                        color: bluetoothModule.enabled ? Local.Theme.colors.foreground : Local.Theme.colors.gray3
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter

                                        Rectangle {
                                            width: 24
                                            height: 24
                                            radius: 12
                                            color: Local.Theme.colors.gray1
                                            anchors.verticalCenter: parent.verticalCenter
                                            x: bluetoothModule.enabled ? parent.width - width - 3 : 3

                                            Behavior on x {
                                                NumberAnimation {
                                                    duration: 200
                                                    easing.type: Easing.OutQuad
                                                }
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                bluetoothModule.toggleBluetooth();
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    width: parent.width
                                    height: parent.height - 120
                                    radius: Local.Theme.radius.normal
                                    color: Local.Theme.colors.gray1
                                    border.width: Local.Theme.border.thick
                                    border.color: Local.Theme.border.color

                                    Column {
                                        anchors.fill: parent
                                        anchors.margins: Local.Theme.spacing.normal

                                        Text {
                                            text: "Available Devices"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.huge
                                            font.weight: Font.Bold
                                            color: Local.Theme.colors.foreground
                                            anchors.left: parent.left
                                            anchors.leftMargin: Local.Theme.spacing.small
                                            anchors.top: parent.top
                                            anchors.topMargin: Local.Theme.spacing.small
                                        }

                                        Rectangle {
                                            width: parent.width - Local.Theme.spacing.normal * 2
                                            height: 1
                                            color: Local.Theme.border.color
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.top: parent.top
                                            anchors.topMargin: 40
                                        }

                                        ScrollView {
                                            width: parent.width
                                            height: parent.height - 60
                                            anchors.top: parent.top
                                            anchors.topMargin: 50
                                            clip: true

                                            Column {
                                                width: Math.max(parent.width, 550)
                                                spacing: Local.Theme.spacing.small

                                                Text {
                                                    text: "Enable Bluetooth to see available devices"
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.normal
                                                    color: Local.Theme.colors.gray7
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    anchors.topMargin: Local.Theme.spacing.large
                                                    visible: !bluetoothModule.enabled
                                                }

                                                Text {
                                                    text: "Scanning for devices..."
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.normal
                                                    color: Local.Theme.colors.gray7
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    anchors.topMargin: Local.Theme.spacing.large
                                                    visible: bluetoothModule.enabled && !bluetoothModule.hasScannedOnce
                                                }

                                                Text {
                                                    text: "No devices found"
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.normal
                                                    color: Local.Theme.colors.gray7
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    anchors.topMargin: Local.Theme.spacing.large
                                                    visible: bluetoothModule.enabled && bluetoothModule.hasScannedOnce && bluetoothModule.availableDevices.length === 0
                                                }

                                                Repeater {
                                                    model: bluetoothModule.enabled ? bluetoothModule.availableDevices : []

                                                    Rectangle {
                                                        required property var modelData
                                                        required property int index

                                                        width: parent.width
                                                        height: 60
                                                        radius: Local.Theme.radius.normal
                                                        color: deviceMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                                        border.width: Local.Theme.border.thick
                                                        border.color: Local.Theme.border.color

                                                        Row {
                                                            anchors.fill: parent
                                                            anchors.margins: Local.Theme.spacing.normal
                                                            spacing: Local.Theme.spacing.normal

                                                            Local.MaterialSymbol {
                                                                icon: "bluetooth"
                                                                iconSize: 24
                                                                color: modelData.connected ? Local.Theme.colors.gray9 : Local.Theme.colors.gray7
                                                                anchors.verticalCenter: parent.verticalCenter
                                                            }

                                                            Column {
                                                                spacing: Local.Theme.spacing.tiny
                                                                anchors.verticalCenter: parent.verticalCenter

                                                                Text {
                                                                    text: modelData.name
                                                                    font.family: Local.Theme.font.family
                                                                    font.pixelSize: Local.Theme.font.large
                                                                    font.weight: Font.Bold
                                                                    color: Local.Theme.colors.foreground
                                                                }

                                                                Text {
                                                                    text: modelData.connected ? "Connected" : (modelData.paired ? "Paired" : "Available")
                                                                    font.family: Local.Theme.font.family
                                                                    font.pixelSize: Local.Theme.font.normal
                                                                    color: Local.Theme.colors.gray7
                                                                }
                                                            }

                                                            Item {
                                                                width: parent.width - parent.children[0].width - parent.children[1].width - parent.children[3].width - parent.spacing * 3
                                                                height: 1
                                                            }

                                                            Local.MaterialSymbol {
                                                                icon: modelData.connected ? "bluetooth_connected" : "bluetooth"
                                                                iconSize: 20
                                                                color: Local.Theme.colors.gray6
                                                                anchors.verticalCenter: parent.verticalCenter
                                                            }
                                                        }

                                                        MouseArea {
                                                            id: deviceMouse
                                                            anchors.fill: parent
                                                            hoverEnabled: true
                                                            cursorShape: Qt.PointingHandCursor
                                                            onClicked: {
                                                                if (modelData.connected) {
                                                                    bluetoothModule.disconnectDevice(modelData.address);
                                                                } else {
                                                                    bluetoothModule.connectToDevice(modelData.address, modelData.name);
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            Column {
                                anchors.fill: parent
                                anchors.topMargin: Local.Theme.spacing.large
                                spacing: Local.Theme.spacing.large
                                visible: controlCenter.currentView === "ethernet"

                                Rectangle {
                                    width: parent.width
                                    height: 60
                                    color: "transparent"

                                    Rectangle {
                                        id: ethernetBackButton
                                        width: 40
                                        height: 40
                                        radius: Local.Theme.radius.normal
                                        color: ethernetBackMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                        border.width: Local.Theme.border.thick
                                        border.color: Local.Theme.border.color
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter

                                        Local.MaterialSymbol {
                                            icon: "arrow_back"
                                            iconSize: Local.Theme.font.huge
                                            color: Local.Theme.colors.foreground
                                            anchors.centerIn: parent
                                        }

                                        MouseArea {
                                            id: ethernetBackMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: controlCenter.currentView = "main"
                                        }
                                    }

                                    Column {
                                        spacing: Local.Theme.spacing.small
                                        anchors.left: ethernetBackButton.right
                                        anchors.leftMargin: Local.Theme.spacing.large
                                        anchors.verticalCenter: parent.verticalCenter

                                        Text {
                                            text: "Ethernet Connection"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.large
                                            color: Local.Theme.colors.foreground
                                        }

                                        Text {
                                            text: ethernetModule.getDisplayText()
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.normal
                                            color: Local.Theme.colors.gray7
                                        }
                                    }
                                }

                                Rectangle {
                                    width: parent.width
                                    height: parent.height - 120
                                    radius: Local.Theme.radius.normal
                                    color: Local.Theme.colors.gray1
                                    border.width: Local.Theme.border.thick
                                    border.color: Local.Theme.border.color

                                    Column {
                                        anchors.fill: parent
                                        anchors.margins: Local.Theme.spacing.large
                                        spacing: Local.Theme.spacing.large

                                        Text {
                                            text: "Network Information"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.huge
                                            font.weight: Font.Bold
                                            color: Local.Theme.colors.foreground
                                        }

                                        Rectangle {
                                            width: parent.width
                                            height: 1
                                            color: Local.Theme.border.color
                                        }

                                        Grid {
                                            width: parent.width
                                            columns: 2
                                            columnSpacing: Local.Theme.spacing.large
                                            rowSpacing: Local.Theme.spacing.large

                                            // Connection Status
                                            Column {
                                                spacing: Local.Theme.spacing.small
                                                width: (parent.width - parent.columnSpacing) / 2

                                                Text {
                                                    text: "Status"
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.normal
                                                    font.weight: Font.Bold
                                                    color: Local.Theme.colors.gray6
                                                }
                                                Rectangle {
                                                    width: parent.width
                                                    height: statusText.implicitHeight
                                                    color: statusMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                                    radius: Local.Theme.radius.small
                                                    
                                                    Text {
                                                        id: statusText
                                                        text: ethernetModule.status
                                                        font.family: Local.Theme.font.family
                                                        font.pixelSize: Local.Theme.font.large
                                                        color: Local.Theme.colors.foreground
                                                        wrapMode: Text.WordWrap
                                                        width: parent.width
                                                        anchors.left: parent.left
                                                        anchors.leftMargin: 4
                                                        anchors.verticalCenter: parent.verticalCenter
                                                    }
                                                    
                                                    MouseArea {
                                                        id: statusMouse
                                                        anchors.fill: parent
                                                        hoverEnabled: true
                                                        cursorShape: Qt.PointingHandCursor
                                                        onClicked: {
                                                            controlCenter.copyToClipboard(ethernetModule.status);
                                                        }
                                                    }
                                                }
                                            }

                                            // Connection Name
                                            Column {
                                                spacing: Local.Theme.spacing.small
                                                width: (parent.width - parent.columnSpacing) / 2

                                                Text {
                                                    text: "Connection"
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.normal
                                                    font.weight: Font.Bold
                                                    color: Local.Theme.colors.gray6
                                                }
                                                Rectangle {
                                                    width: parent.width
                                                    height: connectionText.implicitHeight
                                                    color: connectionMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                                    radius: Local.Theme.radius.small
                                                    
                                                    Text {
                                                        id: connectionText
                                                        text: ethernetModule.connectionName || "Not connected"
                                                        font.family: Local.Theme.font.family
                                                        font.pixelSize: Local.Theme.font.large
                                                        color: Local.Theme.colors.foreground
                                                        wrapMode: Text.WordWrap
                                                        width: parent.width - 8
                                                        anchors.left: parent.left
                                                        anchors.leftMargin: 4
                                                        anchors.verticalCenter: parent.verticalCenter
                                                    }
                                                    
                                                    MouseArea {
                                                        id: connectionMouse
                                                        anchors.fill: parent
                                                        hoverEnabled: true
                                                        cursorShape: Qt.PointingHandCursor
                                                        onClicked: {
                                                            controlCenter.copyToClipboard(ethernetModule.connectionName);
                                                        }
                                                    }
                                                }
                                            }

                                            // IP Address
                                            Column {
                                                spacing: Local.Theme.spacing.small
                                                width: (parent.width - parent.columnSpacing) / 2

                                                Text {
                                                    text: "IP Address"
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.normal
                                                    font.weight: Font.Bold
                                                    color: Local.Theme.colors.gray6
                                                }
                                                Rectangle {
                                                    width: parent.width
                                                    height: ipText.implicitHeight
                                                    color: ipMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                                    radius: Local.Theme.radius.small
                                                    
                                                    Text {
                                                        id: ipText
                                                        text: ethernetModule.ipAddress || "Not assigned"
                                                        font.family: Local.Theme.font.family
                                                        font.pixelSize: Local.Theme.font.large
                                                        color: Local.Theme.colors.foreground
                                                        wrapMode: Text.WordWrap
                                                        width: parent.width - 8
                                                        anchors.left: parent.left
                                                        anchors.leftMargin: 4
                                                        anchors.verticalCenter: parent.verticalCenter
                                                    }
                                                    
                                                    MouseArea {
                                                        id: ipMouse
                                                        anchors.fill: parent
                                                        hoverEnabled: true
                                                        cursorShape: Qt.PointingHandCursor
                                                        onClicked: {
                                                            controlCenter.copyToClipboard(ethernetModule.ipAddress);
                                                        }
                                                    }
                                                }
                                            }

                                            // Subnet Mask
                                            Column {
                                                spacing: Local.Theme.spacing.small
                                                width: (parent.width - parent.columnSpacing) / 2

                                                Text {
                                                    text: "Subnet Mask"
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.normal
                                                    font.weight: Font.Bold
                                                    color: Local.Theme.colors.gray6
                                                }
                                                Text {
                                                    text: ethernetModule.subnetMask || "Not assigned"
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.large
                                                    color: Local.Theme.colors.foreground
                                                    wrapMode: Text.WordWrap
                                                    width: parent.width
                                                }
                                            }

                                            // Gateway
                                            Column {
                                                spacing: Local.Theme.spacing.small
                                                width: (parent.width - parent.columnSpacing) / 2

                                                Text {
                                                    text: "Gateway"
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.normal
                                                    font.weight: Font.Bold
                                                    color: Local.Theme.colors.gray6
                                                }
                                                Rectangle {
                                                    width: parent.width
                                                    height: gatewayText.implicitHeight
                                                    color: gatewayMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                                    radius: Local.Theme.radius.small
                                                    
                                                    Text {
                                                        id: gatewayText
                                                        text: ethernetModule.gateway || "Not assigned"
                                                        font.family: Local.Theme.font.family
                                                        font.pixelSize: Local.Theme.font.large
                                                        color: Local.Theme.colors.foreground
                                                        wrapMode: Text.WordWrap
                                                        width: parent.width - 8
                                                        anchors.left: parent.left
                                                        anchors.leftMargin: 4
                                                        anchors.verticalCenter: parent.verticalCenter
                                                    }
                                                    
                                                    MouseArea {
                                                        id: gatewayMouse
                                                        anchors.fill: parent
                                                        hoverEnabled: true
                                                        cursorShape: Qt.PointingHandCursor
                                                        onClicked: {
                                                            controlCenter.copyToClipboard(ethernetModule.gateway);
                                                        }
                                                    }
                                                }
                                            }

                                            // DNS Servers
                                            Column {
                                                spacing: Local.Theme.spacing.small
                                                width: (parent.width - parent.columnSpacing) / 2

                                                Text {
                                                    text: "DNS Servers"
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.normal
                                                    font.weight: Font.Bold
                                                    color: Local.Theme.colors.gray6
                                                }
                                                Rectangle {
                                                    width: parent.width
                                                    height: dnsText.implicitHeight + 8
                                                    color: dnsMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                                    radius: Local.Theme.radius.small
                                                    
                                                    Text {
                                                        id: dnsText
                                                        text: ethernetModule.dnsServers || "Not assigned"
                                                        font.family: Local.Theme.font.family
                                                        font.pixelSize: Local.Theme.font.large
                                                        color: Local.Theme.colors.foreground
                                                        wrapMode: Text.WordWrap
                                                        width: parent.width - 8
                                                        anchors.left: parent.left
                                                        anchors.leftMargin: 4
                                                        anchors.verticalCenter: parent.verticalCenter
                                                    }
                                                    
                                                    MouseArea {
                                                        id: dnsMouse
                                                        anchors.fill: parent
                                                        hoverEnabled: true
                                                        cursorShape: Qt.PointingHandCursor
                                                        onClicked: {
                                                            controlCenter.copyToClipboard(ethernetModule.dnsServers);
                                                        }
                                                    }
                                                }
                                            }

                                            // MAC Address
                                            Column {
                                                spacing: Local.Theme.spacing.small
                                                width: (parent.width - parent.columnSpacing) / 2

                                                Text {
                                                    text: "MAC Address"
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.normal
                                                    font.weight: Font.Bold
                                                    color: Local.Theme.colors.gray6
                                                }
                                                Rectangle {
                                                    width: parent.width
                                                    height: macText.implicitHeight
                                                    color: macMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                                    radius: Local.Theme.radius.small
                                                    
                                                    Text {
                                                        id: macText
                                                        text: ethernetModule.macAddress || "Unknown"
                                                        font.family: Local.Theme.font.family
                                                        font.pixelSize: Local.Theme.font.large
                                                        color: Local.Theme.colors.foreground
                                                        wrapMode: Text.WordWrap
                                                        width: parent.width - 8
                                                        anchors.left: parent.left
                                                        anchors.leftMargin: 4
                                                        anchors.verticalCenter: parent.verticalCenter
                                                    }
                                                    
                                                    MouseArea {
                                                        id: macMouse
                                                        anchors.fill: parent
                                                        hoverEnabled: true
                                                        cursorShape: Qt.PointingHandCursor
                                                        onClicked: {
                                                            controlCenter.copyToClipboard(ethernetModule.macAddress);
                                                        }
                                                    }
                                                }
                                            }

                                            // Link Speed
                                            Column {
                                                spacing: Local.Theme.spacing.small
                                                width: (parent.width - parent.columnSpacing) / 2

                                                Text {
                                                    text: "Link Speed"
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.normal
                                                    font.weight: Font.Bold
                                                    color: Local.Theme.colors.gray6
                                                }
                                                Text {
                                                    text: ethernetModule.linkSpeed || "Unknown"
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.large
                                                    color: Local.Theme.colors.foreground
                                                    wrapMode: Text.WordWrap
                                                    width: parent.width
                                                }
                                            }

                                            // Duplex
                                            Column {
                                                spacing: Local.Theme.spacing.small
                                                width: (parent.width - parent.columnSpacing) / 2

                                                Text {
                                                    text: "Duplex"
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.normal
                                                    font.weight: Font.Bold
                                                    color: Local.Theme.colors.gray6
                                                }
                                                Text {
                                                    text: ethernetModule.duplex || "Unknown"
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.large
                                                    color: Local.Theme.colors.foreground
                                                    wrapMode: Text.WordWrap
                                                    width: parent.width
                                                }
                                            }

                                            // MTU
                                            Column {
                                                spacing: Local.Theme.spacing.small
                                                width: (parent.width - parent.columnSpacing) / 2

                                                Text {
                                                    text: "MTU"
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.normal
                                                    font.weight: Font.Bold
                                                    color: Local.Theme.colors.gray6
                                                }
                                                Text {
                                                    text: ethernetModule.mtu ? ethernetModule.mtu + " bytes" : "Unknown"
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.large
                                                    color: Local.Theme.colors.foreground
                                                    wrapMode: Text.WordWrap
                                                    width: parent.width
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            Column {
                                anchors.fill: parent
                                anchors.topMargin: Local.Theme.spacing.large
                                spacing: Local.Theme.spacing.large
                                visible: controlCenter.currentView === "silent"

                                Row {
                                    width: parent.width
                                    height: 40

                                    Rectangle {
                                        id: silentBackButton
                                        width: 40
                                        height: 40
                                        radius: Local.Theme.radius.normal
                                        color: silentBackMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                        border.width: Local.Theme.border.thick
                                        border.color: Local.Theme.border.color
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter

                                        Local.MaterialSymbol {
                                            icon: "arrow_back"
                                            iconSize: Local.Theme.font.huge
                                            color: Local.Theme.colors.foreground
                                            anchors.centerIn: parent
                                        }

                                        MouseArea {
                                            id: silentBackMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: controlCenter.currentView = "main"
                                        }
                                    }

                                    Column {
                                        spacing: Local.Theme.spacing.small
                                        anchors.left: silentBackButton.right
                                        anchors.leftMargin: Local.Theme.spacing.large
                                        anchors.verticalCenter: parent.verticalCenter

                                        Text {
                                            text: "Silent Mode"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.huge
                                            font.weight: Font.Bold
                                            color: Local.Theme.colors.foreground
                                        }

                                        Text {
                                            text: "Configure notification profiles"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.normal
                                            color: Local.Theme.colors.gray7
                                        }
                                    }
                                }

                                Row {
                                    width: parent.width
                                    height: 48
                                    spacing: Local.Theme.spacing.normal

                                    Rectangle {
                                        width: (parent.width - parent.spacing) / 2
                                        height: parent.height
                                        radius: Local.Theme.radius.normal
                                        color: {
                                            if (Local.DNDState.enabled && Local.DNDState.profile === "silent") {
                                                return Local.Theme.colors.gray9;
                                            }
                                            return silentModeMouseArea.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2;
                                        }
                                        border.width: Local.Theme.border.thick
                                        border.color: Local.Theme.border.color

                                        Row {
                                            anchors.centerIn: parent
                                            spacing: Local.Theme.spacing.small

                                            Local.MaterialSymbol {
                                                icon: "nightlight"
                                                iconSize: 20
                                                color: (Local.DNDState.enabled && Local.DNDState.profile === "silent") ? Local.Theme.colors.gray0 : Local.Theme.colors.foreground
                                                anchors.verticalCenter: parent.verticalCenter
                                            }

                                            Text {
                                                text: "Silent Mode"
                                                font.family: Local.Theme.font.family
                                                font.pixelSize: Local.Theme.font.large
                                                font.weight: Font.Bold
                                                color: (Local.DNDState.enabled && Local.DNDState.profile === "silent") ? Local.Theme.colors.gray0 : Local.Theme.colors.foreground
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }

                                        MouseArea {
                                            id: silentModeMouseArea
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                if (Local.DNDState.enabled && Local.DNDState.profile === "silent") {
                                                    Local.DNDState.enabled = false;
                                                } else {
                                                    Local.DNDState.setProfile("silent");
                                                    Local.DNDState.enabled = true;
                                                }
                                            }
                                        }
                                    }

                                    Rectangle {
                                        width: (parent.width - parent.spacing) / 2
                                        height: parent.height
                                        radius: Local.Theme.radius.normal
                                        color: {
                                            if (Local.DNDState.enabled && Local.DNDState.profile === "work") {
                                                return Local.Theme.colors.gray9;
                                            }
                                            return workModeMouseArea.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2;
                                        }
                                        border.width: Local.Theme.border.thick
                                        border.color: Local.Theme.border.color

                                        Row {
                                            anchors.centerIn: parent
                                            spacing: Local.Theme.spacing.small

                                            Local.MaterialSymbol {
                                                icon: "work"
                                                iconSize: 20
                                                color: (Local.DNDState.enabled && Local.DNDState.profile === "work") ? Local.Theme.colors.gray0 : Local.Theme.colors.foreground
                                                anchors.verticalCenter: parent.verticalCenter
                                            }

                                            Text {
                                                text: "Work Mode"
                                                font.family: Local.Theme.font.family
                                                font.pixelSize: Local.Theme.font.large
                                                font.weight: Font.Bold
                                                color: (Local.DNDState.enabled && Local.DNDState.profile === "work") ? Local.Theme.colors.gray0 : Local.Theme.colors.foreground
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }

                                        MouseArea {
                                            id: workModeMouseArea
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                if (Local.DNDState.enabled && Local.DNDState.profile === "work") {
                                                    Local.DNDState.enabled = false;
                                                } else {
                                                    Local.DNDState.setProfile("work");
                                                    Local.DNDState.enabled = true;
                                                }
                                            }
                                        }
                                    }
                                }

                                Column {
                                    width: parent.width
                                    spacing: Local.Theme.spacing.normal

                                    Text {
                                        text: "Description"
                                        font.family: Local.Theme.font.family
                                        font.pixelSize: Local.Theme.font.normal
                                        font.weight: Font.Bold
                                        color: Local.Theme.colors.gray6
                                    }

                                    Text {
                                        text: "Choose your focus mode. Silent Mode blocks all notifications for complete focus. Work Mode allows work-related apps like Slack and terminals while blocking social media and entertainment notifications."
                                        font.family: Local.Theme.font.family
                                        font.pixelSize: Local.Theme.font.normal
                                        color: Local.Theme.colors.gray7
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }

                                    Text {
                                        text: "Active Features"
                                        font.family: Local.Theme.font.family
                                        font.pixelSize: Local.Theme.font.normal
                                        font.weight: Font.Bold
                                        color: Local.Theme.colors.gray6
                                        topPadding: Local.Theme.spacing.normal
                                        visible: Local.DNDState.enabled
                                    }

                                    Column {
                                        spacing: Local.Theme.spacing.small
                                        width: parent.width
                                        visible: Local.DNDState.enabled

                                        Row {
                                            spacing: Local.Theme.spacing.small
                                            Local.MaterialSymbol {
                                                icon: "check_circle"
                                                iconSize: 16
                                                color: Local.Theme.colors.foreground
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                            Text {
                                                text: "Hide notification popups"
                                                font.family: Local.Theme.font.family
                                                font.pixelSize: Local.Theme.font.normal
                                                color: Local.Theme.colors.foreground
                                            }
                                        }

                                        Row {
                                            spacing: Local.Theme.spacing.small
                                            Local.MaterialSymbol {
                                                icon: "check_circle"
                                                iconSize: 16
                                                color: Local.Theme.colors.foreground
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                            Text {
                                                text: Local.DNDState.profile === "work" ? 
                                                      "Mute sounds (except Slack)" :
                                                      "Mute all notification sounds"
                                                font.family: Local.Theme.font.family
                                                font.pixelSize: Local.Theme.font.normal
                                                color: Local.Theme.colors.foreground
                                            }
                                        }

                                        Row {
                                            spacing: Local.Theme.spacing.small
                                            Local.MaterialSymbol {
                                                icon: "check_circle"
                                                iconSize: 16
                                                color: Local.Theme.colors.foreground
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                            Text {
                                                text: "Collect notifications in history"
                                                font.family: Local.Theme.font.family
                                                font.pixelSize: Local.Theme.font.normal
                                                color: Local.Theme.colors.foreground
                                            }
                                        }
                                    }
                                }
                            }

                            Column {
                                anchors.fill: parent
                                anchors.topMargin: Local.Theme.spacing.large
                                spacing: Local.Theme.spacing.large
                                visible: controlCenter.currentView === "vpn"

                                Rectangle {
                                    width: parent.width
                                    height: 60
                                    color: "transparent"

                                    Rectangle {
                                        id: vpnBackButton
                                        width: 40
                                        height: 40
                                        radius: Local.Theme.radius.normal
                                        color: vpnBackMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                        border.width: Local.Theme.border.thick
                                        border.color: Local.Theme.border.color
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter

                                        Local.MaterialSymbol {
                                            icon: "arrow_back"
                                            iconSize: Local.Theme.font.huge
                                            color: Local.Theme.colors.foreground
                                            anchors.centerIn: parent
                                        }

                                        MouseArea {
                                            id: vpnBackMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: controlCenter.currentView = "main"
                                        }
                                    }

                                    Column {
                                        spacing: Local.Theme.spacing.small
                                        anchors.left: vpnBackButton.right
                                        anchors.leftMargin: Local.Theme.spacing.large
                                        anchors.verticalCenter: parent.verticalCenter

                                        Text {
                                            text: "VPN Settings"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.large
                                            color: Local.Theme.colors.foreground
                                        }

                                        Text {
                                            text: vpnModule.getDisplayText()
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.normal
                                            color: Local.Theme.colors.gray7
                                        }
                                    }

                                    Rectangle {
                                        id: vpnToggle
                                        width: 60
                                        height: 30
                                        radius: 15
                                        color: vpnModule.enabled ? Local.Theme.colors.foreground : Local.Theme.colors.gray3
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter

                                        Rectangle {
                                            width: 24
                                            height: 24
                                            radius: 12
                                            color: Local.Theme.colors.gray1
                                            anchors.verticalCenter: parent.verticalCenter
                                            x: vpnModule.enabled ? parent.width - width - 3 : 3

                                            Behavior on x {
                                                NumberAnimation {
                                                    duration: 200
                                                    easing.type: Easing.OutQuad
                                                }
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                vpnModule.toggleVPN();
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    width: parent.width
                                    height: 100
                                    radius: Local.Theme.radius.normal
                                    color: Local.Theme.colors.gray1
                                    border.width: Local.Theme.border.thick
                                    border.color: Local.Theme.border.color
                                    visible: vpnModule.enabled

                                    Column {
                                        anchors.fill: parent
                                        anchors.margins: Local.Theme.spacing.normal
                                        spacing: Local.Theme.spacing.small

                                        Text {
                                            text: "Connection Details"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.large
                                            font.weight: Font.Bold
                                            color: Local.Theme.colors.foreground
                                        }

                                        Text {
                                            text: "Server: " + (vpnModule.currentServer || "N/A")
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.normal
                                            color: Local.Theme.colors.gray7
                                        }

                                        Text {
                                            text: "Country: " + (vpnModule.currentCountry || "N/A")
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.normal
                                            color: Local.Theme.colors.gray7
                                        }
                                    }
                                }

                                Rectangle {
                                    width: parent.width
                                    height: 60
                                    radius: Local.Theme.radius.normal
                                    color: quickConnectMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                    border.width: Local.Theme.border.thick
                                    border.color: Local.Theme.border.color
                                    visible: !vpnModule.enabled

                                    Row {
                                        anchors.centerIn: parent
                                        spacing: Local.Theme.spacing.normal

                                        Local.MaterialSymbol {
                                            icon: "bolt"
                                            iconSize: 24
                                            color: Local.Theme.colors.foreground
                                            anchors.verticalCenter: parent.verticalCenter
                                        }

                                        Text {
                                            text: "Quick Connect"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.large
                                            font.weight: Font.Bold
                                            color: Local.Theme.colors.foreground
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                    }

                                    MouseArea {
                                        id: quickConnectMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            vpnModule.quickConnect();
                                        }
                                    }
                                }

                                Column {
                                    width: parent.width
                                    spacing: Local.Theme.spacing.normal
                                    visible: vpnModule.recentConnections.length > 0

                                    Text {
                                        text: "Recent Connections"
                                        font.family: Local.Theme.font.family
                                        font.pixelSize: Local.Theme.font.large
                                        font.weight: Font.Bold
                                        color: Local.Theme.colors.foreground
                                    }

                                    Repeater {
                                        model: vpnModule.recentConnections.slice(0, 3)

                                        Rectangle {
                                            required property var modelData
                                            required property int index

                                            width: parent.width
                                            height: 50
                                            radius: Local.Theme.radius.normal
                                            color: recentMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                            border.width: Local.Theme.border.thick
                                            border.color: Local.Theme.border.color

                                            Row {
                                                anchors.fill: parent
                                                anchors.margins: Local.Theme.spacing.normal
                                                spacing: Local.Theme.spacing.normal

                                                Local.MaterialSymbol {
                                                    icon: "public"
                                                    iconSize: 20
                                                    color: Local.Theme.colors.gray7
                                                    anchors.verticalCenter: parent.verticalCenter
                                                }

                                                Text {
                                                    text: modelData
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.large
                                                    color: Local.Theme.colors.foreground
                                                    anchors.verticalCenter: parent.verticalCenter
                                                }
                                            }

                                            MouseArea {
                                                id: recentMouse
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    vpnModule.connectToCountry(modelData);
                                                }
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    width: parent.width
                                    height: parent.height - 300
                                    radius: Local.Theme.radius.normal
                                    color: Local.Theme.colors.gray1
                                    border.width: Local.Theme.border.thick
                                    border.color: Local.Theme.border.color

                                    Column {
                                        anchors.fill: parent
                                        anchors.margins: Local.Theme.spacing.normal

                                        Text {
                                            text: "Available Countries"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.huge
                                            font.weight: Font.Bold
                                            color: Local.Theme.colors.foreground
                                            anchors.left: parent.left
                                            anchors.leftMargin: Local.Theme.spacing.small
                                            anchors.top: parent.top
                                            anchors.topMargin: Local.Theme.spacing.small
                                        }

                                        Rectangle {
                                            width: parent.width - Local.Theme.spacing.normal * 2
                                            height: 1
                                            color: Local.Theme.border.color
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.top: parent.top
                                            anchors.topMargin: 40
                                        }

                                        ScrollView {
                                            width: parent.width
                                            height: parent.height - 60
                                            anchors.top: parent.top
                                            anchors.topMargin: 50
                                            clip: true

                                            Column {
                                                width: Math.max(parent.width, 550)
                                                spacing: Local.Theme.spacing.small

                                                Text {
                                                    text: "Loading countries..."
                                                    font.family: Local.Theme.font.family
                                                    font.pixelSize: Local.Theme.font.normal
                                                    color: Local.Theme.colors.gray7
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    anchors.topMargin: Local.Theme.spacing.large
                                                    visible: !vpnModule.hasScannedOnce
                                                }

                                                Repeater {
                                                    model: vpnModule.hasScannedOnce ? vpnModule.availableCountries : []

                                                    Rectangle {
                                                        required property var modelData
                                                        required property int index

                                                        width: parent.width
                                                        height: 50
                                                        radius: Local.Theme.radius.normal
                                                        color: countryMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                                        border.width: Local.Theme.border.thick
                                                        border.color: Local.Theme.border.color

                                                        Row {
                                                            anchors.fill: parent
                                                            anchors.margins: Local.Theme.spacing.normal
                                                            spacing: Local.Theme.spacing.normal

                                                            Local.MaterialSymbol {
                                                                icon: "public"
                                                                iconSize: 20
                                                                color: modelData === vpnModule.currentCountry ? Local.Theme.colors.gray9 : Local.Theme.colors.gray7
                                                                anchors.verticalCenter: parent.verticalCenter
                                                            }

                                                            Text {
                                                                text: modelData
                                                                font.family: Local.Theme.font.family
                                                                font.pixelSize: Local.Theme.font.large
                                                                font.weight: modelData === vpnModule.currentCountry ? Font.Bold : Font.Normal
                                                                color: Local.Theme.colors.foreground
                                                                anchors.verticalCenter: parent.verticalCenter
                                                            }

                                                            Item {
                                                                width: parent.width - parent.children[0].width - parent.children[1].width - parent.spacing * 2
                                                                height: 1
                                                            }

                                                            Text {
                                                                text: modelData === vpnModule.currentCountry ? "Connected" : ""
                                                                font.family: Local.Theme.font.family
                                                                font.pixelSize: Local.Theme.font.normal
                                                                color: Local.Theme.colors.gray7
                                                                anchors.verticalCenter: parent.verticalCenter
                                                                visible: modelData === vpnModule.currentCountry
                                                            }
                                                        }

                                                        MouseArea {
                                                            id: countryMouse
                                                            anchors.fill: parent
                                                            hoverEnabled: modelData !== vpnModule.currentCountry
                                                            cursorShape: modelData === vpnModule.currentCountry ? Qt.ArrowCursor : Qt.PointingHandCursor
                                                            enabled: modelData !== vpnModule.currentCountry
                                                            onClicked: {
                                                                if (modelData !== vpnModule.currentCountry) {
                                                                    vpnModule.connectToCountry(modelData);
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            Column {
                                anchors.fill: parent
                                anchors.topMargin: Local.Theme.spacing.large
                                spacing: Local.Theme.spacing.large
                                visible: controlCenter.currentView === "protection"

                                Rectangle {
                                    width: parent.width
                                    height: 60
                                    color: "transparent"

                                    Rectangle {
                                        id: protectionBackButton
                                        width: 40
                                        height: 40
                                        radius: Local.Theme.radius.normal
                                        color: protectionBackMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                        border.width: Local.Theme.border.thick
                                        border.color: Local.Theme.border.color
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter

                                        Local.MaterialSymbol {
                                            icon: "arrow_back"
                                            iconSize: Local.Theme.font.huge
                                            color: Local.Theme.colors.foreground
                                            anchors.centerIn: parent
                                        }

                                        MouseArea {
                                            id: protectionBackMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: controlCenter.currentView = "main"
                                        }
                                    }

                                    Column {
                                        spacing: Local.Theme.spacing.small
                                        anchors.left: protectionBackButton.right
                                        anchors.leftMargin: Local.Theme.spacing.large
                                        anchors.verticalCenter: parent.verticalCenter

                                        Text {
                                            text: "Protection Settings"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.large
                                            color: Local.Theme.colors.foreground
                                        }

                                        Text {
                                            text: antivirusModule.getDisplayText()
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.normal
                                            color: Local.Theme.colors.gray7
                                        }
                                    }

                                    Rectangle {
                                        id: protectionToggle
                                        width: 60
                                        height: 30
                                        radius: 15
                                        color: antivirusModule.enabled ? Local.Theme.colors.foreground : Local.Theme.colors.gray3
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter

                                        Rectangle {
                                            width: 24
                                            height: 24
                                            radius: 12
                                            color: Local.Theme.colors.gray1
                                            anchors.verticalCenter: parent.verticalCenter
                                            x: antivirusModule.enabled ? parent.width - width - 3 : 3

                                            Behavior on x {
                                                NumberAnimation {
                                                    duration: 200
                                                    easing.type: Easing.OutQuad
                                                }
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                antivirusModule.toggleProtection();
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    width: parent.width
                                    height: 120
                                    radius: Local.Theme.radius.normal
                                    color: Local.Theme.colors.gray1
                                    border.width: Local.Theme.border.thick
                                    border.color: Local.Theme.border.color
                                    visible: antivirusModule.enabled

                                    Column {
                                        anchors.fill: parent
                                        anchors.margins: Local.Theme.spacing.normal
                                        spacing: Local.Theme.spacing.small

                                        Text {
                                            text: "Protection Status"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.large
                                            font.weight: Font.Bold
                                            color: Local.Theme.colors.foreground
                                        }

                                        Text {
                                            text: "Last Scan: " + (antivirusModule.lastScanDate || "Never")
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.normal
                                            color: Local.Theme.colors.gray7
                                        }

                                        Text {
                                            text: "Definitions: " + (antivirusModule.virusDefinitionDate || "Unknown")
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.normal
                                            color: Local.Theme.colors.gray7
                                        }
                                    }
                                }

                                Rectangle {
                                    width: parent.width
                                    height: 140
                                    radius: Local.Theme.radius.normal
                                    color: Local.Theme.colors.gray1
                                    border.width: Local.Theme.border.thick
                                    border.color: Local.Theme.border.color

                                    Row {
                                        anchors.centerIn: parent
                                        spacing: Local.Theme.spacing.large

                                        Rectangle {
                                            width: 200
                                            height: 50
                                            color: scanButtonMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                            radius: Local.Theme.radius.normal
                                            border.width: Local.Theme.border.thick
                                            border.color: Local.Theme.border.color

                                            Text {
                                                text: antivirusModule.isScanning ? "Scanning..." : "Quick Scan"
                                                font.family: Local.Theme.font.family
                                                font.pixelSize: Local.Theme.font.normal
                                                color: Local.Theme.colors.foreground
                                                anchors.centerIn: parent
                                            }

                                            MouseArea {
                                                id: scanButtonMouse
                                                anchors.fill: parent
                                                enabled: !antivirusModule.isScanning
                                                hoverEnabled: !antivirusModule.isScanning
                                                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                                onClicked: {
                                                    antivirusModule.quickScan();
                                                }
                                            }
                                        }

                                        Rectangle {
                                            width: 200
                                            height: 50
                                            color: updateButtonMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                            radius: Local.Theme.radius.normal
                                            border.width: Local.Theme.border.thick
                                            border.color: Local.Theme.border.color

                                            Text {
                                                text: "Update Definitions"
                                                font.family: Local.Theme.font.family
                                                font.pixelSize: Local.Theme.font.normal
                                                color: Local.Theme.colors.foreground
                                                anchors.centerIn: parent
                                            }

                                            MouseArea {
                                                id: updateButtonMouse
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    antivirusModule.updateVirusDefinitions();
                                                }
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    width: parent.width
                                    height: 60
                                    radius: Local.Theme.radius.normal
                                    color: Local.Theme.colors.gray1
                                    border.width: Local.Theme.border.thick
                                    border.color: Local.Theme.border.color
                                    visible: antivirusModule.isScanning

                                    Column {
                                        anchors.centerIn: parent
                                        spacing: Local.Theme.spacing.small

                                        Text {
                                            text: "Scan Progress"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.normal
                                            color: Local.Theme.colors.foreground
                                            anchors.horizontalCenter: parent.horizontalCenter
                                        }

                                        Text {
                                            text: antivirusModule.scanProgress || "Starting scan..."
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.small
                                            color: Local.Theme.colors.gray7
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            width: 400
                                            wrapMode: Text.WordWrap
                                            maximumLineCount: 1
                                            elide: Text.ElideRight
                                        }
                                    }
                                }
                            }

                            Column {
                                anchors.fill: parent
                                anchors.topMargin: Local.Theme.spacing.large
                                spacing: Local.Theme.spacing.large
                                visible: controlCenter.currentView === "output"

                                Rectangle {
                                    width: parent.width
                                    height: 60
                                    color: "transparent"
                                    
                                    Rectangle {
                                        id: audioOutputBackButton
                                        width: 40
                                        height: 40
                                        radius: Local.Theme.radius.normal
                                        color: audioOutputBackMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                        border.width: Local.Theme.border.thick
                                        border.color: Local.Theme.border.color
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        
                                        Local.MaterialSymbol {
                                            icon: "arrow_back"
                                            iconSize: Local.Theme.font.huge
                                            color: Local.Theme.colors.foreground
                                            anchors.centerIn: parent
                                        }
                                        
                                        MouseArea {
                                            id: audioOutputBackMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: controlCenter.currentView = "main"
                                        }
                                    }
                                    
                                    Column {
                                        spacing: Local.Theme.spacing.small
                                        anchors.left: audioOutputBackButton.right
                                        anchors.leftMargin: Local.Theme.spacing.large
                                        anchors.verticalCenter: parent.verticalCenter
                                        
                                        Text {
                                            text: "Audio Output Devices"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.large
                                            font.weight: Font.Bold
                                            color: Local.Theme.colors.foreground
                                        }
                                        
                                        Text {
                                            text: audioOutputModule.currentDevice || "No device selected"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.normal
                                            color: Local.Theme.colors.gray7
                                        }
                                    }
                                }
                                
                                Rectangle {
                                    width: parent.width
                                    height: parent.height - 80
                                    radius: Local.Theme.radius.normal
                                    color: Local.Theme.colors.gray1
                                    border.width: Local.Theme.border.thick
                                    border.color: Local.Theme.border.color
                                    
                                    Column {
                                        anchors.fill: parent
                                        anchors.margins: Local.Theme.spacing.normal
                                        spacing: Local.Theme.spacing.normal
                                        
                                        Text {
                                            text: "Available devices"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.huge
                                            font.weight: Font.Bold
                                            color: Local.Theme.colors.foreground
                                        }
                                        
                                        Column {
                                            width: parent.width
                                            spacing: Local.Theme.spacing.small
                                        
                                            Repeater {
                                                model: audioOutputModule.devices
                                                
                                                Rectangle {
                                                    width: parent.width
                                                    height: 70
                                                    radius: Local.Theme.radius.small
                                                    color: modelData.isDefault ? Local.Theme.colors.gray9 : 
                                                           (outputDeviceMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2)
                                                
                                                    Row {
                                                        anchors.left: parent.left
                                                        anchors.leftMargin: Local.Theme.spacing.large
                                                        anchors.verticalCenter: parent.verticalCenter
                                                        spacing: Local.Theme.spacing.normal
                                                        
                                                        Local.MaterialSymbol {
                                                            icon: modelData.isDefault ? "check_circle" : "volume_up"
                                                            iconSize: 28
                                                            color: modelData.isDefault ? Local.Theme.colors.gray0 : Local.Theme.colors.foreground
                                                            anchors.verticalCenter: parent.verticalCenter
                                                        }
                                                        
                                                        Column {
                                                            spacing: Local.Theme.spacing.tiny
                                                            anchors.verticalCenter: parent.verticalCenter
                                                            
                                                            Text {
                                                                text: modelData.name
                                                                font.family: Local.Theme.font.family
                                                                font.pixelSize: Local.Theme.font.normal
                                                                font.weight: modelData.isDefault ? Font.Bold : Font.Normal
                                                                color: modelData.isDefault ? Local.Theme.colors.gray0 : Local.Theme.colors.foreground
                                                            }
                                                            
                                                            Text {
                                                                text: "Volume: " + modelData.volume + "%"
                                                                font.family: Local.Theme.font.family
                                                                font.pixelSize: Local.Theme.font.small
                                                                color: modelData.isDefault ? Local.Theme.colors.gray0 : Local.Theme.colors.gray7
                                                            }
                                                        }
                                                    }
                                                    
                                                    MouseArea {
                                                        id: outputDeviceMouse
                                                        anchors.fill: parent
                                                        hoverEnabled: true
                                                        cursorShape: Qt.PointingHandCursor
                                                        onClicked: {
                                                            if (!modelData.isDefault) {
                                                                audioOutputModule.setDevice(modelData.id);
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            Column {
                                anchors.fill: parent
                                anchors.topMargin: Local.Theme.spacing.large
                                spacing: Local.Theme.spacing.large
                                visible: controlCenter.currentView === "input"

                                Rectangle {
                                    width: parent.width
                                    height: 60
                                    color: "transparent"
                                    
                                    Rectangle {
                                        id: audioInputBackButton
                                        width: 40
                                        height: 40
                                        radius: Local.Theme.radius.normal
                                        color: audioInputBackMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2
                                        border.width: Local.Theme.border.thick
                                        border.color: Local.Theme.border.color
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        
                                        Local.MaterialSymbol {
                                            icon: "arrow_back"
                                            iconSize: Local.Theme.font.huge
                                            color: Local.Theme.colors.foreground
                                            anchors.centerIn: parent
                                        }
                                        
                                        MouseArea {
                                            id: audioInputBackMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: controlCenter.currentView = "main"
                                        }
                                    }
                                    
                                    Column {
                                        spacing: Local.Theme.spacing.small
                                        anchors.left: audioInputBackButton.right
                                        anchors.leftMargin: Local.Theme.spacing.large
                                        anchors.verticalCenter: parent.verticalCenter
                                        
                                        Text {
                                            text: "Audio Input Devices"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.large
                                            font.weight: Font.Bold
                                            color: Local.Theme.colors.foreground
                                        }
                                        
                                        Text {
                                            text: audioInputModule.currentDevice || "No device selected"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.normal
                                            color: Local.Theme.colors.gray7
                                        }
                                    }
                                }
                                
                                Rectangle {
                                    width: parent.width
                                    height: parent.height - 80
                                    radius: Local.Theme.radius.normal
                                    color: Local.Theme.colors.gray1
                                    border.width: Local.Theme.border.thick
                                    border.color: Local.Theme.border.color
                                    
                                    Column {
                                        anchors.fill: parent
                                        anchors.margins: Local.Theme.spacing.normal
                                        spacing: Local.Theme.spacing.normal
                                        
                                        Text {
                                            text: "Available devices"
                                            font.family: Local.Theme.font.family
                                            font.pixelSize: Local.Theme.font.huge
                                            font.weight: Font.Bold
                                            color: Local.Theme.colors.foreground
                                        }
                                        
                                        Column {
                                            width: parent.width
                                            spacing: Local.Theme.spacing.small
                                        
                                            Repeater {
                                                model: audioInputModule.devices
                                                
                                                Rectangle {
                                                    width: parent.width
                                                    height: 70
                                                    radius: Local.Theme.radius.small
                                                    color: modelData.isDefault ? Local.Theme.colors.gray9 : 
                                                           (inputDeviceMouse.containsMouse ? Local.Theme.colors.gray3 : Local.Theme.colors.gray2)
                                                
                                                Row {
                                                    anchors.left: parent.left
                                                    anchors.leftMargin: Local.Theme.spacing.large
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    spacing: Local.Theme.spacing.normal
                                                    
                                                    Local.MaterialSymbol {
                                                        icon: modelData.isDefault ? "check_circle" : "mic"
                                                        iconSize: 28
                                                        color: modelData.isDefault ? Local.Theme.colors.gray0 : Local.Theme.colors.foreground
                                                        anchors.verticalCenter: parent.verticalCenter
                                                    }
                                                    
                                                    Column {
                                                        spacing: Local.Theme.spacing.tiny
                                                        anchors.verticalCenter: parent.verticalCenter
                                                        
                                                        Text {
                                                            text: modelData.name
                                                            font.family: Local.Theme.font.family
                                                            font.pixelSize: Local.Theme.font.normal
                                                            font.weight: modelData.isDefault ? Font.Bold : Font.Normal
                                                            color: modelData.isDefault ? Local.Theme.colors.gray0 : Local.Theme.colors.foreground
                                                        }
                                                        
                                                        Text {
                                                            text: modelData.muted ? "Muted" : ("Volume: " + modelData.volume + "%")
                                                            font.family: Local.Theme.font.family
                                                            font.pixelSize: Local.Theme.font.small
                                                            color: modelData.isDefault ? Local.Theme.colors.gray0 : Local.Theme.colors.gray7
                                                        }
                                                    }
                                                }
                                                
                                                MouseArea {
                                                    id: inputDeviceMouse
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: {
                                                        if (!modelData.isDefault) {
                                                            audioInputModule.setDevice(modelData.id);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Loader {
        active: controlCenter.isVisible
        sourceComponent: Component {
            PanelWindow {
                WlrLayershell.layer: WlrLayer.Overlay
                anchors {
                    left: true
                    right: true
                    top: true
                    bottom: true
                }

                color: "transparent"

                MouseArea {
                    anchors.fill: parent
                    anchors.rightMargin: 410
                    onClicked: controlCenter.hide()
                }
            }
        }
    }

    Window {
        id: passwordWindow
        width: 400
        height: 180
        visible: false
        flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
        color: "transparent"
        
        onVisibleChanged: {
            if (visible) {
                // Center of screen
                x = (Screen.primaryScreen ? Screen.primaryScreen.width : 1920) / 2 - width / 2;
                y = (Screen.primaryScreen ? Screen.primaryScreen.height : 1080) / 2 - height / 2;
                
                // Focus and clear the input
                dialogPasswordInput.text = "";
                dialogPasswordInput.forceActiveFocus();
            }
        }

        Rectangle {
            anchors.fill: parent
            color: Local.Theme.panelBackground
            radius: Local.Theme.radius.normal
            border.width: Local.Theme.border.thick
            border.color: Local.Theme.border.color
            
            Rectangle {
                anchors.fill: parent
                anchors.margins: -5
                color: "black"
                opacity: 0.2
                radius: Local.Theme.radius.normal + 5
                z: -1
            }

            Column {
                anchors.fill: parent
                anchors.margins: Local.Theme.spacing.large
                spacing: Local.Theme.spacing.large

                Text {
                    text: "Connect to " + selectedNetwork
                    font.family: Local.Theme.font.family
                    font.pixelSize: Local.Theme.font.large
                    font.weight: Font.Bold
                    color: Local.Theme.colors.foreground
                }

                Rectangle {
                    width: parent.width
                    height: 40
                    radius: Local.Theme.radius.small
                    color: Local.Theme.colors.gray2
                    border.width: Local.Theme.border.thick
                    border.color: Local.Theme.border.color

                    TextInput {
                        id: dialogPasswordInput
                        anchors.fill: parent
                        anchors.margins: Local.Theme.spacing.normal
                        font.family: Local.Theme.font.family
                        font.pixelSize: Local.Theme.font.normal
                        color: Local.Theme.colors.foreground
                        echoMode: TextInput.Password
                        selectByMouse: true
                        focus: true

                        Keys.onReturnPressed: {
                            wifiModule.connectToNetwork(selectedNetwork, text);
                        }

                        Keys.onEscapePressed: {
                            passwordWindow.visible = false;
                        }
                    }
                }

                Row {
                    width: parent.width
                    spacing: Local.Theme.spacing.normal

                    Rectangle {
                        width: (parent.width - parent.spacing) / 2
                        height: 35
                        radius: Local.Theme.radius.small
                        color: Local.Theme.colors.gray2
                        border.width: Local.Theme.border.thick
                        border.color: Local.Theme.border.color

                        Text {
                            text: "Cancel"
                            font.family: Local.Theme.font.family
                            font.pixelSize: Local.Theme.font.normal
                            color: Local.Theme.colors.foreground
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                passwordWindow.visible = false;
                            }
                        }
                    }

                    Rectangle {
                        width: (parent.width - parent.spacing) / 2
                        height: 35
                        radius: Local.Theme.radius.small
                        color: Local.Theme.colors.gray2
                        border.width: Local.Theme.border.thick
                        border.color: Local.Theme.border.color

                        Text {
                            text: "Connect"
                            font.family: Local.Theme.font.family
                            font.pixelSize: Local.Theme.font.normal
                            color: Local.Theme.colors.foreground
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                wifiModule.connectToNetwork(selectedNetwork, dialogPasswordInput.text);
                            }
                        }
                    }
                }
            }
        }
    }
    }
}
