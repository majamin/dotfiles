#!/usr/bin/env bash
# wprop — Wayland window inspector (xprop replacement for Hyprland)
#
# Usage:
#   wprop          click on a window to inspect it
#   wprop -a       inspect the active window
#   wprop -l       list all windows (interactive with rofi)
#   wprop -j       raw JSON for the clicked window
#   wprop -j -a    raw JSON for the active window

set -euo pipefail

BOLD='\033[1m'
DIM='\033[2m'
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RESET='\033[0m'

usage() {
    cat <<EOF
wprop — Wayland window inspector for Hyprland

Usage:
  wprop        click a window to inspect it
  wprop -a     inspect active window
  wprop -l     list all windows (rofi picker → inspect)
  wprop -j     raw JSON output (combine with -a: wprop -j -a)
  wprop -h     this help
EOF
}

format_window() {
    local json="$1"
    local raw="${RAW:-0}"

    if [[ "$raw" == "1" ]]; then
        echo "$json" | jq '.'
        return
    fi

    echo "$json" | jq -r '
        def bool: if . then "yes" else "no" end;
        def fullscreen_mode:
            if . == 0 then "no"
            elif . == 1 then "fullscreen"
            elif . == 2 then "maximized"
            else "unknown(\(.))"
            end;
        "WM_CLASS         = \"\(.initialClass)\" → \"\(.class)\"",
        "WM_NAME          = \"\(.title)\"",
        "WM_INITIAL_TITLE = \"\(.initialTitle)\"",
        "_NET_WM_PID      = \(.pid)",
        "GEOMETRY         = \(.at[0]),\(.at[1])  \(.size[0])×\(.size[1])",
        "WORKSPACE        = \(.workspace.name) (id \(.workspace.id))",
        "MONITOR          = \(.monitor)",
        "FLOATING         = \(.floating | bool)",
        "FULLSCREEN       = \(.fullscreen | fullscreen_mode)",
        "XWAYLAND         = \(.xwayland | bool)",
        "STABLE_ID        = \(.stableId)",
        "ADDRESS          = \(.address)"
    ' | awk -F= '
        BEGIN { OFS="=" }
        {
            key = $1
            val = substr($0, index($0, "=") + 2)
            printf "\033[36m%-18s\033[0m \033[2m=\033[0m %s\n", key, val
        }
    '
}

window_at_point() {
    local x="$1" y="$2"
    hyprctl clients -j | jq \
        --argjson x "$x" --argjson y "$y" \
        '[.[] | select(
            .at[0] <= $x and $x < (.at[0] + .size[0]) and
            .at[1] <= $y and $y < (.at[1] + .size[1])
        )] | sort_by(.focusHistoryID) | first // empty'
}

mode_click() {
    echo -e "${DIM}Move cursor to a window and click...${RESET}" >&2

    local point
    point=$(slurp -p -b 00000000 -c 00BFFF 2>/dev/null) || { echo "Cancelled." >&2; exit 0; }

    # slurp -p output: "X,Y 1x1"
    local x y
    x=$(echo "$point" | awk -F'[, ]' '{print $1}')
    y=$(echo "$point" | awk -F'[, ]' '{print $2}')

    local window
    window=$(window_at_point "$x" "$y")

    if [[ -z "$window" ]]; then
        echo "No window found at ($x, $y)." >&2
        exit 1
    fi

    format_window "$window"
}

mode_active() {
    local window
    window=$(hyprctl activewindow -j)
    format_window "$window"
}

mode_list() {
    local clients
    clients=$(hyprctl clients -j)

    local selection
    selection=$(echo "$clients" | jq -r '
        .[] | "[ws:\(.workspace.name)] \(.class) — \(.title)  (\(.at[0]),\(.at[1]) \(.size[0])×\(.size[1])) addr:\(.address)"
    ' | rofi -dmenu -p "wprop" -i -theme-str 'window { width: 80%; }') || { echo "Cancelled." >&2; exit 0; }

    local addr
    addr=$(echo "$selection" | grep -oP 'addr:\K0x[0-9a-f]+')

    local window
    window=$(echo "$clients" | jq --arg addr "$addr" '.[] | select(.address == $addr)')
    format_window "$window"
}

RAW=0
MODEARG=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -j) RAW=1 ;;
        -a) MODEARG="active" ;;
        -l) MODEARG="list" ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
    esac
    shift
done

case "$MODEARG" in
    active) mode_active ;;
    list)   mode_list ;;
    *)      mode_click ;;
esac
