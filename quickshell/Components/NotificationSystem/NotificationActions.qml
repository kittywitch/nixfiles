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
  Layout.preferredHeight: modelData_.actions.length > 0 ? 30 : 0
  visible: modelData_.actions.length > 0
  spacing: 5
  Repeater {
    model: modelData_.actions

    delegate: Item {
      required property NotificationAction modelData

      width: 100
      height: 30

      Rectangle {
        anchors.fill: parent
        color: Stylix.base00
        radius: 5

        Text {
          text: modelData.text
          color: Stylix.base05
          anchors.centerIn: parent
          font.pixelSize: 12

          anchors {
            left: parent.left
            leftMargin: 10
            verticalCenter: parent.verticalCenter
          }
        }

        MouseArea {
          anchors.fill: parent
          onClicked: modelData.invoke()
        }
      }
    }
  }
}
