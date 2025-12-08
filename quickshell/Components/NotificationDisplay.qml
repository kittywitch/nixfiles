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
      anchor.rect.y: parentWindow.height
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
            spacing: 5
            Text {
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
          ListView {
            id: notificationList
            model: Notifications.list
            spacing: 10
            ScrollBar.vertical: ScrollBar {}
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: parent.height

            delegate: Item {
              required property Notification modelData

              height: 100
              width: 400//notificationList.width

              Rectangle {
                id: indivNotif
                anchors {
                  fill: parent
                  leftMargin: 5
                  rightMargin: 5
                }
                color: Stylix.base02
                ColumnLayout {
                  anchors {
                    fill: parent
                    leftMargin: 5
                    rightMargin: 5
                  }
                  RowLayout {
                    spacing: 5
                    ClippingWrapperRectangle {
                      radius: 5
                      Layout.minimumWidth: 0
                      Layout.minimumHeight: 0
                      Layout.maximumWidth: 60
                      Layout.preferredWidth: 60
                      Layout.preferredHeight: 60
                      Layout.leftMargin: 5
                      Layout.rightMargin: 5
                      visible: modelData.image != ""
                      Image {
                        fillMode: Image.PreserveAspectCrop
                        Layout.minimumWidth: 0
                        Layout.minimumHeight: 0
                        Layout.preferredWidth: 60
                        Layout.preferredHeight: 60
                        source: modelData.image
                      }
                    }
                    ColumnLayout {
                      spacing: 5
                      RowLayout {
                        spacing: 5
                        IconImage {
                          function getIcon() {
                            console.log(modelData.appIcon)
                            if (modelData.appIcon != "") {
                              return Quickshell.iconPath(modelData.appIcon)
                            } else {
                              return iconForId(modelData.appName)
                            }
                          }
                          width: 24
                          height: 24
                          visible: modelData.appIcon != ""
                          source: Quickshell.iconPath(modelData.appIcon)
                        }
                        Text {
                          elide: Text.ElideRight
                          text: modelData.summary
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
                              modelData.dismiss();
                              if (Notifications.list.length <= 0) {
                                popup.visible = false;
                              }
                            }
                          }
                        }
                      }
                      Text {
                        font.pointSize: 10
                        wrapMode: Text.WordWrap
                        elide: Text.ElideRight
                        text: modelData.body
                        color: Stylix.base05
                      }
                    }
                  }
                  RowLayout {
                    Layout.minimumHeight: 0
                    visible: modelData.actions != []
                    spacing: 5
                    Repeater {
                      model: modelData.actions

                      Item {
                        required property NotificationAction actionData

                        width: 400
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
                }
              }
            }
          }
        }
      }
    }
  }
}
