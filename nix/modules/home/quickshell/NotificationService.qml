pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import "." as Local

QtObject {
    property list<QtObject> notifications: []
    property list<QtObject> notificationHistory: []
    property list<QtObject> activePopups: {
        let popups = [];
        for (let i = 0; i < notifications.length; i++) {
            if (notifications[i].popup) {
                popups.push(notifications[i]);
            }
        }
        return popups;
    }
    property bool hasActivePopups: activePopups.length > 0

    property NotificationServer server: NotificationServer {
        keepOnReload: false
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        imageSupported: true

        onNotification: notif => {
            notif.tracked = true;

            var notifObj = notifComp.createObject(null, {
                notification: notif,
                popup: !Local.DNDState.enabled,
                shown: false
            });

            notifications.push(notifObj);
            notificationHistory.push(notifObj);
        }
    }

    function removeNotification(notifObj) {
        const index = notifications.indexOf(notifObj);
        if (index >= 0) {
            notifications.splice(index, 1);
        }
    }

    function clearAll() {
        notifications = [];
    }

    function clearHistory() {
        notificationHistory = [];
    }

    function removeFromHistory(index) {
        if (index >= 0 && index < notificationHistory.length) {
            notificationHistory.splice(index, 1);
        }
    }

    property Component notifComp: Component {
        QtObject {
            id: notifItem
            property bool popup
            property bool shown
            required property var notification

            readonly property string summary: notification.summary
            readonly property string body: notification.body
            readonly property string appName: notification.appName
            readonly property string appIcon: notification.appIcon
            readonly property string image: notification.image
            readonly property int urgency: notification.urgency
            readonly property int id: notification.id
            readonly property var actions: notification.actions

            property Timer timer: Timer {
                running: popup
                interval: notification.expireTimeout > 0 ? notification.expireTimeout : 5000
                onTriggered: {
                    popup = false;
                }
            }

            property Connections conn: Connections {
                target: notification

                function onClosed(reason) {
                    removeNotification(notifItem);
                }
            }
        }
    }
}
