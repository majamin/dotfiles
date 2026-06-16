#!/bin/bash

set -euo pipefail

checkpoint="/sys/class/power_supply/AC/online"
read -r current < "$checkpoint"

check_and_set() {
  if [ "$1" = "1" ]; then
    /usr/bin/brightnessctl set 60%
  else
    /usr/bin/brightnessctl set 25%
  fi
}

check_and_set "$current"

while true; do
  sleep 1
  read -r next < "$checkpoint"
  if [ "$current" = "$next" ]; then
    continue
  else
    check_and_set "$next"
  fi
  current="$next"
done
