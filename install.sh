#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ID="youhan.mouse-jiggler"
PLUGIN_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/plugins/$PLUGIN_ID"
BIN_DIR="$HOME/.local/bin"
UNIT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"

mkdir -p "$PLUGIN_DIR" "$BIN_DIR" "$UNIT_DIR" "$HOME/.local/state/omarchy/indicators"

# Copy files individually. Omarchy refuses plugins that contain symlinks.
install -m 644 "$ROOT/manifest.json" "$PLUGIN_DIR/manifest.json"
install -m 644 "$ROOT/BarWidget.qml" "$PLUGIN_DIR/BarWidget.qml"
install -m 755 "$ROOT/bin/omarchy-mouse-jiggler" "$BIN_DIR/omarchy-mouse-jiggler"
install -m 644 "$ROOT/systemd/omarchy-mouse-jiggler.service" "$UNIT_DIR/omarchy-mouse-jiggler.service"

systemctl --user daemon-reload

if command -v omarchy-plugin-validate >/dev/null 2>&1; then
  omarchy plugin validate "$PLUGIN_DIR"
fi

if command -v omarchy-shell >/dev/null 2>&1; then
  omarchy-shell -q shell rescanPlugins || true
fi

if command -v omarchy-plugin-enable >/dev/null 2>&1; then
  omarchy plugin enable "$PLUGIN_ID" --section center || true
fi

if command -v omarchy-bar >/dev/null 2>&1; then
  omarchy bar move "$PLUGIN_ID" --after omarchy.indicators || true
fi

echo "Installed $PLUGIN_ID as its own menu bar icon."
echo "Click the mouse icon, or run: omarchy-mouse-jiggler toggle"
