import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "root:/DataSources"
import "root:/Helpers"
import Quickshell.Services.Notifications

Item {
  id: root
  Layout.alignment: Qt.AlignVCenter;
  implicitWidth: 30
  implicitHeight: parent.height
  Rectangle {
    anchors.centerIn: parent
    id: rootContainer
    color: "transparent"
    width: 60
    height: 30
    radius: 50
    RowLayout {
      spacing: 5
      anchors.centerIn: parent
      Text {
        verticalAlignment: Text.AlignVCenter
        id: rootIcon
        text: ""
        color: Stylix.base05
      }
      Text {
        verticalAlignment: Text.AlignVCenter
        id: count
        text: ""
        font.bold: true
        color: Stylix.base05
      }
    }
  }
  function updateDisplay() {
    if (Notifications.list.length > 0) {
      rootContainer.color = Stylix.base08
      rootIcon.color = Stylix.base00
      count.color = Stylix.base00
      count.text = Notifications.list.length
      rootContainer.width = 60
      root.implicitWidth = 60
      count.visible = true
    } else {
      rootContainer.width = 30
      root.implicitWidth = 30
      rootContainer.color = "transparent"
      rootIcon.color = Stylix.base05
      count.color = Stylix.base05
      count.visible = false
    }
  }
  Timer {
    interval: 1000
    running:  true
    repeat: true
    onTriggered: root.updateDisplay()
  }
  MouseArea {
    id: ma
    anchors.fill: parent
    hoverEnabled: true

    onClicked: function(mouseEvent) {
      var m = root.QsWindow.mapFromItem(ma, ma.width/2.0, ma.height/2.0);
      var offset = notificationLoader.item.width / 2.0;
      notificationLoader.item.clicky = m.x - offset;
      notificationLoader.item.visible = !notificationLoader.item.visible
    }
  }

  NotificationWindow {
    id: notificationLoader
  }
}
