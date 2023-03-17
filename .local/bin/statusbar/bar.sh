#!/bin/sh

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
black=#1e222a
green=#7eca9c
white=#abb2bf
grey=#282c34
blue=#7aa2f7
orange=#ff9e64
red=#d47d85
darkblue=#668ee3

gitwatch() {
  LOG="$HOME/git_report.log"
  rm -f $LOG 2>/dev/null
  FLAGS=()

  git_ls_files(){
    printf "%s" "$(git -C "$1" ls-files --modified | sed '/^ *$/d')"
  }

  # TODO: add $HOME repo
  DIRS="$HOME $(find "$HOME/.local/src" -maxdepth 1 -type d)"

  # check src repos
  for DIR in $DIRS; do
    FILES="$(git_ls_files ${DIR})"
    if [[ -z "$FILES" ]]; then
      continue
    else
      GITFLAG=true
      for FILE in $FILES; do
        echo -e "$DIR/$FILE" >> "$LOG"
      done
    fi
  done

  [[ $GITFLAG == true ]] && \
    printf "^c$black^ ^b$orange^ 療" && \
    printf "^c$white^ ^b$black^ $(cat $LOG | wc -l)"
}

pkg_updates() {
  updates=$(checkupdates | wc -l) # requires `pacman-contrib`
  if [ "$updates" -gt 0 ]; then
    printf "  ^c$green^    $updates"" updates"
  fi
}

battery() {
  for battery in /sys/class/power_supply/BAT?
  do
    # Get its remaining capacity and charge status.
    capacity=$(cat "$battery"/capacity) || break
    [ "$capacity" -le 100 ] && baticon="$(echo -e "")"
    [ "$capacity" -le 75 ] && baticon="$(echo -e "")"
    [ "$capacity" -le 50 ] && baticon="$(echo -e "")"
    [ "$capacity" -le 25 ] && baticon="$(echo -e "")"
    [ "$capacity" -le 10 ] && baticon="$(echo -e "")"

    status=$(cat "$battery"/status) || break

    [ "$status" = "Discharging" ] && icon="$baticon"
    [ "$status" != "Discharging" ] && icon=""
  done
  printf "^c$blue^ $icon  $capacity"
}

sys() {
  CPU=$(grep -o "^[^ ]*" /proc/loadavg)
  printf "^c$green^ 閭 ^c$white^ %s " "$CPU"

  MEM=$(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)
  printf "^c$green^ 礪 ^c$white^ %s " "$MEM"
}

net() {
  type=$(ip route get 8.8.8.8 | grep -Po 'dev \K\w+' | grep -qFf - /proc/net/wireless && echo wireless || echo wired)
  domain="$(nmcli -t -f active,ssid | grep -Po "(?<=domains: ).*")"
  icon=""
  [ "$type" = "wireless" ] && icon="直"
  if [[ "$(cat /sys/class/net/*/operstate 2>/dev/null)" == *"up"* ]]; then
    printf "^c$blue^ $icon ^d^%s" "^c$white^$domain"
  else
    printf "^c$blue^ 爵 ^d^%s" " ^c$white^Disconnected"
  fi
}

clock() {
  # printf "^c$black^ ^b$darkblue^ 󱑆 "
  printf "^c$black^^b$blue^ $(date '+%d %b %H:%M')  "
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && \
    updates=$(pkg_updates) && \
    gits=$(gitwatch)

  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$updates $gits $(battery) $(sys) $(net) $(clock)"
done
