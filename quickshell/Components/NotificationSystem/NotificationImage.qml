import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "root:/DataSources"
import "root:/Helpers"
import Quickshell.Services.Notifications


ClippingWrapperRectangle {
  required property string image
  radius: 5
  Layout.preferredWidth: visible ? 80 : 0
  Layout.preferredHeight: visible ? parent.height : 0
  visible: image != ""
  color: Stylix.base00
  Image {
    fillMode: Image.PreserveAspectFit
    Layout.preferredWidth: 80
    Layout.preferredHeight: parent.height
    source: image.replace("file://", "")
  }
}
