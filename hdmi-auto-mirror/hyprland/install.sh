#!/usr/bin/env bash
# Installs hdmi-auto-mirror for Hyprland. Does not edit your Hyprland config.
set -euo pipefail
repo=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

install -Dm755 "$repo/bin/hdmi-auto-mirror" "$HOME/.local/bin/hdmi-auto-mirror"
install -Dm755 "$repo/hyprland/display-mode-menu.sh" "$HOME/.local/bin/hdmi-display-menu"

echo "Installed to ~/.local/bin."
echo
echo "Now add these lines to your Hyprland config and log in again:"
echo
grep -v '^# Add these' "$repo/hyprland/hyprland.conf.example"
