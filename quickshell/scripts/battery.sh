#!/usr/bin/env bash
# Usage:
#   battery.sh status            -> JSON: {profiles: [...], activeProfile}
#   battery.sh set <profile>

set -euo pipefail

status() {
    local output
    output=$(powerprofilesctl list)

    local profiles_json="["
    local first=true
    local active=""

    while IFS= read -r line; do
        if [[ "$line" =~ ^\*[[:space:]]*([a-z-]+):[[:space:]]*$ ]]; then
            local name="${BASH_REMATCH[1]}"
            active="$name"
            [[ "$first" == true ]] && first=false || profiles_json+=","
            profiles_json+="\"$name\""
        elif [[ "$line" =~ ^[[:space:]]*([a-z-]+):[[:space:]]*$ ]]; then
            local name="${BASH_REMATCH[1]}"
            [[ "$first" == true ]] && first=false || profiles_json+=","
            profiles_json+="\"$name\""
        fi
    done <<< "$output"

    profiles_json+="]"

    echo "{\"profiles\":$profiles_json,\"activeProfile\":\"$active\"}"
}

set_profile() {
    powerprofilesctl set "$1" >/dev/null
}

case "${1:-status}" in
    status) status ;;
    set) set_profile "$2" ;;
    *) echo "Unknown command: $1" >&2; exit 1 ;;
esac