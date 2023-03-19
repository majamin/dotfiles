#!/bin/sh

wpctl set-volume @DEFAULT_AUDIO_SINK@ -l 1.2 $1
vol="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d':' -f2)"
vol=$(printf %.f "$(echo "$vol * 100" | bc -l)")
ticks=$(printf %.f $(echo "$vol" / 5.5 | bc -l))
bar=$(seq -s "─" 0 $ticks | sed 's/[0-9]//g')
[[ $vol = "0" ]] && icon="婢" || icon="墳"
notify-send -t 1500 -r 1010 -h string:bgcolor:#111122 -h string:fgcolor:#eeeeee "$icon $bar"
