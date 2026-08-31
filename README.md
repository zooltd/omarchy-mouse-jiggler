# Omarchy Linux Mouse Jiggler (Menu Bar Icon)

A **mouse jiggler for [Omarchy Linux](https://omarchy.org)** — Hyprland / Wayland —
that puts a **mouse icon in the menu bar Indicators group**. Click it to enable
or disable.

After install, a mouse icon appears in the same Omarchy menu bar cluster as
**Stay Awake**, **Night Light**, and **Silence Notifications**. Click it: the
pointer nudges one pixel and snaps back, so idle lock, screensaver, and apps
that watch the mouse stay awake. The cursor does not drift off the screen.

Stay Awake only blocks Hyprland idle. This is the Linux menu-bar caffeine /
mouse-jiggler for everything else: Zoom, Google Meet, remote desktops, and
websites that go idle when the mouse stops.

## Menu bar icon

Once the plugin is enabled you get:

- A **mouse icon in the Omarchy menu bar Indicators group** (Stay Awake,
  Night Light, Silence Notifications, and the rest). Order in the group does
  not matter.
- **Click to toggle** mouse jiggle on or off
- Like the other indicators: hidden while off until you hover the cluster,
  visible while on
- Tooltip: "Mouse Jiggler" / "Stop mouse jiggler"

This plugin is a clone of the built-in Indicators widget (`omarchy.indicators`)
with Mouse Jiggler added. Enabling it replaces that cluster; disabling it
restores the original.

## Install

On Omarchy Linux:

```bash
omarchy plugin add https://github.com/zooltd/omarchy-mouse-jiggler.git --enable
```

That is the whole install. A mouse icon appears in the Indicators group on the
menu bar. The widget jiggles on its own while it is on.

Optional, if you also want the `omarchy-mouse-jiggler` CLI on your PATH:

```bash
git clone https://github.com/zooltd/omarchy-mouse-jiggler.git
cd omarchy-mouse-jiggler
./install.sh
```

## Use

Hover the Indicators cluster if you do not see the mouse icon, then click it.
Or from a terminal:

```bash
omarchy-mouse-jiggler toggle   # on/off
omarchy-mouse-jiggler status
```

Nudge interval is 25 seconds by default (`MOUSE_JIGGLER_INTERVAL` for the CLI).
Shorter than Omarchy's 150s screensaver so idle never wins.

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

Works on Omarchy Linux (Hyprland + `omarchy-bar`). The plugin lives under
`~/.config/omarchy/plugins` as a clone of Indicators, so an Omarchy update
should leave it installed.

## Uninstall

```bash
omarchy plugin remove youhan.mouse-jiggler
```

That removes the mouse icon and restores the built-in Indicators cluster. If
you used `install.sh`:

```bash
./uninstall.sh
```

That also removes the CLI, the user unit, and the state file.

## Layout

```
manifest.json          Omarchy plugin (id: youhan.mouse-jiggler, clonedFrom indicators)
Indicators.qml         Built-in Indicators cluster + MouseJiggler
indicators/            StayAwake, NightLight, Dnd, MouseJiggler, ...
bin/                   Optional CLI
systemd/               Optional user unit for running without the bar
install.sh             Local install into the Indicators group
uninstall.sh           Restore built-in Indicators
```

## License

MIT. See [LICENSE](LICENSE).
