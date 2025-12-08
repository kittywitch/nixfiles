import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "root:/DataSources"
import "root:/Helpers"
import Quickshell.Services.Notifications

RowLayout {
  Layout.alignment: Qt.AlignHCenter
  spacing: 10
  Text {
    font.bold: true
    Layout.preferredHeight: 26
    Layout.alignment: Qt.AlignVCenter
    verticalAlignment: Text.AlignVCenter
    text: "Notifications"
    color: Stylix.base05
    font.pixelSize: 16
  }
  Text {
    Layout.preferredHeight: 26
    Layout.alignment: Qt.AlignVCenter
    verticalAlignment: Text.AlignBottom
    id: clear
    text: "󱏧"
    color: Stylix.base08
    font.pixelSize: 16
    ToolTip {
      id: clearTooltip
      visible: false
      delay: 500
      timeout: 1000
      text: "Clear notifications"
    }
    MouseArea {
      anchors.fill: parent
      onClicked: {
        if (Notifications.list.length >= 0) {
          Notifications.clear()
          root.updateDisplay()
        }
      }
    }
    HoverHandler {
      id: clearHover
      onHoveredChanged: {
        clearTooltip.visible = hovered
      }
    }
  }
}
