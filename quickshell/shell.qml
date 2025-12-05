import Quickshell
import Quickshell.Io
import QtQuick
import Niri 0.1

import "root:/Modules"

ShellRoot{
    id: root

    Niri {
        id: niri
        Component.onCompleted: connect()

        onConnected: console.info("Connected to niri")
        onErrorOccurred: function(error) {
            console.error("Niri error:", error)
        }
    }

    LazyLoader{ active: true; component: Bar{} }
}
