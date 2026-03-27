#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Convert to WebP
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🖼️
# @raycast.argument1 { "type": "text", "placeholder": "Quality (75-95)", "optional": true }
# @raycast.packageName Image Tools

# Documentation:
# @raycast.description Convert selected images to WebP (Squoosh-like quality)
# @raycast.author Marcin
# @raycast.authorURL https://raycast.com

# Default quality like Squoosh
QUALITY="${1:-82}"

# Check if cwebp is installed
if ! command -v cwebp &> /dev/null; then
    echo "❌ Install webp: brew install webp"
    exit 1
fi

# Get selected files from Finder
FILES=$(osascript -e '
tell application "Finder"
    set selectedItems to selection
    if selectedItems is {} then
        return ""
    end if
    set filePaths to ""
    repeat with i in selectedItems
        set filePaths to filePaths & POSIX path of (i as alias) & linefeed
    end repeat
    return filePaths
end tell
')

if [ -z "$FILES" ]; then
    echo "❌ Select files in Finder"
    exit 1
fi

COUNT=0
SAVED=0

while IFS= read -r file; do
    [ -z "$file" ] && continue
    
    # Check if it's an image
    EXT="${file##*.}"
    EXT_LOWER=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')
    
    if [[ "$EXT_LOWER" =~ ^(jpg|jpeg|png|tiff|tif|gif|bmp)$ ]]; then
        DIR=$(dirname "$file")
        BASENAME=$(basename "$file" ".$EXT")
        OUTPUT="$DIR/${BASENAME}.webp"
        
        # Size before
        SIZE_BEFORE=$(stat -f%z "$file" 2>/dev/null || echo 0)
        
        # Conversion with Squoosh-like settings
        # -q: quality (0-100)
        # -m 6: best compression (slower, but better quality)
        # -af: auto-filter for better quality
        # -sharp_yuv: better color conversion (important for Squoosh-like quality)
        cwebp -q "$QUALITY" -m 6 -af -sharp_yuv -quiet "$file" -o "$OUTPUT" 2>/dev/null
        
        if [ -f "$OUTPUT" ]; then
            SIZE_AFTER=$(stat -f%z "$OUTPUT" 2>/dev/null || echo 0)
            if [ "$SIZE_BEFORE" -gt 0 ]; then
                REDUCTION=$((100 - (SIZE_AFTER * 100 / SIZE_BEFORE)))
                SAVED=$((SAVED + SIZE_BEFORE - SIZE_AFTER))
            fi
            ((COUNT++))
        fi
    fi
done <<< "$FILES"

if [ $COUNT -gt 0 ]; then
    # Format saved space
    if [ $SAVED -gt 1048576 ]; then
        SAVED_FMT="$(echo "scale=1; $SAVED/1048576" | bc)MB"
    elif [ $SAVED -gt 1024 ]; then
        SAVED_FMT="$(echo "scale=1; $SAVED/1024" | bc)KB"
    else
        SAVED_FMT="${SAVED}B"
    fi
    echo "✅ Converted $COUNT files (saved ~$SAVED_FMT)"
else
    echo "❌ No images found to convert"
fi
