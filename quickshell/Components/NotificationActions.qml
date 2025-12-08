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

  Layout.minimumHeight: 0
  Layout.preferredHeight: modelData_.actions != [] ? 30 : 0
  visible: modelData_.actions != []
  spacing: 5
  Repeater {
    model: modelData_.actions

    Item {
      required property NotificationAction actionData

      width: 100
      height: 30

      anchors {
        left: parent.left
        leftMargin: 5
        top: parent.top
        topMargin: 5
      }

      Rectangle {
        anchors.fill: parent
        color: Stylix.base02
        radius: 5

        Text {
          text: actionData.text
          color: Stylix.base05
          font.pixelSize: 12

          anchors {
            left: parent.left
            leftMargin: 10
            verticalCenter: parent.verticalCenter
          }
        }

        MouseArea {
          anchors.fill: parent
          onClicked: actionData.invoke()
        }
      }
    }
  }
}
