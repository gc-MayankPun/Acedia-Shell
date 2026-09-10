#!/usr/bin/env bash
# Usage:
#   nightlight.sh status            -> JSON: {enabled, temperature}
#   nightlight.sh enable <temp>
#   nightlight.sh disable

set -euo pipefail

STATE_FILE="$HOME/.cache/quickshell/nightlight-state"
mkdir -p "$(dirname "$STATE_FILE")"

status() {
    local enabled="false"
    local temperature="4500"

    if [[ -f "$STATE_FILE" ]]; then
        # STATE_FILE format: "enabled temperature"
        read -r saved_enabled saved_temp < "$STATE_FILE"
        [[ "$saved_enabled" == "on" ]] && enabled="true"
        [[ -n "$saved_temp" ]] && temperature="$saved_temp"
    fi

    echo "{\"enabled\":$enabled,\"temperature\":$temperature}"
}

enable() {
    local temp="${1:-4500}"
    hyprsunset -t "$temp" >/dev/null 2>&1 || true
    echo "on $temp" > "$STATE_FILE"
}

disable() {
    hyprsunset -i >/dev/null 2>&1 || true
    local temp="4500"
    [[ -f "$STATE_FILE" ]] && read -r _ temp < "$STATE_FILE"
    echo "off $temp" > "$STATE_FILE"
}

case "${1:-status}" in
    status) status ;;
    enable) enable "${2:-}" ;;
    disable) disable ;;
    *) echo "Unknown command: $1" >&2; exit 1 ;;
esac