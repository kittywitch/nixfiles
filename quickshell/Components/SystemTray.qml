import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import "root:/DataSources"

RowLayout {
  id: systray

  anchors.centerIn: parent
  Layout.alignment: Qt.AlignCenter
  property string openItemId

  Repeater {
    model: SystemTray.items

    delegate: Item {
      id: delegateItem
      required property SystemTrayItem modelData

      width: 24
      height: 24

      IconImage {
        source: modelData.icon
        width: 20
        height: 20
        anchors.centerIn: parent
      }

      MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true

        onClicked: function(mouseEvent) {
          var m = delegateItem.QsWindow.mapFromItem(delegateItem, delegateItem.width/2.0, delegateItem.height/2.0);
          var offset = popupLoader.item.width / 2.0;
          popupLoader.clicky = m.x - offset;
          if (openItemId == modelData.id) {
            openItemId = null
          } else {
            openItemId = modelData.id
          }
          //popupLoader.item.visible = !popupLoader.item.visible
        }
      }

      QsMenuOpener {
        id: menu
        menu: modelData.menu
      }

      LazyLoader {
        id: popupLoader

        property real clicky

        loading: true

        PopupWindow {
          id: popup
          anchor.window: delegateItem.QsWindow.window
          anchor.rect.x: popupLoader.clicky
          anchor.rect.y: if (visible) { parentWindow.height } else { systray.height }

          visible: openItemId == modelData.id
          color: "transparent"

          property real childHeight: 5

          implicitWidth: 300
          implicitHeight: childHeight

          Rectangle {
            anchors.fill: parent
            color: Stylix.base02
            radius: 5
          }

          ListView {
            model: menu.children

            anchors {
              top: parent.top
              topMargin: 5
              bottom: parent.bottom
              bottomMargin: 5
            }

            width: parent.width
            height: parent.height
            spacing: 5

            ScrollBar.horizontal: ScrollBar {}

            delegate: Loader {
              required property QsMenuHandle modelData
              id: trayItemLoader

              width: parent.width

              Component.onCompleted: {
                if (modelData.text != null && modelData.text != "") {
                  trayItemLoader.setSource("SystemTrayButton.qml", {
                    "modelData": modelData,
                  })
                  childHeight += 30
                } else {
                  trayItemLoader.setSource("SystemTraySeparator.qml", {})
                  childHeight += 2
                }
                childHeight += 5
              }
            }
          }
        }
      }
    }
  }
}
