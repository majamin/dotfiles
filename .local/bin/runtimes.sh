#!/bin/sh
now=$(date +%s)

file="$1"

mask(){
	sed -i "$1s|^include|//include|" $file
	#echo "$1 will be masked"
}

unmask(){
	sed -i "$1s|^//include|include|" $file
	#echo "$1 will be unmasked"
}


while read LINE; do
	linenum=$(printf "%s" "$LINE" | grep -Po "^\d+")
	nextnum=$(( linenum + 1 ))
	begtime=$(printf "%s" "$LINE" | grep -oP "(?<=//BEG:).+(?=;EXP)" | xargs -I{} date -d {} +%s)
	exptime=$(printf "%s" "$LINE" | grep -oP "(?<=;EXP:).*" | xargs -I{} date -d {} +%s)

	#[[ -n $(printf "%s" "$LINE" | grep -Po "://") ]] && m=1 || m=0
	[[ $now -lt $begtime ]] && b=1 || b=0
	[[ $now -gt $exptime ]] && e=1 || e=0

	[[ $e -eq 1 ]] && mask $nextnum
	[[ $now -lt $b ]] && mask $nextnum
	[[ ($b -ne 1) && (e -ne 1) ]] && unmask $nextnum

done <<< $(grep -n "// *BEG" $file)
