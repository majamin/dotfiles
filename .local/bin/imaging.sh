#!/bin/bash

# First argument is the path to the image directory (defaults to current directory)
src_dir=${1:-.}

# If src_dir is '.' or empty, use current directory without moving files
if [ "$src_dir" = "." ] || [ -z "$1" ]; then
    out_dir="."
else
    out_dir="images"
fi

# Check if the directory exists
if [ ! -d "$src_dir" ]; then
    printf "Directory '%s' does not exist" "${src_dir}"
    exit 1
fi

# Find all files in the directory using fd-find
# Pipe the output to nsxiv for image selection
mapfile -t allfiles < <(fd -e jpg -e png -e gif -e bmp -e tiff -e webp -e svg -e jpeg -e heic . "$src_dir" -0 | xargs -0 ls -t | nsxiv -troi)

# Check if the user selected any images
if [ ${#allfiles[@]} -eq 0 ]; then
    echo "No images selected"
    exit 1
fi

# Create the images subdirectory if it doesn't exist
mkdir -p "$out_dir" 2>/dev/null

# Copy the selected images to the images subdirectory with spaces replaced by hyphens
declare -a new_name
for image in "${allfiles[@]}"; do
    if [ "$out_dir" = "." ]; then
        # When using current directory, just output the original path
        echo "$image"
    else
        # Get the basename of the image and replace spaces with hyphens
        # set new extension to png
        new_name=$(basename "$image" | tr ' ' '-' | sed 's/\(.*\)\..*/\1.png/')

        # convert image to png using image magick,
        # and copy the file to the images/ directory with the new name
        magick "$image" -auto-orient -resize 1600x "${out_dir}/${new_name}"

        # Print the new name of the image
        echo "$new_name"
    fi
done
