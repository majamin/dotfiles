#!/bin/sh

# Requires user to be in video group and:
# -- /etc/udev/rules.d/backlight.rules --
# ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video $sys$devpath/brightness", RUN+="/bin/chmod g+w $sys$devpath/brightness"

updown="$1"

CURR_BRIGHTNESS=$(cat /sys/class/backlight/intel_backlight/brightness)
MAX_BRIGHTNESS=$(cat /sys/class/backlight/intel_backlight/max_brightness)

STEP=$( echo "$MAX_BRIGHTNESS" / 12 | bc )
TARGET_BRIGHTNESS=$( echo "$CURR_BRIGHTNESS" " + " "$updown" " * " "$STEP" | bc )

[ "$TARGET_BRIGHTNESS" -gt "$MAX_BRIGHTNESS" ] && TARGET_BRIGHTNESS="$MAX_BRIGHTNESS"
tick=$( echo "$TARGET_BRIGHTNESS / $MAX_BRIGHTNESS * 12" | bc -l )

echo $TARGET_BRIGHTNESS > /sys/class/backlight/intel_backlight/brightness
bar=$(seq -s "──" 0 "$tick" | sed 's/[0-9]//g')
notify-send -t 1500 -r 1010 -h string:bgcolor:#111111 -h string:fgcolor:#eeeeee "益 $bar"
