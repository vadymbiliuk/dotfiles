import QtQuick
import "." as Local

Item {
    id: dndModule

    property bool enabled: Local.DNDState.enabled

    function getDisplayText() {
        if (!enabled) return "Inactive";
        return Local.DNDState.profile === "work" ? "Work mode" : "Silent";
    }

    function toggle() {
        Local.DNDState.toggle();
    }
}