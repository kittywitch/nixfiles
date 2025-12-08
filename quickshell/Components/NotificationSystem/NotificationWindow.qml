import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "root:/DataSources"
import "root:/Helpers"
import Quickshell.Services.Notifications

LazyLoader {
  id: notificationLoader

  loading: true

  PopupWindow {
    property real clicky
    id: wrapperPopup
    visible: false
    anchor.window: root.QsWindow.window
    anchor.rect.y: parentWindow?.height ?? 0
    anchor.rect.x: clicky
    color: "transparent"

    implicitWidth: 450
    implicitHeight: 600

    Rectangle {
      anchors.fill: parent
      color: Stylix.base01
      bottomLeftRadius: 5
      bottomRightRadius: 5
      ColumnLayout {
        anchors.fill: parent
        NotificationWindowHeader {
          Layout.topMargin: 5
          Layout.bottomMargin: 5
        }
        ClippingRectangle {
          color: "transparent"
          Layout.alignment: Qt.AlignBottom
          Layout.preferredWidth: parent.width
          Layout.preferredHeight: parent.height - 34
          ListView {
            cacheBuffer: 30
            anchors.fill: parent
            id: notificationList
            model: Notifications.list
            spacing: 10
            ScrollBar.vertical: ScrollBar {}

            delegate: NotificationItem {}
          }
        }
      }
    }
  }
}
