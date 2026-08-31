# Omarchy Mouse Jiggler

A tiny [Omarchy](https://omarchy.org) bar toggle that keeps the session awake
by nudging the pointer one pixel — then putting it back. Click the mouse icon
next to Stay Awake to turn it on or off.

Stay Awake only stops Hyprland's idle lock and screensaver. This is for the
other half: apps, sites, and remote tools that watch the mouse.

## What it does

- **Shows a mouse icon on the Omarchy bar**, parked next to Stay Awake.
- **Click to toggle.** Dim when off, full brightness when on.
- **Nudges the pointer 1px and restores it** every 25 seconds (configurable).
  The cursor does not walk across the screen, and will not fall off the edge.
- **Survives an Omarchy update.** The plugin lives in your home directory, not
  in `/usr/share/omarchy`. A future layout reset could hide the icon; the
  plugin itself stays installed.

## Install

From Omarchy:

```bash
omarchy plugin add https://github.com/zooltd/omarchy-mouse-jiggler.git --enable
omarchy bar move youhan.mouse-jiggler --section center --index 1
```

That clone is enough. The widget jiggles on its own while it is on the bar.

Optional, if you also want the CLI on your PATH:

```bash
git clone https://github.com/zooltd/omarchy-mouse-jiggler.git
cd omarchy-mouse-jiggler
./install.sh
```

## Use

Click the mouse icon. Or:

```bash
omarchy-mouse-jiggler toggle   # on/off
omarchy-mouse-jiggler status
```

Change the interval in the bar widget settings, or with
`MOUSE_JIGGLER_INTERVAL` (seconds, default 25) when you run the CLI loop.

The optional user unit is only for running the loop without the bar:

```bash
systemctl --user start omarchy-mouse-jiggler.service
```

Do not run the unit and the bar widget at the same time — they would both nudge.

## How it works

`hyprctl cursorpos` reads the current location, `movecursor` steps one pixel
right, then the original coordinates are restored 80 ms later. Hyprland treats
that as pointer activity, which resets idle and is visible to apps that watch
the mouse.

State is a file at `~/.local/state/omarchy/indicators/mouse-jiggler`. Presence
means on. Removing it turns the jiggler off. No daemons are required for the
bar widget.

## Uninstall

```bash
omarchy plugin remove youhan.mouse-jiggler
```

If you used `install.sh`:

```bash
./uninstall.sh
```

That removes the plugin, the CLI, the user unit, and the state file.

## Layout

```
manifest.json     Omarchy plugin manifest (id: youhan.mouse-jiggler)
BarWidget.qml     Bar icon, toggle, and the 1px nudge timer
bin/              Optional CLI
systemd/          Optional user unit for running without the bar
install.sh        Local install + place next to Stay Awake
uninstall.sh      Clean removal
```

## License

MIT. See [LICENSE](LICENSE).
