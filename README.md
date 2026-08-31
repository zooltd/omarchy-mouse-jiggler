# Mouse Jiggler

A menu-bar mouse jiggler for [Omarchy](https://omarchy.org) (Hyprland / Wayland).
Click the mouse icon to enable or disable.

After install, a mouse icon appears on the menu bar. Click it: the pointer
nudges one pixel and snaps back, so idle lock, screensaver, and apps that
watch the mouse stay awake. The cursor does not drift off the screen.

Stay Awake only blocks Hyprland idle. This is for everything else: Zoom,
Google Meet, remote desktops, and websites that go idle when the mouse stops.

The bar icon is an Omarchy plugin. The optional CLI loop only needs `hyprctl`,
so it can run on other Hyprland setups.

## Menu bar icon

Once the plugin is enabled you get:

- A **mouse icon in the menu bar**
- **Click to toggle** mouse jiggle on or off
- Dim icon = off, full brightness = on
- Tooltip: "Start mouse jiggler" / "Stop mouse jiggler"

If the icon is missing, run `omarchy plugin enable youhan.mouse-jiggler`.

This is its own widget. It does not join Omarchy's Indicators group (Stay
Awake, Night Light, Silence Notifications).

## Install

```bash
omarchy plugin add https://github.com/zooltd/omarchy-mouse-jiggler.git --enable
```

A mouse icon appears on the menu bar.

To park it on the **right of the Indicators group** (center of the bar, first
slot after Indicators — the same place as `--index 1`):

```bash
omarchy bar move youhan.mouse-jiggler --after omarchy.indicators
```

Same slot on a default bar:

```bash
omarchy bar move youhan.mouse-jiggler --section center --index 1
```

Stay Awake is not a bar widget, so there is no `--after StayAwake`.

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
`MOUSE_JIGGLER_INTERVAL` for the CLI).

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
the mouse.

State is a file at `~/.local/state/omarchy/indicators/mouse-jiggler`. Presence
means on. Removing it turns the jiggler off. The menu bar widget does not need
a daemon.

The bar plugin lives in `~/.config/omarchy/plugins`.

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
manifest.json     Plugin manifest (id: youhan.mouse-jiggler)
BarWidget.qml     Menu bar icon, click-to-toggle, 1px nudge timer
bin/              Optional CLI
systemd/          Optional user unit for running without the bar
install.sh        Local install
uninstall.sh      Clean removal
```

## License

MIT. See [LICENSE](LICENSE).
