#!/bin/sh

# NOTE:
# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
# usage e.g. (orange background, black foreground):
#     ^c$black^ ^b$orange^
black=#1e222a
green=#7eca9c
white=#abb2bf
grey=#282c34
blue=#7aa2f7
orange=#ff9e64
red=#d47d85
darkblue=#668ee3

# NOTE: Here as a reference (unused)
# gitwatch() {
#   LOG="$HOME/git_report.log"
#   rm -f $LOG 2>/dev/null
#   FLAGS=()
#
#   git_ls_files(){
#     printf "%s" "$(git -C "$1" ls-files --modified | sed '/^ *$/d')"
#   }
#
#   # TODO: add $HOME repo
#   DIRS="$HOME $(find "$HOME/.local/src" -maxdepth 1 -type d)"
#
#   # check src repos
#   for DIR in $DIRS; do
#     FILES="$(git_ls_files ${DIR})"
#     if [[ -z "$FILES" ]]; then
#       continue
#     else
#       GITFLAG=true
#       for FILE in $FILES; do
#         echo -e "$DIR/$FILE" >> "$LOG"
#       done
#     fi
#   done
#
#   [[ $GITFLAG == true ]] && \
#     printf "^c$black^ ^b$orange^ 療" && \
#     printf "^c$white^ ^b$black^ $(cat $LOG | wc -l)"
# }

# NOTE: ARCH LINUX
# pkg_updates() {
#   updates=$(checkupdates | wc -l) # requires `pacman-contrib`
#   if [ "$updates" -gt 0 ]; then
#     printf "  ^c$green^    $updates"" updates"
#   fi
# }

# cpu performance (Fn+l, Fn+m, Fn+h) - Some ThinkPad models?
cpuperf() {
  perf=$(cat /sys/firmware/acpi/platform_profile)
  case "$perf" in
    "low-power")   perficon="^c$green^󱟮 ^c$white^LOW" ;;
    "balanced")    perficon="^c$blue^󱟭 ^c$white^BAL" ;;
    "performance") perficon="^c$orange^󱟬 ^c$white^MAX" ;;
  esac
  printf %s "$perficon"
}

battery() {
  for battery in /sys/class/power_supply/BAT?
  do
    # Get its remaining capacity and charge status.
    batt_warn=0
    capacity=$(cat "$battery"/capacity) || break
    [ "$capacity" -le 100 ] && baticon="$(echo -e  "󰁹")"
    [ "$capacity" -le 98 ] && baticon="$(echo -e  "󰂂")"
    [ "$capacity" -le 90 ] && baticon="$(echo -e  "󰂁")"
    [ "$capacity" -le 80 ] && baticon="$(echo -e  "󰂀")"
    [ "$capacity" -le 70 ] && baticon="$(echo -e  "󰁿")"
    [ "$capacity" -le 60 ] && baticon="$(echo -e  "󰁾")"
    [ "$capacity" -le 50 ] && baticon="$(echo -e  "󰁽")"
    [ "$capacity" -le 40 ] && baticon="$(echo -e  "󰁼")"
    [ "$capacity" -le 30 ] && baticon="$(echo -e  "󰁻")"
    [ "$capacity" -le 20 ] && baticon="$(echo -e  "󰁺")" && batt_warn=1
    [ "$capacity" -le 10 ] && baticon="$(echo -e   "󰂃")" && batt_warn=1

    status=$(cat "$battery"/status) || break

    [ "$status" = "Discharging" ] && icon="$baticon"
    [ "$status" != "Discharging" ] && icon=""
  done

  [ "$batt_warn" -ne 1 ] && \
    printf "^c$blue^ %s  ^c$white^%s" "$icon" "$capacity" || \
    printf "^c$red^ %s  ^c$white^%s" "$icon" "$capacity"
}

# NOTE: requires `wpctl` (wireplumber)
# vol() {
#   vol="$(wpctl get-volume @DEFAULT_AUDIO_SINK@)"
#
#   [ "$vol" != "${vol%\[MUTED\]}" ] && printf "^c$blue^ %s ^c$white^  " "婢" && exit
#
#   vol="${vol#Volume: }"
#
#   # Omit the . without calling an external program
#   split() {
#     IFS=$2
#     set -- $1
#     printf '%s' "$@"
#   }
#
#   vol="$(printf "%.0f" "$(split "$vol" ".")")"
#
#   # 墳奄奔婢
#   case 1 in
#     $((vol >= 70)) ) icon="墳" ;;
#     $((vol >= 30)) ) icon="奔" ;;
#     $((vol >= 1)) ) icon="奄" ;;
#     * ) printf "^c$blue^ %s ^c$white^  " "婢" && exit ;;
#   esac
#
#   # printf "^c$blue^%s^c $white^%s" "$icon" "$vol"
#   printf "^c$blue^ %s ^c$white^%s" "$icon" "$vol"
# }

sys() {
  CPU=$(grep -o "^[^ ]*" /proc/loadavg)
  printf "^c$green^ 閭 ^c$white^ %s " "$CPU"

  MEM=$(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)
  printf "^c$green^ 礪 ^c$white^ %s " "$MEM"
}

net() {
  type=$(ip route get 8.8.8.8 | grep -Po 'dev \K\w+' | grep -qFf - /proc/net/wireless && echo wireless || echo wired)
  ssid="$(wpa_cli status | grep -Po "(?<=^ssid=).*")"
  icon=""
  [ "$type" = "wireless" ] && icon="直"
  if [[ "$(cat /sys/class/net/*/operstate 2>/dev/null)" == *"up"* ]]; then
    if [[ "$type" = "wireless" ]]; then
      printf "^c$blue^ $icon ^d^%s" "^c$white^$ssid"
    else
      printf "^c$blue^ $icon ^d^%s" "^c$white^$domain"
    fi
  else
    printf "^c$blue^ 爵 ^d^%s" " ^c$white^Disconnected"
  fi
}

clock() {
  # printf "^c$black^ ^b$darkblue^ 󱑆 "
  printf "^c$black^^b$blue^ $(date '+%d %b %H:%M')  "
}

while true; do

  interval=$((interval + 1))

  # MINUTE UPDATES
  [ $interval = 0 ] || [ $(($interval % 60)) = 0 ] && \
    net_result=$(net)

  # HOURLY UPDATES
  # [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && \
    # updates=$(pkg_updates) && \
    # gits=$(gitwatch)

    sleep 1 && xsetroot -name "$(cpuperf) $(battery) $(sys) $(net &) $(clock)"
done
