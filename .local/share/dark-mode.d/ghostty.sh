#!/bin/bash
echo "theme = GitHub Dark Dimmed" > ~/.config/ghostty/theme.conf
pkill -USR2 ghostty 2>/dev/null
