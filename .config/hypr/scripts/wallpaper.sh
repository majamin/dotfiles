#!/bin/bash
exec 9>/tmp/wallpaper.lock
flock -n 9 || exit 0

WALL_DIR="$HOME/Maja/Media/Images/Backgrounds/desktop"
FALLBACK="$HOME/Pictures/paradise.png"
INTERVAL=300  # seconds between wallpapers

sleep 5

while true; do
    images=$(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) 2>/dev/null)
    if [ -z "$images" ]; then
        awww img "$FALLBACK" --transition-type wipe --transition-duration 2 --transition-fps 60
        sleep "$INTERVAL"
        continue
    fi
    echo "$images" | shuf | while read -r img; do
        awww img "$img" \
            --transition-type wipe \
            --transition-duration 2 \
            --transition-fps 60
        sleep "$INTERVAL"
    done
done
