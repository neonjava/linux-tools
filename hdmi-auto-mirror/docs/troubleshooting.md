# Troubleshooting

## Check whether the system sees the display

```sh
for c in /sys/class/drm/card*-*; do echo "$(basename "$c"): $(cat "$c/status")"; done
```

If no `HDMI` entry exists, or it stays `disconnected` with the cable in, the problem is below this tool, in the GPU setup or the cable.

## No HDMI connector on a hybrid Intel/NVIDIA laptop

On many laptops the HDMI port is wired to the NVIDIA GPU. If that GPU is off, the port doesn't exist as far as Linux is concerned.

Check for it:

```sh
lspci | grep -i nvidia
envycontrol --query    # if you use EnvyControl
```

If the GPU is missing or EnvyControl says `integrated`, switch to hybrid and reboot:

```sh
sudo envycontrol -s hybrid
```

## NVIDIA driver freezes at boot in hybrid mode

Signs of this: `nvidia-smi` hangs, Hyprland hangs or gets killed, `nvidia-persistenced` times out, and many `kacpi_notify` workers sit in `D` state.

On one laptop (RTX 4060 mobile, driver 595.80 open module) this cleared up after making all three of these changes together. Which one mattered wasn't isolated:

```sh
sudo envycontrol -s hybrid          # without --rtd3
sudo systemctl disable nvidia-powerd.service nvidia-persistenced.service
```

Then reboot. A normal reboot may stall while the driver is stuck, so you may need to hold the power button.

The trade-offs are higher battery use, because the GPU stays powered, and no Dynamic Boost.

If the system won't start properly, switch to a text console with `Ctrl+Alt+F3` and run `sudo envycontrol -s integrated`, then reboot.

## `No monitors detected`

The tool only supports Hyprland and GNOME. `hdmi-auto-mirror --status` shows which desktop it found.

## Low refresh rate on a 4K TV

30Hz at 4K usually means an HDMI 1.4 cable or a TV input in basic mode. Try a High Speed or Ultra High Speed cable, and turn on the TV's enhanced HDMI setting for that input.

## Audio doesn't switch

Run `pactl list sinks short`. The tool looks for an output with `hdmi` in its name. If there isn't one, check the audio profile in your sound settings.
