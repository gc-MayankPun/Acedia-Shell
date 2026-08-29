#!/bin/bash

printf '['
first=true

declare -A seen

while read -r file; do

    # ─────────────────────────────────────────────
    # Basic desktop entry information
    # ─────────────────────────────────────────────

    type=$(grep -m1 '^Type=' "$file" | cut -d= -f2-)
    name=$(grep -m1 '^Name=' "$file" | cut -d= -f2-)
    exec=$(grep -m1 '^Exec=' "$file" | cut -d= -f2-)
    icon=$(grep -m1 '^Icon=' "$file" | cut -d= -f2-)

    nodisplay=$(grep -im1 '^NoDisplay=' "$file" | cut -d= -f2-)
    hidden=$(grep -im1 '^Hidden=' "$file" | cut -d= -f2-)
    mimetype=$(grep -im1 '^MimeType=' "$file" | cut -d= -f2-)

    # ─────────────────────────────────────────────
    # Only actual applications
    # ─────────────────────────────────────────────

    [ "$type" != "Application" ] && continue

    # Hidden applications
    [ "$hidden" = "true" ] && continue
    [ "$nodisplay" = "true" ] && continue

    # Missing required information
    [ -z "$name" ] && continue
    [ -z "$exec" ] && continue

    # ─────────────────────────────────────────────
    # Remove protocol / URI handlers
    # ─────────────────────────────────────────────

    if [[ "$mimetype" == *"x-scheme-handler"* ]]; then
        continue
    fi

    # Entries explicitly created as handlers
    if [[ "$name" =~ (URL|URI)[[:space:]]Handler$ ]]; then
        continue
    fi

    # ─────────────────────────────────────────────
    # Clean Exec
    # ─────────────────────────────────────────────

    exec=$(echo "$exec" | sed -E \
        's/[[:space:]]+%[fFuUdDnNickvm]//g')

    # ─────────────────────────────────────────────
    # Remove duplicate name + command combinations
    # ─────────────────────────────────────────────

    key="$name|$exec"

    if [[ -n "${seen[$key]}" ]]; then
        continue
    fi

    seen["$key"]=1

    # ─────────────────────────────────────────────
    # Escape JSON
    # ─────────────────────────────────────────────

    name=$(printf '%s' "$name" | sed \
        's/\\/\\\\/g; s/"/\\"/g')

    icon=$(printf '%s' "$icon" | sed \
        's/\\/\\\\/g; s/"/\\"/g')

    exec=$(printf '%s' "$exec" | sed \
        's/\\/\\\\/g; s/"/\\"/g')

    # ─────────────────────────────────────────────
    # Output JSON
    # ─────────────────────────────────────────────

    if [ "$first" = true ]; then
        first=false
    else
        printf ','
    fi

    printf '{"name":"%s","icon":"%s","command":"%s"}' \
        "$name" \
        "$icon" \
        "$exec"

done < <(
    find /usr/share/applications \
         "$HOME/.local/share/applications" \
         -type f \
         -name "*.desktop" \
         2>/dev/null
)

printf ']'