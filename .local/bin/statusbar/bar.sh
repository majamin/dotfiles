#!/bin/bash

interval=0

# load colors
# usage e.g. (orange background, black foreground):
#     ^c$black^ ^b$orange^
black=#1e222a
green=#7eca9c
brightwhite=#ffffff
white=#abb2bf
grey=#282c34
blue=#7aa2f7
orange=#ff9e64
red=#b40000
darkblue=#668ee3

# Used in CPU usage
green0=#003402
green1=#005404
green2=#007301
green3=#009300
green4=#00b400
green5=#00d500
green6=#0df71a

# Arch Linux Updates
arch_pkg_updates() {
  updates=$(checkupdates | wc -l) # requires `pacman-contrib`
  if [ "$updates" -gt 0 ]; then
    printf "  ^c$orange^   📦 $updates "
  fi
}

# CPU performancep profile
# Some Thinkpad models and others (Fn+l, Fn+m, Fn+h)
cpuperf() {
  perf=$(cat /sys/firmware/acpi/platform_profile)
  case "$perf" in
  "low-power") perficon="^c$green^󱟮 ^c$white^LOW" ;;
  "balanced") perficon="^c$blue^󱟭 ^c$white^BAL" ;;
  "performance") perficon="^c$orange^󱟬 ^c$white^MAX" ;;
  esac
  printf %s "$perficon"
}

battery() {
  for battery in /sys/class/power_supply/BAT?; do
    # Get its remaining capacity and charge status.
    batt_warn=0
    capacity=$(cat "$battery"/capacity) || break
    [ "$capacity" -le 100 ] && baticon="$(echo -e "󰁹")"
    [ "$capacity" -le 98 ] && baticon="$(echo -e "󰂂")"
    [ "$capacity" -le 90 ] && baticon="$(echo -e "󰂁")"
    [ "$capacity" -le 80 ] && baticon="$(echo -e "󰂀")"
    [ "$capacity" -le 70 ] && baticon="$(echo -e "󰁿")"
    [ "$capacity" -le 60 ] && baticon="$(echo -e "󰁾")"
    [ "$capacity" -le 50 ] && baticon="$(echo -e "󰁽")"
    [ "$capacity" -le 40 ] && baticon="$(echo -e "󰁼")"
    [ "$capacity" -le 30 ] && baticon="$(echo -e "󰁻")"
    [ "$capacity" -le 20 ] && baticon="$(echo -e "󰁺")" && batt_warn=1
    [ "$capacity" -le 10 ] && baticon="$(echo -e "󰂃")" && batt_warn=1

    status=$(cat "$battery"/status) || break

    [ "$status" = "Discharging" ] && icon="$baticon"
    [ "$status" != "Discharging" ] && icon=""
  done

  [ "$batt_warn" -ne 1 ] &&
    printf "^c$blue^ %s  ^c$white^%s" "$icon" "$capacity" ||
    printf "^c$red^ %s  ^c$white^%s" "$icon" "$capacity"
}

# Get Volume
# NOTE: requires `wpctl` (wireplumber)
vol() {
  vol="$(wpctl get-volume @DEFAULT_AUDIO_SINK@)"

  [ "$vol" != "${vol%\[MUTED\]}" ] && printf "^c$blue^ %s ^c$white^  " "婢" && exit

  vol="${vol#Volume: }" # remove "Volume: "
  vol="${vol//0./}"     # remove leading 0.
  vol="${vol//./}"      # remove ., if over 100%

  case 1 in
  $((vol >= 70))) icon="墳" ;;
  $((vol >= 30))) icon="奔" ;;
  $((vol >= 1))) icon="奄" ;;
  *) printf "^c$blue^ %s ^c$white^  " "婢" && exit ;;
  esac

  # printf "^c$blue^%s^c $white^%s" "$icon" "$vol"
  printf "^c$blue^ %s ^c$white^%s" "$icon" "$vol"
}

# Get CPU usage as colored boxes
cpu() {
  # based on https://github.com/LukeSmithxyz/voidrice/blob/master/.local/bin/statusbar/sb-cpubars
  cache=/tmp/cpubarscache

  # id total idle
  stats=$(awk '/cpu[0-9]+/ {printf "%d %d %d\n", substr($1,4), ($2 + $3 + $4 + $5), $5 }' /proc/stat)
  [ ! -f $cache ] && echo "$stats" >"$cache"
  old=$(cat "$cache")
  printf "^c$green^ 閭 ^c$white^"
  echo "$stats" | while read -r row; do
    id=${row%% *}
    rest=${row#* }
    total=${rest%% *}
    idle=${rest##* }

    case "$(echo "$old" | awk '{if ($1 == id)
		printf "%d\n", (1 - (idle - $3)  / (total - $2))*100 /12.5}' \
      id="$id" total="$total" idle="$idle")" in

    "0") printf "^c$green0^█^c$white^" ;;
    "1") printf "^c$green1^█^c$white^" ;;
    "2") printf "^c$green2^█^c$white^" ;;
    "3") printf "^c$green3^█^c$white^" ;;
    "4") printf "^c$green4^█^c$white^" ;;
    "5") printf "^c$green5^█^c$white^" ;;
    "6") printf "^c$green6^█^c$white^" ;;
    "7") printf "^c$green6^█^c$white^" ;;
    "8") printf "^c$green6^█^c$white^" ;;
    esac
  done
  printf "\\n"
  echo "$stats" >"$cache"
}

mem() {
  MEM=$(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)
  printf "^c$green^ 礪 ^c$white^ %s " "$MEM"
}

net() {
  type=$(ip route get 8.8.8.8 | grep -Po 'dev \K\w+' | grep -qFf - /proc/net/wireless && echo wireless || echo wired)
  ssid="$(nmcli -t -f active,ssid dev wifi | grep -e '^yes' | cut -d\: -f2)"
  icon=""
  if [[ "$type" = "wireless" ]]; then icon="直"; fi
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
  printf "^c$black^^b$blue^ $(date '+%d %b %H:%M %a')  "
}

while true; do

  interval=$((interval + 1))

  # MINUTE UPDATES
  [ $interval = 0 ] || [ $(($interval % 60)) = 0 ] &&
    net_result=$(net)

  # HOURLY UPDATES
  # [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && \
  # [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && \
  #   updates=$(pkg_updates)

  sleep 1 && xsetroot -name "$(arch_pkg_updates) $(cpu) $(mem) $(cpuperf) $(battery) $(vol) $(net &) $(clock)"
done

#====================================================================
# NOTE: ARCHIVE / REFERENCE
#====================================================================

# Arch Linux 2
# arch_pkg_updates() {
#   pacman -Qu | grep -Fcv "[ignored]" | sed "s/^/📦/;s/^📦0$//g"
# }

## Gentoo
## requires `genlop`
# gentoo_pkg_updates() {
#   # doas /usr/bin/emerge --sync &>/dev/null
#   temp="$HOME/.local/share/emerge-dup-updates.txt"
#   [ ! -f "$temp" ] && touch "$temp"
#   if [ -n "$(find "$temp" -mmin +60)" ]; then
#     date >"$temp"
#     emerge -puD --with-bdeps=y --color=n @world >"$temp"
#   fi
#   num_updates=$(cat "$temp" | grep '\[ebuild' | wc -l)
#   estimated_emerge_time=$(cat "$temp" | genlop -np | tail -n1 | cut -d':' -f2 | grep -Po "\d+ \w*")
#   if [ "$num_updates" -gt 0 ]; then
#     printf "  ^c$brightwhite^     ^c$white^$num_updates ($estimated_emerge_time)"
#   fi
# }

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
