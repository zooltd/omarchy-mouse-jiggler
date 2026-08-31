# Changelog

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
