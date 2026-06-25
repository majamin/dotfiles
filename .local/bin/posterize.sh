#!/bin/bash
# posterize.sh — tile a large image into printable pages for a poster.
#
# It prints at native resolution: you give the DPI and the paper, and the page
# count and best orientation are worked out from the image's own pixels. No
# upscaling ever happens, so detail is preserved.
set -euo pipefail

PROG=$(basename "$0")

usage() {
  local code=${1:-2} fd=1
  [ "$code" -eq 0 ] || fd=2
  cat >&"$fd" <<EOF
$PROG — tile a large image into printable pages for a poster.

Usage: $PROG [options] <image>
  -p, --paper <size>   letter|legal|tabloid|a3|a4|a5     (default: letter)
  -d, --dpi <n>        print resolution                  (default: 150)
  -o, --overlap <n>    glue margin between pages, e.g. 10mm or 0.25in
                       (bare number = mm)                (default: 0)
      --portrait       force portrait pages
      --landscape      force landscape pages   (default: auto, fewest pages)
  -b, --border <px>    draw a black cut guide this many px wide around each page
                       (default: 0, off)
  -O, --output <file>  output PDF                        (default: poster_output.pdf)
  -h, --help           show this help

The grid is computed as ceil(image_px / (paper_inches * dpi)); higher DPI prints
the image smaller and so needs fewer pages.

Example: $PROG -p a4 -d 600 huge.png
EOF
  exit "$code"
}

# --- defaults ---------------------------------------------------------------
PAPER=letter; DPI=150; OVERLAP=0; ORIENT=auto; BORDER=0; OUT=poster_output.pdf
POS=()

# --- parse args -------------------------------------------------------------
while [ $# -gt 0 ]; do
  case $1 in
    -p|--paper)   PAPER=${2:?}; shift 2;;
    -d|--dpi)     DPI=${2:?}; shift 2;;
    -o|--overlap) OVERLAP=${2:?}; shift 2;;
    -O|--output)  OUT=${2:?}; shift 2;;
    --portrait)   ORIENT=portrait; shift;;
    --landscape)  ORIENT=landscape; shift;;
    -b|--border)  BORDER=${2:?}; shift 2;;
    -h|--help)    usage 0;;
    --)           shift; while [ $# -gt 0 ]; do POS+=("$1"); shift; done;;
    -*)           echo "$PROG: unknown option: $1" >&2; usage;;
    *)            POS+=("$1"); shift;;
  esac
done

[ ${#POS[@]} -eq 1 ] || usage
IMG=${POS[0]}

# --- validate ---------------------------------------------------------------
[ -f "$IMG" ] || { echo "$PROG: no such file: $IMG" >&2; exit 1; }
[[ $DPI =~ ^[0-9]+$ && $DPI -gt 0 ]] || { echo "$PROG: dpi must be a positive integer" >&2; exit 1; }
[[ $BORDER =~ ^[0-9]+$ ]] || { echo "$PROG: border must be a non-negative integer (px)" >&2; exit 1; }

# paper dimensions: width height unit (portrait)
case ${PAPER,,} in
  letter)  pw=8.5 ph=11  unit=in;;
  legal)   pw=8.5 ph=14  unit=in;;
  tabloid) pw=11  ph=17  unit=in;;
  a3)      pw=297 ph=420 unit=mm;;
  a4)      pw=210 ph=297 unit=mm;;
  a5)      pw=148 ph=210 unit=mm;;
  *) echo "$PROG: unknown paper size: $PAPER (letter|legal|tabloid|a3|a4|a5)" >&2; exit 1;;
esac

# overlap: bare number = mm, or an explicit mm/in suffix
ov_unit=mm; ov_val=$OVERLAP
case $OVERLAP in *mm) ov_val=${OVERLAP%mm};; *in) ov_val=${OVERLAP%in}; ov_unit=in;; esac
[[ $ov_val =~ ^[0-9]+([.][0-9]+)?$ ]] || { echo "$PROG: bad overlap: $OVERLAP" >&2; exit 1; }

