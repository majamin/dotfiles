#!/usr/bin/env bash


usage() {
  cat << EOF
Usage: $0 <Monitor>

Map all Wacom Devices to Monitor <Monitor>.
For example, to map to Monitor VGA-1:

  $0 VGA-1

If <Monitor> is NEXT, then to the next monitor
as listed by xrandr. Useful, for example, to bind, 
say by xbindkeys, a key to
  
  notify-send "\$(\$0 NEXT)"

EOF
  exit 1
}

next() {
[ -n "$TMPDIR" ] || TMPDIR=/tmp
WFILE="$TMPDIR/wacom2mon"

# Since 
#   xsetwacom --get "Wacom Pad pad" MapToOutput
# returns
#   'MapToOutput' is a write-only option.
# we store the output device in a temp file.
# This, woefully, cannot detect output device changes;
# for example, after a reboot.

[ -f "$WFILE" ] && monitor="$(cat "$WFILE")"

monitors="$(xrandr --listactivemonitors | tail -n2 | awk '{print $4}')"
monitors=($monitors)
num_monitors="${#monitors[@]}"
for ((i=0; i < num_monitors; i++)); do
  # trim trailing whitespaces; from https://stackoverflow.com/a/15398846
  m="$(echo "${monitors[i]}")"
  if [ "$m" = "$monitor" ]; then
    found_monitor=1
    if [ "$((i + 1))" -eq "$num_monitors" ]; then
      monitor="${monitors[0]}"
    else
      monitor="${monitors[i+1]}"
    fi
    break
  fi
done
[ -z "$found_monitor" ] && monitor="${monitors[0]}"

echo "$monitor"
echo "$monitor" > $WFILE
}

command -v xsetwacom >/dev/null 2>&1 || exit 1
echo "Wacom Devices:"
echo ""
xsetwacom --list devices | cut -f1

echo ""

command -v xrandr >/dev/null 2>&1 || exit 1
echo "Monitors:"
echo ""
xrandr --listactivemonitors | tail -n2 |  awk '{print $4}' 

echo ""

if [[ $# == 0 ]]; then
  usage
else
  screen="$1"
fi

[ "$screen" = "NEXT" ] && screen="$(next)"

devices="$(xsetwacom --list devices | cut -f 1)"
[ -z "$devices" ] && exit 1

while read -r d; do
  # trim trailing whitespaces; from https://stackoverflow.com/a/15398846
  d="$(echo $d)"
  xsetwacom --set "$d" MapToOutput "$screen"
  echo "Mapped $d to $screen"
done <<< $devices

