# Omarchy Linux Mouse Jiggler (Menu Bar Icon)

A **mouse jiggler for [Omarchy Linux](https://omarchy.org)** — Hyprland / Wayland —
that puts a **mouse icon in the menu bar**. Click it to enable or disable.

After install, a mouse icon appears on the Omarchy menu bar. Click it: the
pointer nudges one pixel and snaps back, so idle lock, screensaver, and apps
that watch the mouse stay awake. The cursor does not drift off the screen.

Stay Awake only blocks Hyprland idle. This is the Linux menu-bar caffeine /
mouse-jiggler for everything else: Zoom, Google Meet, remote desktops, and
websites that go idle when the mouse stops.

This is a normal third-party bar widget. It does **not** replace Omarchy's
Indicators group (Stay Awake, Night Light, Silence Notifications). Those stay
built-in. The jiggler is its own icon; move it anywhere with `omarchy bar move`.

## Menu bar icon

Once the plugin is enabled you get:

- A **mouse icon in the Omarchy menu bar** (the top bar)
- **Click to toggle** mouse jiggle on or off
- Dim icon = off, full brightness = on
- Tooltip: "Start mouse jiggler" / "Stop mouse jiggler"

If the icon is missing, the plugin is installed but not on the bar. Run
`omarchy plugin enable youhan.mouse-jiggler`.

## Install

On Omarchy Linux:

```bash
omarchy plugin add https://github.com/zooltd/omarchy-mouse-jiggler.git --enable
```

That is the whole install. A mouse icon appears on the menu bar. The widget
jiggles on its own while it is on. To park it next to the Indicators cluster:

```bash
omarchy bar move youhan.mouse-jiggler --after omarchy.indicators
```

Optional, if you also want the `omarchy-mouse-jiggler` CLI on your PATH:

```bash
git clone https://github.com/zooltd/omarchy-mouse-jiggler.git
cd omarchy-mouse-jiggler
./install.sh
```

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

Works on Omarchy Linux (Hyprland + `omarchy-bar`). The plugin lives in
`~/.config/omarchy/plugins`, which is the supported place for third-party
shell plugins.

## Uninstall

```bash
omarchy plugin remove youhan.mouse-jiggler
```

If you used `install.sh`:

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
install.sh        Local install
uninstall.sh      Clean removal
```

## License

MIT. See [LICENSE](LICENSE).
