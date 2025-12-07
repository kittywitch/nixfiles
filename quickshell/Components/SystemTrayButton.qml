import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import "root:/DataSources"

Item {
  required property QsMenuHandle modelData

  width: parent.width
  height: 30

  property real text_point_size: 12
  property real length: width / text_point_size

  Rectangle {
    anchors {
      fill: parent
      leftMargin: 10
      rightMargin: 10
    }

    color: Stylix.base01
    radius: 5

    Text {
      anchors {
        centerIn: parent
      }
      width: parent.width - 10
      horizontalAlignment: Text.AlignHCenter
      text: modelData?.text ?? ""
      color: Stylix.base05
      font.pointSize: text_point_size
      elide: Text.ElideRight
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true

      onClicked: mouse => {
        modelData.triggered();
        popup.visible = false;
      }
    }
  }
}
