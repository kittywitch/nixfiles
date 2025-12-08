import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "root:/DataSources"
import "root:/Components"

Scope {
  id: root

  Variants {
    model: Quickshell.screens

    PanelWindow {
      property var modelData
      screen: modelData
      implicitHeight: 40
      color: "transparent"

      anchors {
        top: true
        left: true
        right: true
      }

      margins {
        left: 4
        right: 4
        top: 4
        bottom: 4
      }

      Rectangle {
        id: bar
        anchors.fill: parent
        radius: 10
        color: Stylix.base00

        RowLayout {
          anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom

            leftMargin: 10
          }

          spacing: 15

          Workspaces {
            screen: modelData
          }
          FocusedWindow {}
        }

        RowLayout {
          anchors.centerIn: parent
          spacing: 20
        }

        RowLayout {
          anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right

            rightMargin: 15
          }

          spacing: 15

          NotificationDisplay {}
          SystemTrayWrapper {}
          Clock {}
          DistroIcon {}
        }
      }
    }
  }
}
