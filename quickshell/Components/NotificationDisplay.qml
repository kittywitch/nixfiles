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
  id: root
  Layout.alignment: Qt.AlignVCenter;
  implicitWidth: 25
  implicitHeight: parent.height
  Rectangle {
    anchors.centerIn: parent
    id: rootContainer
    color: "transparent"
    width: 30
    height: 30
    radius: 50
    Text {
      id: rootIcon
      text: ""
      color: Stylix.base05
      anchors.centerIn: parent
    }
  }
  function updateDisplay() {
    if (Notifications.list.length > 0) {
      rootContainer.color = Stylix.base08
      rootIcon.color = Stylix.base00
    } else {
      rootContainer.color = "transparent"
      rootIcon.color = Stylix.base05
    }
  }
  Timer {
    interval: 1000
    running:  true
    repeat: true
    onTriggered: root.updateDisplay()
  }
  MouseArea {
    id: ma
    anchors.fill: parent
    hoverEnabled: true

    onClicked: function(mouseEvent) {
      var m = root.QsWindow.mapFromItem(ma, ma.width/2.0, ma.height/2.0);
      var offset = notificationLoader.item.width / 2.0;
      notificationLoader.item.clicky = m.x - offset;
      notificationLoader.item.visible = !notificationLoader.item.visible
    }
  }

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

      implicitWidth: 400
      implicitHeight: 600

      Rectangle {
        anchors.fill: parent
        color: Stylix.base01
        bottomLeftRadius: 5
        bottomRightRadius: 5
        ColumnLayout {
          anchors.fill: parent
          RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 10
            Text {
              font.bold: true
              Layout.preferredHeight: 26
              Layout.alignment: Qt.AlignVCenter
              verticalAlignment: Text.AlignVCenter
              text: "Notifications"
              color: Stylix.base05
              font.pixelSize: 16
            }
            Text {
              Layout.preferredHeight: 26
              Layout.alignment: Qt.AlignVCenter
              verticalAlignment: Text.AlignBottom
              id: clear
              text: "󱏧"
              color: Stylix.base08
              font.pixelSize: 16
              ToolTip {
                id: clearTooltip
                visible: false
                delay: 500
                timeout: 1000
                text: "Clear notifications"
              }
              MouseArea {
                anchors.fill: parent
                onClicked: {
                  if (Notifications.list.length >= 0) {
                    Notifications.clear()
                    root.updateDisplay()
                  }
                }
              }

              HoverHandler {
                id: clearHover
                onHoveredChanged: {
                  clearTooltip.visible = hovered
                }
              }
            }
          }
          ClippingRectangle {
              color: "transparent"
              Layout.alignment: Qt.AlignBottom
              Layout.preferredWidth: parent.width
              Layout.preferredHeight: parent.height - 24
              ListView {
                anchors.fill: parent
              id: notificationList
              model: Notifications.list
              spacing: 10
              ScrollBar.vertical: ScrollBar {}

              delegate: Item {
                required property Notification modelData

                height: 100
                width: 400

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
                        Layout.maximumWidth: indivNotif.width
                        elide: Text.ElideRight
                        text: modelData.body
                        color: Stylix.base05
                      }
                    }
                    NotificationActions {
                      modelData_: modelData
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
