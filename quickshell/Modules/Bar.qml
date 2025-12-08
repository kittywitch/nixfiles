import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "root:/DataSources"
import "root:/Components"
import "root:/Components/WorkspaceControl"
import "root:/Components/SystemTray"
import "root:/Components/NotificationArea"

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
        anchors {
          top: parent.top
          left: parent.left
          bottom: parent.bottom
        }

        MarginWrapperManager { margin: 10 }
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
      }

        RowLayout {
          anchors.centerIn: parent
          spacing: 20
        }
      Rectangle {
        MarginWrapperManager { margin: 10 }
        id: bar3
        radius: 10
        color: Stylix.base00
        anchors {
          top: parent.top
          right: parent.right
          bottom: parent.bottom
        }

        RowLayout {
          anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right

            rightMargin: 15
          }

          spacing: 15

          Battery {}
          SystemTrayWrapper {}
          Clock {}
          NotificationDisplay {}
          DistroIcon {}
        }
      }
    }
  }
}
