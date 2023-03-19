#!/bin/sh

brightnessctl set $1
ticks=$(printf %.f $(echo "$(brightnessctl g)/$(brightnessctl m)*22" | bc -l))
bar=$(seq -s "─" 0 $ticks | sed 's/[0-9]//g')
notify-send -t 1500 -r 1010 -h string:bgcolor:#111111 -h string:fgcolor:#eeeeee "益 $bar"
