#!/bin/bash

WALLPAPER="$1"
OUTPUT="$HOME/.config/quickshell/config/colors.json"
TEMP="${OUTPUT}.tmp"

if [ ! -f "$WALLPAPER" ]; then
    echo "Wallpaper does not exist: $WALLPAPER" >&2
    exit 1
fi

matugen image "$WALLPAPER" \
    --json hex \
    --source-color-index 0 \
    > "$TEMP" && mv "$TEMP" "$OUTPUT"