import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "youhan.mouse-jiggler"

  readonly property string home: Quickshell.env("HOME")
  readonly property string stateDir: home + "/.local/state/omarchy/indicators"
  readonly property string statePath: stateDir + "/mouse-jiggler"
  readonly property int intervalSeconds: Math.max(5, Number(setting("interval", 25)) || 25)

  property bool enabled: false
  property bool healthy: true

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function refresh() {
    if (!stateProbe.running)
      stateProbe.running = true
  }

  function toggle() {
    if (!toggleProc.running)
      toggleProc.running = true
  }

  function nudge() {
    if (root.enabled && !nudgeProc.running)
      nudgeProc.running = true
  }

  Component.onCompleted: root.refresh()

  IpcHandler {
    target: "youhan.mouse-jiggler"

    function refresh(): void {
      root.broadcast("refresh")
    }

    function toggle(): void {
      root.broadcast("toggle")
    }
  }

  Process {
    id: stateProbe
    command: ["bash", "-lc", "if [[ -f $HOME/.local/state/omarchy/indicators/mouse-jiggler ]]; then echo yes; else echo no; fi"]
    stdout: SplitParser {
      onRead: function(line) { root.enabled = String(line).trim() === "yes" }
    }
  }

  Process {
    id: toggleProc
    command: ["bash", "-lc", "state=\"$HOME/.local/state/omarchy/indicators/mouse-jiggler\"; mkdir -p \"$(dirname \"$state\")\"; if [[ -f $state ]]; then rm -f \"$state\"; else touch \"$state\"; fi"]
    onExited: root.refresh()
  }

  Process {
    id: nudgeProc
    command: ["bash", "-lc", "raw=$(hyprctl cursorpos 2>/dev/null || true); raw=${raw// /}; x=${raw%%,*}; y=${raw##*,}; [[ $x =~ ^[0-9]+$ && $y =~ ^[0-9]+$ ]] || exit 0; move() { hyprctl dispatch \"hl.dsp.cursor.move({ x = $1, y = $2 })\" >/dev/null 2>&1 || hyprctl dispatch movecursor \"$1\" \"$2\" >/dev/null 2>&1; }; move $((x + 1)) \"$y\" || exit 1; sleep 0.08; move \"$x\" \"$y\" || true"]
    onExited: function(exitCode) { root.healthy = exitCode === 0 }
  }

  FileView {
    id: stateDirWatcher
    path: root.stateDir
    watchChanges: true
    printErrors: false
    onFileChanged: root.refresh()
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: root.refresh()
  }

  Timer {
    interval: root.intervalSeconds * 1000
    running: root.enabled
    repeat: true
    triggeredOnStart: true
    onTriggered: root.nudge()
  }

  // Icon status slot: BarIconButton matches first-party indicator-style widgets.
  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰍽"
    slotSize: Style.bar.statusSlot
    fontSize: Style.font.caption
    active: root.enabled && root.healthy
    dimmed: !root.enabled || !root.healthy
    useActiveColor: false
    tooltipText: root.enabled && !root.healthy
      ? "Jiggle failed — Hyprland rejected the cursor move"
      : (root.enabled ? "Stop mouse jiggler" : "Start mouse jiggler")
    onPressed: function(buttonCode) {
      if (buttonCode === Qt.LeftButton)
        root.toggle()
    }
  }
}
