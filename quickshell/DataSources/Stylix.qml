// https://codeberg.org/permafrozen/shell/src/commit/82d34e9816ba23971d4a007a6a178d952a8cc6bf/src/utils/Theme.qml
pragma ComponentBehavior: Bound
pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // Assign Properties from the read in palette.json (stylix generated file)
    readonly property color base00: json.base00 ? `#${json.base00}` : "#000000"
    readonly property color base01: json.base01 ? `#${json.base01}` : "#000000"
    readonly property color base02: json.base02 ? `#${json.base02}` : "#000000"
    readonly property color base03: json.base03 ? `#${json.base03}` : "#000000"
    readonly property color base04: json.base04 ? `#${json.base04}` : "#000000"
    readonly property color base05: json.base05 ? `#${json.base05}` : "#000000"
    readonly property color base06: json.base06 ? `#${json.base06}` : "#000000"
    readonly property color base07: json.base07 ? `#${json.base07}` : "#000000"
    readonly property color base08: json.base08 ? `#${json.base08}` : "#000000"
    readonly property color base09: json.base09 ? `#${json.base09}` : "#000000"
    readonly property color base0A: json.base0A ? `#${json.base0A}` : "#000000"
    readonly property color base0B: json.base0B ? `#${json.base0B}` : "#000000"
    readonly property color base0C: json.base0C ? `#${json.base0C}` : "#000000"
    readonly property color base0D: json.base0D ? `#${json.base0D}` : "#000000"
    readonly property color base0E: json.base0E ? `#${json.base0E}` : "#000000"
    readonly property color base0F: json.base0F ? `#${json.base0F}` : "#000000"
    readonly property string author: json.author ? json.author : ""
    readonly property string scheme: json.scheme ? json.scheme : ""
    readonly property string slug: json.slug ? json.slug : ""

    FileView {
        path: `${Quickshell.env("HOME")}/.config/stylix/palette.json`
        watchChanges: true
        blockLoading: true
        onFileChanged: reload()

        JsonAdapter {
            id: json
            property string base00
            property string base01
            property string base02
            property string base03
            property string base04
            property string base05
            property string base06
            property string base07
            property string base08
            property string base09
            property string base0A
            property string base0B
            property string base0C
            property string base0D
            property string base0E
            property string base0F
            property string author
            property string scheme
            property string slug
        }
    }
}
