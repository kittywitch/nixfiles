import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower
import "root:/DataSources"

Loader {
  property UPowerDevice mainBat: UPower.displayDevice
  active: mainBat.isLaptopBattery
  sourceComponent: batIcon

  function findClosestIndex(percent) {
    return Math.round(percent/10)
  }

  property list<string> percentIcons: [
    "󰂎",
    "󰁺",
    "󰁼",
    "󰁼",
    "󰁽",
    "󰁾",
    "󰁿",
    "󰂀",
    "󰂁",
    "󰂂",
    "󰁹"
  ]

  property string chargingIcon: "󰂄"

  function getIcon(percent) {
    if (mainBat.timeToEmpty == 0) {
      return chargingIcon
    } else {
      var percentIcon = percentIcons[findClosestIndex(percent)];
      return percentIcon
    }
  }

  function getTimeLeft(allSeconds, filling) {
    const hours = Math.floor(allSeconds / 3600)
    const minutes = Math.floor((allSeconds % 3600) / 60)
    const seconds = Math.floor((allSeconds % 3600) / 60) / 60
    const fillString = filling ? "full" : "empty"

    return `${hours}h${minutes}m${seconds}s remain until ${fillString}`
  }

  function getTimeLeftT() {
    if (mainBat.timeToEmpty == 0) {
      return getTimeLeft(mainBat.timeToEmpty, false)
    } else if (mainBat.timeToFull == 0) {
      return getTimeLeft(mainBat.timeToFull, true)
    }
  }

  function changeRate() {
    return `${Math.round(mainBat.changeRate)}W`
  }

  function energyLeft() {
    return `${Math.round(mainBat.energy)}Wh`
  }

  function getTooltip() {
    return `${getTimeLeftT()}, ${energyLeft()}, ${changeRate()}`
  }

  Component {
    id: batIcon
    Item {
      MarginWrapperManager { margin: 10 }
      Text {
        color: Stylix.base05
        text: `${getIcon(mainBat.percentage)} ${Math.round(mainBat.percentage)} %`

        ToolTip {
          id: dismissTooltip
          visible: false
          delay: 500
          timeout: 1000
          text: getTooltip()
        }

        HoverHandler {
          id: dismissHover
          onHoveredChanged: {
            dismissTooltip.visible = hovered
          }
        }
      }
    }
  }
}
