import QtQuick
import QtQuick.Layouts
import "root:/DataSources"

Text {
    id: clock
    font.pointSize: 13
    color: Stylix.base0F
    Layout.alignment: Qt.AlignCenter

    text: Time.time
}
