#!/usr/bin/env bash

set -euo pipefail

BIN_FILE="${HOME}/.local/bin/set-touchpad-scroll"
AUTOSTART_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/autostart/touchpad-scroll.desktop"
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/touchpad-scroll.conf"

rm -f "$BIN_FILE" "$AUTOSTART_FILE"

printf 'Removed touchpad-scroll executable and autostart entry.\n'

if [[ -e "$CONFIG_FILE" ]]; then
    printf 'Kept config file: %s\n' "$CONFIG_FILE"
    printf 'Remove it manually if no longer needed.\n'
fi
