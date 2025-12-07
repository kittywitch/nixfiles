import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/DataSources"

Item {
  id: root
  Layout.alignment: Qt.AlignVCenter;
  implicitWidth: 25
  implicitHeight: parent.height
  Text {
    id: texty
    anchors.centerIn: parent
    text: ""
    color: Stylix.base05
  }
  MouseArea {
    id: ma
    anchors.fill: parent
    hoverEnabled: true

    onClicked: function(mouseEvent) {
      var m = root.QsWindow.mapFromItem(ma, ma.width/2.0, ma.height/2.0);
      var offset = wrapperPopup.width / 2.0;
      wrapperPopup.clicky = m.x - offset;
      wrapperPopup.visible = !wrapperPopup.visible
    }
  }
  PopupWindow {
    property real clicky
    id: wrapperPopup
    anchor.window: root.QsWindow.window
    anchor.rect.y: parentWindow.height
    anchor.rect.x: clicky
    width: systray.width + 10
    height: systray.height + 10
    Rectangle {
      anchors.fill: parent
      color: Stylix.base01
      SystemTray {
        id: systray
      }
    }
  }
}
