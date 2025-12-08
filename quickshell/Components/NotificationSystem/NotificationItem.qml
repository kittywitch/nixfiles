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
  required property Notification modelData

  function calculateHeight() {
    if (modelData.actions.length > 0) {
      return 150
    } else if (modelData.image != "") {
      return 100
    } else {
      return 60
    }
  }

  function calculateBodyHeight() {
    if (modelData.image != "" || modelData.actions.length > 0) {
      return 40
    } else {
      return 20
    }
  }

  height: calculateHeight()
  width: 450

  Rectangle {
    id: indivNotif
    color: Stylix.base02
    radius: 5
    anchors {
      fill: parent
      leftMargin: 5
      rightMargin: 5
    }
    RowLayout {
      anchors {
        fill: parent
      }
      NotificationImage {
        image: modelData.image
      }
      ColumnLayout {
        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: 5
        Layout.rightMargin: 5
        Layout.fillWidth: true
        NotificationHeader {
          modelData_: modelData
        }
        Text {
          font.pointSize: 10
          wrapMode: Text.WordWrap
          Layout.fillWidth: true
          Layout.preferredWidth: modelData.image != "" ? indivNotif.width - 80 : indivNotif.width
          Layout.maximumHeight: calculateBodyHeight()
          Layout.maximumWidth: indivNotif.width
          elide: Text.ElideRight
          text: modelData.body
          color: Stylix.base05
        }
        NotificationActions {
          modelData_: modelData
        }
      }
    }
  }
}
