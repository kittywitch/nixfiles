import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/DataSources"

Item {
  id: root
  Layout.alignment: Qt.AlignVCenter;
  implicitWidth: 25
  implicitHeight: parent.height
  property list<string> textStates: ["", ""]
  Text {
    id: texty
    anchors.centerIn: parent
    text: textStates[0]
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
      wrapperPopup.visible = !wrapperPopup.visible;

      texty.text = root.textStates[wrapperPopup.visible ? 1 : 0];
    }
  }
  PopupWindow {
    property real clicky
    id: wrapperPopup
    anchor.window: root.QsWindow.window
    anchor.rect.y: parentWindow.height
    anchor.rect.x: clicky
    implicitWidth: systray.width + 10
    implicitHeight: systray.height + 10
    color: "transparent"
    Rectangle {
      anchors.fill: parent
      color: Stylix.base01
      bottomLeftRadius: 5
      bottomRightRadius: 5
      SystemTray {
        id: systray
      }
    }
  }
}
