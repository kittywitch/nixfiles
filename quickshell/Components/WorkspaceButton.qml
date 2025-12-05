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
      return Settings.base0F
    }
    if (modelData.isFocused) {
      return Settings.base0E
    }
    if (modelData.isActive) {
      return Settings.base0C
    }
    if (modelData.activeWindowId > 0) {
      return Settings.base0F
    }
    return Settings.lighterBg
  }

  visible: isVisible
  implicitHeight: 25
  implicitWidth: gen_width()

  Rectangle {
    anchors.fill: parent
    color: get_color()
    radius: 5

    Text {
      anchors.centerIn: parent
      color: Settings.defaultBg
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
