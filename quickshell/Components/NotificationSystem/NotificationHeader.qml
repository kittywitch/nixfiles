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
  required property Notification modelData_
  IconImage {
    function getIcon() {
      if (modelData_.appIcon != "") {
        return Quickshell.iconPath(modelData_.appIcon.replace("file://", ""))
      } else {
        return ThemeIcons.iconForAppId(modelData_.appName)
      }
    }
    width: 24
    height: 24
    visible: source != ""
    source: getIcon()
  }
  Text {
    font.bold: true
    elide: Text.ElideRight
    text: modelData_.summary
    color: Stylix.base05
  }
  Text {
    id: dismiss
    text: "󱏩"
    color: Stylix.base08
    font.pixelSize: 16

    ToolTip {
      id: dismissTooltip
      visible: false
      delay: 500
      timeout: 1000
      text: "Dismiss notification"
    }

    HoverHandler {
      id: dismissHover
      onHoveredChanged: {
        dismissTooltip.visible = hovered
      }
    }

    Layout.topMargin: 5
    Layout.rightMargin: 10

    MouseArea {
      anchors.fill: parent
      onClicked: {
        modelData_.dismiss();
        if (Notifications.list.length <= 0) {
          popup.visible = false;
        }
      }
    }
  }
}
