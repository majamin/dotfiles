#!/bin/bash

set -euo pipefail

input_dir="${1:-.}"
output_pdf="${2:-stapled_$(date +%Y%m%d_%H%M%S).pdf}"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

# 1. Collect all visual files
find "$input_dir" -maxdepth 1 -type f \( \
    -iname '*.jpg' \
    -o -iname '*.jpeg' \
    -o -iname '*.bmp' \
    -o -iname '*.png' \
    -o -iname '*.tif' \
    -o -iname '*.tiff' \
    -o -iname '*.webp' \
    \) > "$tmpdir/filelist.txt"

# 2. Launch nsxiv for selection and pre-processing
cat "$tmpdir/filelist.txt" | nsxiv -tro -i - > "$tmpdir/selected.txt"

[ ! -s "$tmpdir/selected.txt" ] && echo "No files selected." && exit 1

# 3. Convert everything to high-res color images (for OCR)
page=0
while read -r file; do
    mimetype=$(file --mime-type -b "$file")
    case "$mimetype" in
        image/*)
            cp "$file" "$tmpdir/page_${page}.png"
            ;;
        application/pdf)
            pdftoppm -png -r 300 "$file" "$tmpdir/page_${page}"
            ;;
        *)
            echo "Skipping unsupported: $file"
            ;;
    esac
    page=$((page + 1))
done < "$tmpdir/selected.txt"

# 4. (Optional) Deskew
for img in "$tmpdir"/page_*.png; do
    deskew -o "$img" "$img"
done

# 5. Merge all images into a single intermediate PDF (lossless, full color)
merged_pdf="$tmpdir/merged.pdf"
img2pdf --auto-orient --output "$merged_pdf" "$tmpdir"/page_*.png

# 6. Get earliest modification time from selected files and apply OCR to the merged PDF
earliest_ts=$(while read -r file; do
    stat --format '%Y' "$file"
done < "$tmpdir/selected.txt" | sort -n | head -n1)

# Convert to PDF metadata format: YYYY-MM-DDTHH:MM:SS
pdf_date=$(date -u -d "@$earliest_ts" +"%Y-%m-%dT%H:%M:%S")

ocrmypdf \
    --optimize 3 \
    --output-type pdfa \
    --pdfa-image-compression lossless \
    --jobs "$(nproc)" \
    --rotate-pages \
    "$merged_pdf" "$output_pdf"

# 7. Set PDF metadata creation/modification date (PDF-level, not filesystem)
if command -v exiftool &>/dev/null; then
    exiftool -overwrite_original \
        -CreateDate="$pdf_date" \
        -ModifyDate="$pdf_date" \
        -MetadataDate="$pdf_date" \
        "$output_pdf"
else
    echo "⚠️  exiftool not installed: skipping embedded metadata timestamp"
fi

# 8. Also set the filesystem modification time
touch -d "$pdf_date" "$output_pdf"

# 9. Move original input files to a 'processed/' folder
processed_dir="$input_dir/processed"
mkdir -p "$processed_dir"

while read -r file; do
    mv -n "$file" "$processed_dir/"
done < "$tmpdir/selected.txt"

echo "📁 Moved originals to: $processed_dir"
echo "✅ Searchable PDF created: $output_pdf"
