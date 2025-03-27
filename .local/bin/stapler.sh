#!/usr/bin/env bash

set -euo pipefail

# Use current directory if no argument or "." is provided
INPUT_DIR="${1:-.}"
INPUT_DIR="$(realpath "$INPUT_DIR")"

# Output goes into a subfolder inside the selected directory
OUT_DIR="${INPUT_DIR}/out"
TMP_LIST="/tmp/nvim_merge_list.txt"

mkdir -p "$OUT_DIR"

# Step 1: List input files
find "$INPUT_DIR" -maxdepth 1 -type f \( -iname '*.pdf' -o -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.tiff' \) \
  | sort > "$TMP_LIST"

# Step 2: Open file list in Neovim for manual grouping
nvim "$TMP_LIST"

# Step 3: Process blocks
BLOCK_NUM=1
BLOCK=()

while IFS= read -r LINE || [[ -n "$LINE" ]]; do
    if [[ -z "$LINE" ]]; then
        if [[ ${#BLOCK[@]} -gt 0 ]]; then
            echo "🔧 Processing block $BLOCK_NUM with ${#BLOCK[@]} files..."

            TMP_PDF_DIR="/tmp/staple_block_$BLOCK_NUM"
            mkdir -p "$TMP_PDF_DIR"
            PAGE=1

            for FILE in "${BLOCK[@]}"; do
                EXT="${FILE##*.}"
                EXT_LOWER=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')

                if [[ "$EXT_LOWER" =~ ^(jpg|jpeg|png|tiff|bmp)$ ]]; then
                    IMG_PDF="$TMP_PDF_DIR/page_$PAGE.pdf"
                    img2pdf "$FILE" -o "$IMG_PDF"
                elif [[ "$EXT_LOWER" == "pdf" ]]; then
                    cp "$FILE" "$TMP_PDF_DIR/page_$PAGE.pdf"
                fi
                PAGE=$((PAGE + 1))
            done

            TIMESTAMP=$(date +%Y%m%d_%H%M%S)
            MERGED="$OUT_DIR/stapled_${TIMESTAMP}.pdf"

            pdftk "$TMP_PDF_DIR"/*.pdf cat output "$MERGED"

            echo "✅ Stapled block $BLOCK_NUM → $MERGED"

            # OCR pass
            OCR_OUT="${MERGED%.pdf}_ocr.pdf"
            ocrmypdf --output-type pdfa --jobs 4 --deskew --clean "$MERGED" "$OCR_OUT"
            mv "$OCR_OUT" "$MERGED"
            echo "🧠 OCR complete for block $BLOCK_NUM"

            rm -rf "$TMP_PDF_DIR"
            BLOCK=()
            BLOCK_NUM=$((BLOCK_NUM + 1))
        fi
    else
        BLOCK+=("$LINE")
    fi
done < <(cat "$TMP_LIST"; echo)

echo "🎉 All blocks processed. Output in '$OUT_DIR/'"

