import QtQuick
import Quickshell
import "." as Local

ShellRoot {
    id: shellRoot
    
    signal toggleControlCenter()
    signal openControlCenterWithView(string view)
    
    Local.VolumeOsd {}
    Variants {
        model: Quickshell.screens

        Local.TopBar {
            required property var modelData
            screen: modelData
            onToggleControlCenter: shellRoot.toggleControlCenter()
            onOpenControlCenterWithView: view => shellRoot.openControlCenterWithView(view)
        }
    }
    
    Loader {
        active: Local.NotificationService.hasActivePopups && !Local.DNDState.enabled
        sourceComponent: Local.NotificationArea {}
    }
    
    Local.ControlCenter {
        id: controlCenter
        
        Component.onCompleted: {
            shellRoot.toggleControlCenter.connect(function() {
                if (controlCenter.isVisible) {
                    controlCenter.hide();
                } else {
                    controlCenter.show();
                }
            });
            
            shellRoot.openControlCenterWithView.connect(function(view) {
                if (controlCenter.isVisible && controlCenter.currentView === view) {
                    controlCenter.hide();
                } else {
                    controlCenter.currentView = view;
                    if (!controlCenter.isVisible) {
                        controlCenter.show();
                    }
                }
            });
        }
    }
    
}
