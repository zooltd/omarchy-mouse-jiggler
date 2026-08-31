#!/usr/bin/env bash
set -euo pipefail

PLUGIN_ID="youhan.mouse-jiggler"
PLUGIN_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/plugins/$PLUGIN_ID"
BIN="$HOME/.local/bin/omarchy-mouse-jiggler"
UNIT="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user/omarchy-mouse-jiggler.service"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/indicators/mouse-jiggler"

if command -v omarchy-plugin-disable >/dev/null 2>&1; then
  omarchy plugin disable "$PLUGIN_ID" || true
fi

systemctl --user stop omarchy-mouse-jiggler.service 2>/dev/null || true
systemctl --user disable omarchy-mouse-jiggler.service 2>/dev/null || true

rm -rf "$PLUGIN_DIR"
rm -f "$BIN" "$UNIT" "$STATE"

if command -v omarchy-shell >/dev/null 2>&1; then
  omarchy-shell -q shell rescanPlugins || true
fi

systemctl --user daemon-reload 2>/dev/null || true

echo "Removed $PLUGIN_ID."
