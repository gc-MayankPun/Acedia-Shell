#!/usr/bin/env bash
# Usage:
#   wifi.sh status                 -> JSON: {radioEnabled, networks: [...]}
#   wifi.sh radio on|off
#   wifi.sh scan
#   wifi.sh connect <ssid> [password]
#   wifi.sh disconnect

set -euo pipefail

json_escape() {
    printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

status() {
    local radio_enabled="false"
    if [[ "$(nmcli radio wifi)" == "enabled" ]]; then
        radio_enabled="true"
    fi

    local saved_names
    saved_names=$(nmcli -t -e no -f NAME,TYPE connection show \
        | awk -F: '$NF=="802-11-wireless" {NF--; print $0}')

    nmcli device wifi rescan >/dev/null 2>&1 || true

    local networks_json="["
    local first=true
    local seen=""

    while IFS= read -r line; do
        [[ -z "$line" ]] && continue

        local in_use="${line%%:*}"
        local rest="${line#*:}"
        local security="${rest##*:}"
        rest="${rest%:*}"
        local signal="${rest##*:}"
        local ssid="${rest%:*}"

        [[ -z "$ssid" ]] && continue
        [[ "$seen" == *"|$ssid|"* ]] && continue
        seen="${seen}|${ssid}|"

        local is_connected="false"
        [[ "$in_use" == "*" ]] && is_connected="true"

        local is_saved="false"
        if grep -qxF "$ssid" <<< "$saved_names"; then
            is_saved="true"
        fi

        [[ "$first" == true ]] && first=false || networks_json+=","
        networks_json+="{\"name\":\"$(json_escape "$ssid")\",\"signal\":$signal,\"security\":\"$(json_escape "$security")\",\"isConnected\":$is_connected,\"isSaved\":$is_saved}"
    done < <(nmcli -t -e no -f IN-USE,SSID,SIGNAL,SECURITY device wifi list)

    networks_json+="]"

    echo "{\"radioEnabled\":$radio_enabled,\"networks\":$networks_json}"
}

radio() {
    nmcli radio wifi "$1" >/dev/null
}

scan() {
    nmcli device wifi rescan >/dev/null 2>&1 || true
}

connect() {
    local ssid="$1"
    local password="${2:-}"

    if [[ -n "$password" ]]; then
        nmcli device wifi connect "$ssid" password "$password" >/dev/null 2>&1 || true
    else
        nmcli device wifi connect "$ssid" >/dev/null 2>&1 || true
    fi
}

disconnect() {
    local iface
    iface=$(nmcli -t -f DEVICE,TYPE device status | awk -F: '$2=="wifi"{print $1; exit}')

    if [[ -n "$iface" ]]; then
        nmcli device disconnect "$iface" >/dev/null 2>&1 || true
    fi
}

case "${1:-status}" in
    status) status ;;
    radio) radio "$2" ;;
    scan) scan ;;
    connect) connect "$2" "${3:-}" ;;
    disconnect) disconnect ;;
    *) echo "Unknown command: $1" >&2; exit 1 ;;
esac
