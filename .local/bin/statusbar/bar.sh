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
    printf "^c$black^ ^b$orange^ GIT" && \
    printf "^c$white^ ^b$grey^ $(cat $LOG | wc -l)"
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

    [ "$status" = "Discharging" ] && icon=" $baticon"
    [ "$status" != "Discharging" ] && icon=""
  done
  printf "^c$blue^ $icon $capacity"
}

sys() {
  printf "^c$black^ ^b$green^ SYS"

  CPU=$(grep -o "^[^ ]*" /proc/loadavg)
  printf "^c$green^ ^b$grey^ CPU"
  printf "^c$white^ ^b$grey^$CPU"

  MEM=$(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)
  printf "^c$green^ ^b$grey^ MEM"
  printf "^c$white^ ^b$grey^$MEM"
}

net() {
	if [[ "$(cat /sys/class/net/*/operstate 2>/dev/null)" == *"up"* ]]; then
    printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected"
  else
    printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected"
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
