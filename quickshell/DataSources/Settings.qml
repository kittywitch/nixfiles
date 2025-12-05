pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root
  readonly property Scheme scheme: Scheme {}

  readonly property color base00: scheme.base00
  readonly property color base01: scheme.base01
  readonly property color base02: scheme.base02
  readonly property color base03: scheme.base03
  readonly property color base04: scheme.base04
  readonly property color base05: scheme.base05
  readonly property color base06: scheme.base06
  readonly property color base07: scheme.base07
  readonly property color base08: scheme.base08
  readonly property color base09: scheme.base09
  readonly property color base0A: scheme.base0A
  readonly property color base0B: scheme.base0B
  readonly property color base0C: scheme.base0C
  readonly property color base0D: scheme.base0D
  readonly property color base0E: scheme.base0E
  readonly property color base0F: scheme.base0F
  readonly property color defaultBg: scheme.defaultBg
  readonly property color lighterBg: scheme.lighterBg
  readonly property color selectionBg: scheme.selectionBg
  readonly property color comments: scheme.comments
  readonly property color darkFg: scheme.darkFg
  readonly property color defaultFg: scheme.defaultFg
  readonly property color lightFg: scheme.lightFg
  readonly property color lightBg: scheme.lightBg
  readonly property color variable: scheme.variable
  readonly property color integer: scheme.integer
  readonly property color classy: scheme.classy
  readonly property color stringy: scheme.stringy
  readonly property color support: scheme.support
  readonly property color functiony: scheme.functiony
  readonly property color keyword: scheme.keyword
  readonly property color deprecated: scheme.deprecated

  function load(data: string): void {
    const colours = scheme;
    const scheme_json = JSON.parse(data);

    for (const [name, colour] of Object.entries(scheme_json)) {
      colours[name] = colour
    }
  }

  FileView {
    path: "./stylix.json"
    blockLoading: true
    watchChanges: true
    onFileChanged: reload()
    onLoaded: root.load(text(), false)
  }
  component Scheme: QtObject {
    property string author: ""
    property string scheme: ""
    property string slug: ""
    property color base00: "#000000"
    property color base01: "#000000"
    property color base02: "#000000"
    property color base03: "#000000"
    property color base04: "#000000"
    property color base05: "#000000"
    property color base06: "#000000"
    property color base07: "#000000"
    property color base08: "#000000"
    property color base09: "#000000"
    property color base0A: "#000000"
    property color base0B: "#000000"
    property color base0C: "#000000"
    property color base0D: "#000000"
    property color base0E: "#000000"
    property color base0F: "#000000"
    property color defaultBg: "#000000"
    property color lighterBg: "#000000"
    property color selectionBg: "#000000"
    property color comments: "#000000"
    property color darkFg: "#000000"
    property color defaultFg: "#000000"
    property color lightFg: "#000000"
    property color lightBg: "#000000"
    property color variable: "#000000"
    property color integer: "#000000"
    property color classy: "#000000"
    property color stringy: "#000000"
    property color support: "#000000"
    property color functiony: "#000000"
    property color keyword: "#000000"
    property color deprecated: "#000000"
  }
}
