import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import "root:/DataSources"

Item {
  width: parent.width
  height: 2

  Rectangle {
    anchors {
      fill: parent
      leftMargin: 5
      rightMargin: 5
    }
    color: Stylix.base00
    radius: 5
  }
}
