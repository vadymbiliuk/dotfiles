pragma Singleton
import QtQuick
import Quickshell

QtObject {
    property bool visible: false
    property string type: ""  // "volume" or "brightness"
    property int value: 0
    property bool muted: false

    property Timer hideTimer: Timer {
        interval: 2000
        onTriggered: visible = false
    }

    function showVolume(vol, isMuted) {
        type = "volume";
        value = vol;
        muted = isMuted;
        visible = true;
        hideTimer.restart();
    }

    function showBrightness(brightness) {
        type = "brightness";
        value = brightness;
        muted = false;
        visible = true;
        hideTimer.restart();
    }
}
