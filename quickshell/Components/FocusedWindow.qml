import QtQuick
import QtQuick.Layouts
import Quickshell
import Niri 0.1
import "root:/DataSources"
import "root:/Helpers"

RowLayout {
  id: root
  property string title: niri.focusedWindow?.title ?? ""
  property string icon_path: get_icon()
  property string app_id: get_app_id()

  function get_app_id() {
    var app_id = niri.focusedWindow?.appId;
    return app_id ?? ""
  }

  function get_icon() {
    var icon = ThemeIcons.iconForAppId(app_id);
    if (icon && icon !== "") {
      return icon
    }
  }

  visible: title != ""
  spacing: 10

  Image {
    Layout.alignment: Qt.AlignVCenter;
    source: icon_path
    sourceSize.width: 24
    sourceSize.height: 24
    smooth: true
  }

  Item {
    Layout.alignment: Qt.AlignVCenter;
    implicitWidth: 300
    height: parent.height
    Text {
      anchors {
        centerIn: parent
      }
      verticalAlignment: Text.AlignVCenter;
      width: parent.width
      text: title
      color: Stylix.base05
      elide: Text.ElideRight
    }
  }
}
