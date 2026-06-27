#!/bin/bash
MODE_FILE="$HOME/.config/hypr/.display-mode"
MODES=(extend mirror laptop external)

case "$1" in
    lid-close)
        if hyprctl monitors all | grep -q "HDMI-A-1"; then
            echo "external" > "$MODE_FILE"
            sleep 0.3
            hyprctl reload config-only
        else
            loginctl lock-session; systemctl suspend
        fi
        exit 0
        ;;
    lid-open)
        cur=$(cat "$MODE_FILE" 2>/dev/null || echo "extend")
        if [[ "$cur" == "external" ]]; then
            echo "extend" > "$MODE_FILE"
            hyprctl reload config-only
        else
            hyprctl dispatch dpms on
        fi
        exit 0
        ;;
    extend|mirror|laptop|external)
        echo "$1" > "$MODE_FILE"
        hyprctl reload config-only
        exit 0
        ;;
esac

# No argument: open wofi menu
chosen=$(printf "%s\n" "${MODES[@]}" | wofi --style ~/.config/wofi/display_menu.css --dmenu --cache-file=/dev/null --width=800 --prompt="Select External Display Option")

if [[ -n "$chosen" ]]; then
    echo "$chosen" > "$MODE_FILE"
    hyprctl reload config-only
fi
