import QtQuick
import QtQuick.Layouts
import "root:/DataSources"

Item {
  property var modelData
  property var screenData

  property int index: modelData.index
  property string name: modelData.name
  property string generated_name: gen_text()
  property bool isVisible: modelData.output == screenData.name

  id: root

  function gen_text() {
    if (name.length == 0) {
      return index
    } else {
      return name
    }
  }

  function gen_width() {
    if (isVisible) {
      return 10 + (generated_name.length * 15)
    } else {
      return 0
    }
  }

  function get_color() {
    if (modelData.isUrgent) {
      return [Stylix.base08, Stylix.base00]
    }
    if (modelData.isFocused) {
      return [Stylix.base0F, Stylix.base00]
    }
    if (modelData.isActive) {
      return [Stylix.base0C, Stylix.base00]
    }
    if (modelData.activeWindowId > 0) {
      return [Stylix.base0D, Stylix.base00]
    }
    return [Stylix.base02, Stylix.base04]
  }

  property var colors: get_color()
  property color bg: root.colors[0]
  property color fg: root.colors[1]

  visible: isVisible
  implicitHeight: 25
  implicitWidth: gen_width()

  Rectangle {
    anchors.fill: parent
    color: bg
    radius: 5

    Text {
      anchors.centerIn: parent
      verticalAlignment: Text.AlignVCenter;
      color: fg
      text: gen_text()
      font.pixelSize: 20
    }

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: niri.focusWorkspaceById(modelData.id)
    }
  }
}
