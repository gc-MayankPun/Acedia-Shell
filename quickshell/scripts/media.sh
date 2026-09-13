#!/bin/bash

json_escape() {
    printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

empty_status() {
    echo '{"hasPlayer":false,"playing":false,"title":"","artist":"","album":"","artUrl":"","position":0,"length":0,"source":"other"}'
}

# Sets two GLOBAL variables directly instead of using command
# substitution — $(...) runs in a subshell, so any variable set
# inside a function called that way is lost once the subshell
# exits. That was the actual bug: ACTIVE_PLAYER_NAME was being
# set correctly, but only inside a subshell, so the real script
# never saw it and "source" always fell through to "other".
PLAYER_ARG=""
ACTIVE_PLAYER_NAME=""

resolve_player() {
    local players
    players=$(playerctl -l 2>/dev/null)

    if [[ -z "$players" ]]; then
        PLAYER_ARG=""
        ACTIVE_PLAYER_NAME=""
        return
    fi

    local count
    count=$(echo "$players" | wc -l)

    if [[ "$count" -eq 1 ]]; then
        ACTIVE_PLAYER_NAME="$players"
        PLAYER_ARG="-p $players"
        return
    fi

    local player
    for player in $players; do
        local st
        st=$(playerctl -p "$player" status 2>/dev/null | xargs)
        if [[ "$st" == "Playing" ]]; then
            ACTIVE_PLAYER_NAME="$player"
            PLAYER_ARG="-p $player"
            return
        fi
    done

    if echo "$players" | grep -qi spotify; then
        ACTIVE_PLAYER_NAME=$(echo "$players" | grep -i spotify | head -1)
        PLAYER_ARG="-p $ACTIVE_PLAYER_NAME"
    else
        ACTIVE_PLAYER_NAME=$(echo "$players" | head -1)
        PLAYER_ARG="-p $ACTIVE_PLAYER_NAME"
    fi
}

status() {
    resolve_player
    local p="$PLAYER_ARG"

    if ! playerctl $p status >/dev/null 2>&1; then
        empty_status
        return 0
    fi

    local play_status
    play_status=$(playerctl $p status 2>/dev/null)

    if [[ "$play_status" != "Playing" && "$play_status" != "Paused" ]]; then
        empty_status
        return 0
    fi

    local playing="false"
    [[ "$play_status" == "Playing" ]] && playing="true"

    local title artist album art_url position length
    title=$(playerctl $p metadata xesam:title 2>/dev/null)
    artist=$(playerctl $p metadata xesam:artist 2>/dev/null)
    album=$(playerctl $p metadata xesam:album 2>/dev/null)
    art_url=$(playerctl $p metadata mpris:artUrl 2>/dev/null)
    position=$(playerctl $p position 2>/dev/null)
    length=$(playerctl $p metadata mpris:length 2>/dev/null)

    title="${title:-}"
    artist="${artist:-}"
    album="${album:-}"
    art_url="${art_url:-}"
    position="${position:-0}"
    length="${length:-0}"

    position=$(awk -v p="$position" 'BEGIN { printf "%.0f", p }' 2>/dev/null || echo 0)
    length=$(awk -v l="$length" 'BEGIN { printf "%.0f", l / 1000000 }' 2>/dev/null || echo 0)

    if [[ "$art_url" == file://* ]]; then
        local art_path="${art_url#file://}"
        [[ ! -f "$art_path" ]] && art_url=""
    fi

    local source="other"
    case "$ACTIVE_PLAYER_NAME" in
        spotify*) source="spotify" ;;
        chromium*|firefox*|brave*) source="browser" ;;
        vlc*) source="vlc" ;;
        mpv*) source="mpv" ;;
    esac

    echo "{\"hasPlayer\":true,\"playing\":$playing,\"title\":\"$(json_escape "$title")\",\"artist\":\"$(json_escape "$artist")\",\"album\":\"$(json_escape "$album")\",\"artUrl\":\"$(json_escape "$art_url")\",\"position\":$position,\"length\":$length,\"source\":\"$source\"}"
}

toggle_popup() {
    quickshell ipc call media-popup toggle
}

play_pause() {
    resolve_player
    playerctl $PLAYER_ARG play-pause >/dev/null 2>&1
    exit 0
}

next_track() {
    resolve_player
    playerctl $PLAYER_ARG next >/dev/null 2>&1
    exit 0
}

previous_track() {
    resolve_player
    playerctl $PLAYER_ARG previous >/dev/null 2>&1
    exit 0
}

seek() {
    resolve_player
    playerctl $PLAYER_ARG position "$1" >/dev/null 2>&1
    exit 0
}

case "${1:-status}" in
    status) status ;;
    toggle-popup) toggle_popup ;;
    play-pause) play_pause ;;
    next) next_track ;;
    previous) previous_track ;;
    seek) seek "$2" ;;
    *) echo "Unknown command: $1" >&2; exit 1 ;;
esac
