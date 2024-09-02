#!/bin/bash

# required first argument is the path to the image directory
IMAGE_DIR=$1

# Check if the directory exists
if [ ! -d "$IMAGE_DIR" ]; then
    echo "Directory does not exist"
    exit 1
fi

# Find all files in the directory using fd-find
# Pipe the output to sxiv for image selection
mapfile -t selection < <(fd -e jpg -e png -e gif -e bmp -e tiff -e webp -e svg -e jpeg -e heic . "$IMAGE_DIR" -0 | xargs -0 ls -t | sxiv -troi)

# Check if the user selected any images
if [ ${#selection[@]} -eq 0 ]; then
    echo "No images selected"
    exit 1
fi

# Create the images subdirectory if it doesn't exist
mkdir -p images 2>/dev/null

# Copy the selected images to the images subdirectory with spaces replaced by hyphens
declare -a new_name
for image in "${selection[@]}"; do
    # Get the basename of the image and replace spaces with hyphens
    # set new extension to png
    new_name=$(basename "$image" | tr ' ' '-' | sed 's/\(.*\)\..*/\1.png/')

    # convert image to png using image magick,
    # and copy the file to the images/ directory with the new name
    convert "$image" -auto-orient -resize 1600x "images/$new_name"

    # Print the new name of the image
    echo "$new_name"
done
