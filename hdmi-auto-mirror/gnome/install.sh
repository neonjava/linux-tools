#!/usr/bin/env bash
# Installs hdmi-auto-mirror for GNOME and starts it with your session.
set -euo pipefail
repo=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

if ! python3 -c 'import gi' 2>/dev/null; then
    echo "PyGObject is missing. Install python3-gobject (Fedora), python3-gi (Debian/Ubuntu) or python-gobject (Arch)." >&2
    exit 1
fi

install -Dm755 "$repo/bin/hdmi-auto-mirror" "$HOME/.local/bin/hdmi-auto-mirror"
install -Dm644 "$repo/gnome/hdmi-auto-mirror.service" "$HOME/.config/systemd/user/hdmi-auto-mirror.service"

systemctl --user daemon-reload
systemctl --user enable hdmi-auto-mirror.service

echo "Installed. The daemon starts at your next GNOME login."
echo "To start it now: systemctl --user start hdmi-auto-mirror.service"
