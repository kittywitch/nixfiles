pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

Singleton {
  id: root

  NotificationServer {
    id: notificationServer
    imageSupported: true
    bodySupported: true
    bodyMarkupSupported: false
    bodyImagesSupported: false
    actionsSupported: true
    onNotification: (notification) => {
      notification.tracked = true;
      root.notification(notification);
    }
  }
  function clear(): void {
    for (const notification of notificationServer.trackedNotifications.values) {
      notification.tracked = false;
    }
  }

  // TODO: use signal
  property list<Notification> list: notificationServer.trackedNotifications.values.filter(notification => notification.tracked)
  signal notification(Notification notification)

  IpcHandler {
    target: "notifications"
    function clear() {
      root.clear()
    }
  }
}
