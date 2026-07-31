#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${HOME}/.local/bin"
AUTOSTART_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/autostart"
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/touchpad-scroll.conf"

if ! command -v xinput >/dev/null 2>&1; then
    printf 'xinput is required. Install it first, for example:\n' >&2
    printf '  sudo apt install xinput\n' >&2
    exit 1
fi

install -d "$BIN_DIR" "$AUTOSTART_DIR"
install -m 0755 "$SCRIPT_DIR/set-touchpad-scroll" "$BIN_DIR/set-touchpad-scroll"

cat > "$AUTOSTART_DIR/touchpad-scroll.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Touchpad Scroll Speed
Comment=Apply a custom libinput touchpad scroll distance
Exec=$BIN_DIR/set-touchpad-scroll
Terminal=false
Hidden=false
NoDisplay=true
X-GNOME-Autostart-enabled=true
EOF

if [[ ! -e "$CONFIG_FILE" ]]; then
    cat > "$CONFIG_FILE" <<'EOF'
# Higher values produce slower scrolling.
SCROLL_DISTANCE=45
EOF
fi

printf 'Installed touchpad-scroll.\n'
printf 'Config: %s\n' "$CONFIG_FILE"
printf 'Run now: %s/set-touchpad-scroll\n' "$BIN_DIR"
