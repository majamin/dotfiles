#!/bin/bash

INTERVAL=300

while true; do
  WALLPAPER_DIR="$HOME/Maja/Common/images-backgrounds/desktop"
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
  plasma-apply-wallpaperimage "$WALLPAPER"
  sleep $INTERVAL
done

