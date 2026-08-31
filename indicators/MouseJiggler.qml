import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

BarIndicator {
  id: root

  active: jiggling
  activeText: "󰍽"
  inactiveText: "󰍽"
  activeTooltipText: "Stop mouse jiggler"
  inactiveTooltipText: "Mouse Jiggler"

  property bool jiggling: false
  readonly property int intervalSeconds: 25

  function refresh() {
    if (!stateProbe.running)
      stateProbe.running = true
  }

  function toggle() {
    if (!toggleProc.running)
      toggleProc.running = true
  }

  function nudge() {
    if (root.jiggling && !nudgeProc.running)
      nudgeProc.running = true
  }

  Component.onCompleted: refresh()

  Connections {
    target: root.indicatorHost
    ignoreUnknownSignals: true
    function onRefreshRequested() { root.refresh() }
  }

  Process {
    id: stateProbe
    command: ["bash", "-lc", "if [[ -f $HOME/.local/state/omarchy/indicators/mouse-jiggler ]]; then echo yes; else echo no; fi"]
    stdout: SplitParser {
      onRead: function(line) { root.jiggling = String(line).trim() === "yes" }
    }
  }

  Process {
    id: toggleProc
    command: ["bash", "-lc", "state=\"$HOME/.local/state/omarchy/indicators/mouse-jiggler\"; mkdir -p \"$(dirname \"$state\")\"; if [[ -f $state ]]; then rm -f \"$state\"; else touch \"$state\"; fi"]
    onExited: root.refresh()
  }

  Process {
    id: nudgeProc
    command: ["bash", "-lc", "raw=$(hyprctl cursorpos 2>/dev/null || true); raw=${raw// /}; x=${raw%%,*}; y=${raw##*,}; [[ $x =~ ^[0-9]+$ && $y =~ ^[0-9]+$ ]] || exit 0; hyprctl dispatch movecursor $((x + 1)) \"$y\" >/dev/null 2>&1 || true; sleep 0.08; hyprctl dispatch movecursor \"$x\" \"$y\" >/dev/null 2>&1 || true"]
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: root.refresh()
  }

  Timer {
    interval: root.intervalSeconds * 1000
    running: root.jiggling
    repeat: true
    triggeredOnStart: true
    onTriggered: root.nudge()
  }

  onPressed: function() { root.toggle() }
}
