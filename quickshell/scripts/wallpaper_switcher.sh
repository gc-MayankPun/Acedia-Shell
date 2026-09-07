#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
STATE_FILE="$HOME/.cache/wallpaper-no-wallpapers-notified"

if ! find "$WALLPAPER_DIR" -maxdepth 1 -type f \
    \( -iname "*.jpg" \
    -o -iname "*.jpeg" \
    -o -iname "*.png" \
    -o -iname "*.gif" \
    -o -iname "*.webp" \
    -o -iname "*.bmp" \) \
    -print -quit | grep -q .; then

    if [[ ! -f "$STATE_FILE" ]]; then
        notify-send \
            -u critical \
            "No wallpapers found" \
            "Put your wallpapers in ~/Pictures/Wallpapers"

        touch "$STATE_FILE"
    fi

    exit 0
fi

# Wallpapers exist, reset notification state
rm -f "$STATE_FILE"

quickshell ipc call wallpaper toggle