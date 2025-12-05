import QtQuick
import QtQuick.Layouts
import "root:/DataSources"
import "root:/Components"
import Niri 0.1

import QtQuick
import QtQuick.Layouts
import Quickshell

RowLayout {
  id: root
  property var screen
  spacing: 10

  Repeater {
    model: niri.workspaces

    WorkspaceButton {
      modelData: model
      screenData: screen
    }
  }
}
