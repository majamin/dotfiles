#!/bin/sh

ID="1234" # notification ID (arbitrary)
MAX_VOL="120" # 100 = default

is_increasing=$(echo $1 | grep "+")

is_muted() {
  echo "$(pactl get-sink-mute @DEFAULT_SINK@ | grep 'yes')"
}

vol_trimmed() {
  echo "$(pactl get-sink-volume @DEFAULT_SINK@ | head -n1 | cut -d'/' -f2 | tr -d ' |%')"
}

# printf %s "$(vol_trimmed)"
# exit 0

notify() {
  notify-send -t 1500 -r $ID \
    -h string:bgcolor:#111122 \
    -h string:fgcolor:$3 \
    -h string:width:600px \
    "$1 $2"
}

# Prevent going above MAX
if [[ "$(vol_trimmed)" -ge $MAX_VOL ]] && [[ -n $is_increasing ]]; then
  exit 0
fi

# Handle volume input
if [[ "$1" = "toggle-mute" ]]; then
  pactl set-sink-mute @DEFAULT_SINK@ toggle
else
  pactl set-sink-volume @DEFAULT_SINK@ "$1"
fi

[[ -n "$(is_muted)" ]] && icon="婢" || icon="墳"

ticks=$(echo "$(vol_trimmed) / 10" | bc -l )
bar=$(seq -s "──" 0 $ticks | sed 's/[0-9]//g')
[ $(vol_trimmed) -gt 100 ] && col="#ff9e64" || col="#eeeeee"
notify "$icon" "$bar" "$col"
