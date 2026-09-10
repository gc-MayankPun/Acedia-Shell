#!/usr/bin/env bash
# Usage:
#   audio.sh status              -> JSON: {sinkName, sinkDescription, volume, muted, sourceName, sourceDescription, micVolume, micMuted}
#   audio.sh volume <0-100>
#   audio.sh mute-toggle
#   audio.sh mic-volume <0-100>
#   audio.sh mic-mute-toggle

set -euo pipefail

json_escape() {
    printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

status() {
    local sink_name source_name
    sink_name=$(pactl get-default-sink)
    source_name=$(pactl get-default-source)

    local sinks sources
    sinks=$(pactl list sinks)
    sources=$(pactl list sources)

    local sink_block
    sink_block=$(awk -v name="$sink_name" '
        /^Sink #/ { current="" }
        /Name:/ { current=$2 }
        current==name { print }
    ' <<< "$sinks")

    local source_block
    source_block=$(awk -v name="$source_name" '
        /^Source #/ { current="" }
        /Name:/ { current=$2 }
        current==name { print }
    ' <<< "$sources")

    local sink_desc muted volume
    sink_desc=$(grep "Description:" <<< "$sink_block" | head -1 | sed 's/^[[:space:]]*Description:[[:space:]]*//')
    muted="false"
    grep -qi "Mute: yes" <<< "$sink_block" && muted="true"
    volume=$(grep -oP '\d+(?=%)' <<< "$sink_block" | head -1)
    [[ -z "$volume" ]] && volume=0

    local source_desc mic_muted mic_volume
    source_desc=$(grep "Description:" <<< "$source_block" | head -1 | sed 's/^[[:space:]]*Description:[[:space:]]*//')
    mic_muted="false"
    grep -qi "Mute: yes" <<< "$source_block" && mic_muted="true"
    mic_volume=$(grep -oP '\d+(?=%)' <<< "$source_block" | head -1)
    [[ -z "$mic_volume" ]] && mic_volume=0

    echo "{\"sinkName\":\"$(json_escape "$sink_name")\",\"sinkDescription\":\"$(json_escape "${sink_desc:-$sink_name}")\",\"volume\":$volume,\"muted\":$muted,\"sourceName\":\"$(json_escape "$source_name")\",\"sourceDescription\":\"$(json_escape "${source_desc:-$source_name}")\",\"micVolume\":$mic_volume,\"micMuted\":$mic_muted}"
}

volume() {
    pactl set-sink-volume @DEFAULT_SINK@ "${1}%" >/dev/null
}

mute_toggle() {
    pactl set-sink-mute @DEFAULT_SINK@ toggle >/dev/null
}

mic_volume() {
    pactl set-source-volume @DEFAULT_SOURCE@ "${1}%" >/dev/null
}

mic_mute_toggle() {
    pactl set-source-mute @DEFAULT_SOURCE@ toggle >/dev/null
}

case "${1:-status}" in
    status) status ;;
    volume) volume "$2" ;;
    mute-toggle) mute_toggle ;;
    mic-volume) mic_volume "$2" ;;
    mic-mute-toggle) mic_mute_toggle ;;
    *) echo "Unknown command: $1" >&2; exit 1 ;;
esac
