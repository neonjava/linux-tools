# hdmi-auto-mirror

Mirrors your laptop screen to an HDMI display or TV as soon as it's connected, and moves audio to it. When you unplug, audio goes back to your speakers.

Works on **Hyprland** and **GNOME** (Wayland). One script detects which desktop you're running; each desktop has its own installer.

## Install

```sh
git clone https://github.com/neonjava/linux-tools.git
cd linux-tools/hdmi-auto-mirror
```

Then follow the section for your desktop. Make sure `~/.local/bin` is on your `PATH`.

### Hyprland

```sh
./hyprland/install.sh
```

The installer prints the lines to add to your Hyprland config. It doesn't change your config itself. See [`hyprland/hyprland.conf.example`](hyprland/hyprland.conf.example).

Needs `hyprctl`. The optional menu (`Super+Shift+M` in the example) also needs `rofi` and `jq`, and adds "external only" and "laptop only" modes.

### GNOME

```sh
./gnome/install.sh
```

The daemon then starts with each GNOME login. Needs GNOME with Wayland and PyGObject (`python3-gobject` on Fedora, `python3-gi` on Debian/Ubuntu, `python-gobject` on Arch).

For a toggle shortcut, go to Settings → Keyboard → Custom Shortcuts and use the command `hdmi-auto-mirror --toggle`, with the full path if needed.

### Requirements on both

Python 3.10+. `pactl` for audio switching and `notify-send` for notifications are optional; without them the display side still works.

## Usage

The daemon handles plugging in and unplugging. You can also run it by hand:

| Command | What it does |
| --- | --- |
| `hdmi-auto-mirror` | Show status, then mirror any connected display |
| `hdmi-auto-mirror --status` | Show desktop, monitors and audio outputs |
| `hdmi-auto-mirror --mirror` | Mirror now |
| `hdmi-auto-mirror --extend` | Extend the desktop now |
| `hdmi-auto-mirror --toggle` | Switch between mirror and extend |
| `hdmi-auto-mirror --daemon` | Watch for displays being connected |
| `--source NAME` | Use a specific source monitor instead of the detected one |
| `--no-audio` | Leave audio alone |

The log is at `~/.local/state/hdmi-auto-mirror.log`.

## Differences between desktops

- **Hyprland** keeps each display at its own resolution and scales the mirrored image.
- **GNOME** needs both displays at the same resolution, so it uses the largest one they share. A 4K TV mirroring a 1080p laptop runs at 1080p. If they share none, it shows an error and changes nothing. GNOME saves the layout to `~/.config/monitors.xml`.

## Not working?

If your HDMI display isn't detected at all, see [docs/troubleshooting.md](docs/troubleshooting.md). On laptops with two GPUs, the HDMI port is often wired to the NVIDIA GPU.

## Testing status

Developed on Fedora 44 with Hyprland, GNOME 50 and a hybrid Intel/NVIDIA laptop.

- **Hyprland:** tested with a real TV.
- **GNOME:** mirror, extend, toggle and the no-shared-resolution error are tested on virtual monitors in headless Mutter. It hasn't been tested with a real TV or a real cable plug-in yet, so reports are welcome.

## Uninstall

```sh
./uninstall.sh
```

## License

[MIT](../LICENSE)
