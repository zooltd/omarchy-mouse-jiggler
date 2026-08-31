# Omarchy Linux Mouse Jiggler (Menu Bar Icon)

A **mouse jiggler for [Omarchy Linux](https://omarchy.org)** — Hyprland / Wayland —
that puts a **mouse icon in the menu bar**. Click it to enable or disable.

After install, a mouse icon appears at the **right end of the Omarchy menu bar**.
Click it: the pointer nudges one pixel and snaps back, so idle lock, screensaver,
and apps that watch the mouse stay awake. The cursor does not drift off the
screen.

Stay Awake only blocks Hyprland idle. This is the Linux menu-bar caffeine /
mouse-jiggler for everything else: Zoom, Google Meet, remote desktops, and
websites that go idle when the mouse stops.

## Menu bar icon

Once the plugin is enabled you get:

- A **mouse icon at the right end of the Omarchy menu bar** (the top bar)
- **Click to toggle** mouse jiggle on or off
- Dim icon = off, full brightness = on
- Tooltip: "Start mouse jiggler" / "Stop mouse jiggler"

If the icon is missing, the plugin is installed but not on the bar. Run the
`omarchy bar move` command in Install.

## Install

On Omarchy Linux:

```bash
omarchy plugin add https://github.com/zooltd/omarchy-mouse-jiggler.git --enable
omarchy bar move youhan.mouse-jiggler --section right --after omarchy.power
```

That is the whole install. A mouse icon appears at the rightmost spot on the
menu bar (after Power). The widget jiggles on its own while it is on.

Optional, if you also want the `omarchy-mouse-jiggler` CLI on your PATH:

```bash
git clone https://github.com/zooltd/omarchy-mouse-jiggler.git
cd omarchy-mouse-jiggler
./install.sh
```

`install.sh` copies the plugin, puts the CLI in `~/.local/bin`, and places the
menu bar icon at the right end of the bar.

## Use

Click the **menu bar mouse icon**. Or from a terminal:

```bash
omarchy-mouse-jiggler toggle   # on/off
omarchy-mouse-jiggler status
```

Nudge interval is 25 seconds by default (bar widget settings, or
`MOUSE_JIGGLER_INTERVAL` for the CLI). Shorter than Omarchy's 150s screensaver
so idle never wins.

The optional user systemd unit is only if you want the loop **without** the
menu bar widget:

```bash
systemctl --user start omarchy-mouse-jiggler.service
```

Do not run the unit and the menu bar icon at the same time — they would both
nudge.

## How it works

`hyprctl cursorpos` reads the current location, `movecursor` steps one pixel
right, then the original coordinates are restored 80 ms later. Hyprland treats
that as pointer activity, which resets idle and is visible to apps that watch
the mouse. It is a mouse jiggler, not a warp-to-corner hack, so the pointer
stays where you left it.

State is a file at `~/.local/state/omarchy/indicators/mouse-jiggler`. Presence
means on. Removing it turns the jiggler off. The menu bar widget does not need
a daemon.

Works on Omarchy Linux (Hyprland + `omarchy-bar`). It is a third-party plugin
under `~/.config/omarchy/plugins`, so an Omarchy update should leave it
installed. A layout reset could hide the icon; run the `omarchy bar move` line
again if that happens.

## Uninstall

```bash
omarchy plugin remove youhan.mouse-jiggler
```

That removes the menu bar icon. If you used `install.sh`:

```bash
./uninstall.sh
```

That also removes the CLI, the user unit, and the state file.

## Layout

```
manifest.json     Omarchy plugin manifest (id: youhan.mouse-jiggler)
BarWidget.qml     Menu bar icon, click-to-toggle, 1px nudge timer
bin/              Optional CLI
systemd/          Optional user unit for running without the bar
install.sh        Local install + place icon at the right end of the bar
uninstall.sh      Clean removal
```

## License

MIT. See [LICENSE](LICENSE).
