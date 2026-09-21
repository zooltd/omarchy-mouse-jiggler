# Changelog

## 1.0.5 — 2026-09-20

- Align packaging with the Omarchy Quattro plugin development guide: README
  Install / Usage / Configure / Remove sections, left-click gating on the bar
  button, and clearer `hyprctl` dependency docs.
- Keep click-to-toggle behavior (no details panel) and plugin id
  `youhan.mouse-jiggler`.


## 1.0.4 — 2026-09-13

- Try Hyprland 0.56 `hl.dsp.cursor.move`, then the legacy `movecursor`
  dispatcher, so an API change does not silently stop the nudge.
- If the pointer cannot be moved, the bar icon dims and the tooltip says so.
- `install.sh` now restarts the Omarchy shell so the bar loads the new QML
  instead of keeping a stale process.

## 1.0.3 — 2026-09-13

- Use Hyprland 0.56 `hl.dsp.cursor.move` instead of the removed `movecursor`
  dispatcher so the one-pixel nudge actually moves the pointer.

## 1.0.2 — 2026-08-31

- Stop cloning the built-in Indicators widget. The plugin is a normal bar
  icon again and no longer ships copies of Stay Awake, Night Light, or DND.

## 1.0.1 — 2026-08-31

- Brief experiment: clone `omarchy.indicators` so the icon could live in that
  cluster. Reverted in 1.0.2.

## 1.0.0 — 2026-08-31

- First release.
- One-pixel pointer nudge that returns to the original position, so the cursor does not drift off-screen.
- `omarchy plugin add` install path, plus `install.sh` / `uninstall.sh`.
- Optional CLI (`omarchy-mouse-jiggler`) and user systemd unit.
