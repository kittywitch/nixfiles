pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root
  readonly property string time: {
    Qt.formatDateTime(clock.date, "yyyy-MM-dd hh:mm:ss t")
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}
