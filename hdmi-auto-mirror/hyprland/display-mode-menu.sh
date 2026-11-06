#!/usr/bin/env bash
# Rofi menu for switching display mode on Hyprland.
# Needs: rofi, jq, notify-send, and hdmi-auto-mirror on PATH.

if pidof rofi > /dev/null; then
    pkill rofi
fi

opt_mirror="🔄 Mirror to External Display (TV)"
opt_extend="🖥️ Extend Desktop"
opt_external="📺 External Display Only"
opt_internal="💻 Laptop Display Only"
opt_status="📊 Display Status"

chosen=$(printf "%s\n%s\n%s\n%s\n%s\n" "$opt_mirror" "$opt_extend" "$opt_external" "$opt_internal" "$opt_status" | rofi -dmenu -i -p "Display Mode:" -mesg "Manage HDMI / External Screen Setup")

monitors=$(hyprctl monitors all -j)
internal=$(jq -r '[.[] | select(.name | test("^(eDP|LVDS|DSI)"))][0].name // empty' <<< "$monitors")
externals=$(jq -r '.[] | select((.name | test("^(eDP|LVDS|DSI|HEADLESS)")) | not) | .name' <<< "$monitors")

case "$chosen" in
    "$opt_mirror")
        hdmi-auto-mirror --mirror
        ;;
    "$opt_extend")
        hdmi-auto-mirror --extend
        ;;
    "$opt_external")
        external=$(head -1 <<< "$externals")
        if [ -n "$external" ] && [ -n "$internal" ]; then
            hyprctl keyword monitor "$internal, disable"
            hyprctl keyword monitor "$external, preferred, 0x0, 1"
            notify-send -u normal -i video-display "Display Mode" "Output set to $external only"
        else
            notify-send -u low -i video-display "Display Mode" "No external display detected"
        fi
        ;;
    "$opt_internal")
        if [ -z "$internal" ]; then
            notify-send -u low -i video-display "Display Mode" "No laptop display detected"
            exit 0
        fi
        hyprctl keyword monitor "$internal, preferred, 0x0, 1"
        for monitor in $externals; do
            hyprctl keyword monitor "$monitor, disable"
        done
        notify-send -u normal -i video-display "Display Mode" "Output set to laptop ($internal) only"
        ;;
    "$opt_status")
        notify-send -u normal -i video-display "Display Status" "$(hdmi-auto-mirror --status)"
        ;;
esac
