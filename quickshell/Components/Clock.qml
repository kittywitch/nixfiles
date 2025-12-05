import QtQuick
import QtQuick.Layouts
import "root:/DataSources"

Text {
    id: clock
    font.pointSize: 13
    color: Settings.variable
    Layout.alignment: Qt.AlignCenter

    text: Time.time
}
