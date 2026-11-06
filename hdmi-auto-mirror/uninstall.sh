#!/usr/bin/env bash
# Removes hdmi-auto-mirror. Remove any lines you added to your Hyprland config yourself.
set -uo pipefail

systemctl --user disable --now hdmi-auto-mirror.service 2>/dev/null
rm -f "$HOME/.config/systemd/user/hdmi-auto-mirror.service"
systemctl --user daemon-reload 2>/dev/null
rm -f "$HOME/.local/bin/hdmi-auto-mirror" "$HOME/.local/bin/hdmi-display-menu"

echo "Removed."
