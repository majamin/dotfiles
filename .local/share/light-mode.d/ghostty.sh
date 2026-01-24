#!/bin/bash
echo "theme = GitHub Light Default" > ~/.config/ghostty/theme.conf
pkill -USR2 ghostty 2>/dev/null