# physical dimension -> pixels at DPI (round to nearest)
topx() { awk -v v="$1" -v u="$2" -v d="$DPI" 'BEGIN{print int((u=="in"?v*d:v/25.4*d)+0.5)}'; }
P_W=$(topx "$pw" "$unit"); P_H=$(topx "$ph" "$unit")   # portrait page, px
OVp=$(topx "$ov_val" "$ov_unit")

[ "$OVp" -lt "$P_W" ] || { echo "$PROG: overlap ($OVp px) is too large for the page" >&2; exit 1; }

# image size in pixels
read -r W H < <(identify -format '%w %h\n' "$IMG[0]")

# pages needed to cover LEN px with pages of SIZE px overlapping by OVp:
#   N*SIZE - (N-1)*OVp >= LEN   =>   N = ceil((LEN - OVp) / (SIZE - OVp))
pages_along() {
  local len=$1 size=$2 step n
  step=$((size - OVp))
  n=$(( (len - OVp + step - 1) / step ))
  ((n < 1)) && n=1
  echo "$n"
}

# Pick orientation. "auto" chooses whichever needs fewer pages (ties -> portrait).
pick() { # paper_w paper_h -> "cols rows pages"
  local c r; c=$(pages_along "$W" "$1"); r=$(pages_along "$H" "$2"); echo "$c $r $((c * r))"
}
read -r pc pr pp < <(pick "$P_W" "$P_H")   # portrait
read -r lc lr lp < <(pick "$P_H" "$P_W")   # landscape
case $ORIENT in
  portrait)  PW=$P_W PH=$P_H COLS=$pc ROWS=$pr;;
  landscape) PW=$P_H PH=$P_W COLS=$lc ROWS=$lr;;
  auto)      if [ "$lp" -lt "$pp" ]; then ORIENT=landscape PW=$P_H PH=$P_W COLS=$lc ROWS=$lr
             else ORIENT=portrait PW=$P_W PH=$P_H COLS=$pc ROWS=$pr; fi;;
esac

printf '%s: %sx%s px -> %d %s %s page(s) at %d dpi (%dx%d grid), overlap %s\n' \
  "$PROG" "$W" "$H" "$((COLS * ROWS))" "$PAPER" "$ORIENT" "$DPI" "$COLS" "$ROWS" "$OVERLAP" >&2

# Cut guide: solid black strips along all four page edges. Filled rectangles
# (not a stroked outline) stay crisp and don't depend on the source palette.
BORDER_DRAW=()
if [ "$BORDER" -gt 0 ]; then
  b=$BORDER
  BORDER_DRAW=(-fill black
    -draw "rectangle 0,0 $((PW - 1)),$((b - 1))"             # top
    -draw "rectangle 0,$((PH - b)) $((PW - 1)),$((PH - 1))"  # bottom
    -draw "rectangle 0,0 $((b - 1)),$((PH - 1))"             # left
    -draw "rectangle $((PW - b)),0 $((PW - 1)),$((PH - 1))") # right
fi

TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT

if [ "$OVp" -eq 0 ]; then
  # No overlap: one pass. ImageMagick tiles internally (streams the huge file),
  # then pads any short edge tiles to a full page.
  magick "$IMG[0]" -crop "${PW}x${PH}" +repage \
    -background white -gravity northwest -extent "${PW}x${PH}" \
    "${BORDER_DRAW[@]}" -density "$DPI" -units PixelsPerInch "$OUT"
else
  # Overlap: decode once into a fast random-access cache, then crop each page
  # stepping forward by (page - overlap) so neighbours share a strip.
  magick "$IMG[0]" "$TMP/src.mpc"
  i=0
  for ((r = 0; r < ROWS; r++)); do
    for ((c = 0; c < COLS; c++)); do
      x=$((c * (PW - OVp))); y=$((r * (PH - OVp)))
      magick "$TMP/src.mpc" -crop "${PW}x${PH}+${x}+${y}" +repage \
        -background white -gravity northwest -extent "${PW}x${PH}" \
        "${BORDER_DRAW[@]}" "$TMP/page_$(printf '%04d' "$i").png"
      i=$((i + 1))
    done
  done
  magick -density "$DPI" -units PixelsPerInch "$TMP"/page_*.png "$OUT"
fi

echo "Done: $OUT"
