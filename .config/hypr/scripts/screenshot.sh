#!/bin/bash
MODE=${1:-region}
SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"
FILE="$SAVE_DIR/Screenshot_$(date +%Y%m%d_%H%M%S).png"

case "$MODE" in
    region)
        grim -g "$(slurp)" "$FILE" && swappy -f "$FILE"
        wl-copy < "$FILE"
        notify-send -i "$FILE" -t 4000 "Screenshot" "Region saved"
        ;;
    full)
        grim - | swappy -f -
        ;;
    window)
        GEOMETRY=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        grim -g "$GEOMETRY" - | swappy -f -
        ;;
esac
