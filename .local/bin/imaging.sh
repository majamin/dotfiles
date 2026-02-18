#!/bin/bash

# Collect all source directories from arguments (default to current directory)
if [ $# -eq 0 ]; then
    src_dirs=(".")
else
    src_dirs=("$@")
fi

# Determine output mode: if all args are "." or no args given, use current directory
if [ $# -eq 0 ]; then
    out_dir="."
else
    out_dir="images"
    for dir in "${src_dirs[@]}"; do
        if [ "$dir" != "." ]; then
            break
        fi
        # If we get through all dirs and they're all ".", use "."
        if [ "$dir" = "${src_dirs[-1]}" ]; then
            out_dir="."
        fi
    done
fi

for dir in "${src_dirs[@]}"; do
    if [ ! -d "$dir" ]; then
        printf "Warning: directory '%s' does not exist\n" "$dir"
    fi
done

mapfile -t allfiles < <(
    for dir in "${src_dirs[@]}"; do
        [ -d "$dir" ] && fd -e jpg -e png -e gif -e bmp -e tiff -e webp -e svg -e jpeg -e heic . "$dir" -0
    done | xargs -0 ls -t \
         | nsxiv -troi 2>/dev/null
)

if [ ${#allfiles[@]} -eq 0 ]; then
    echo "No images found or selected"
    exit 1
fi

mkdir -p "$out_dir" 2>/dev/null

for image in "${allfiles[@]}"; do
    if [ "$out_dir" = "." ]; then
        echo "$image"
    else
        new_name=$(basename "$image" | tr ' ' '-' | sed 's/\(.*\)\..*/\1.png/')
        magick "$image" -auto-orient -resize 1600x "${out_dir}/${new_name}"
        echo "$new_name"
    fi
done
