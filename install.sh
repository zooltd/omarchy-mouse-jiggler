#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ID="youhan.mouse-jiggler"
PLUGIN_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/plugins/$PLUGIN_ID"
BIN_DIR="$HOME/.local/bin"
UNIT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"

mkdir -p "$PLUGIN_DIR/indicators" "$BIN_DIR" "$UNIT_DIR" "$HOME/.local/state/omarchy/indicators"

# Copy files individually. Omarchy refuses plugins that contain symlinks.
install -m 644 "$ROOT/manifest.json" "$PLUGIN_DIR/manifest.json"
install -m 644 "$ROOT/Indicators.qml" "$PLUGIN_DIR/Indicators.qml"
for f in "$ROOT/indicators"/*.qml; do
  install -m 644 "$f" "$PLUGIN_DIR/indicators/$(basename "$f")"
done
install -m 755 "$ROOT/bin/omarchy-mouse-jiggler" "$BIN_DIR/omarchy-mouse-jiggler"
install -m 644 "$ROOT/systemd/omarchy-mouse-jiggler.service" "$UNIT_DIR/omarchy-mouse-jiggler.service"

systemctl --user daemon-reload

if command -v omarchy-plugin-validate >/dev/null 2>&1; then
  omarchy plugin validate "$PLUGIN_DIR"
fi

if command -v omarchy-shell >/dev/null 2>&1; then
  omarchy-shell -q shell rescanPlugins || true
fi

# clonedFrom omarchy.indicators: enable replaces the built-in Indicators cluster.
if command -v omarchy-plugin-enable >/dev/null 2>&1; then
  omarchy plugin enable "$PLUGIN_ID" || true
fi

echo "Installed $PLUGIN_ID in the Indicators group (Stay Awake, Night Light, Silence Notifications)."
echo "Hover the Indicators cluster if the mouse icon is hidden while off."
echo "Click it, or run: omarchy-mouse-jiggler toggle"
