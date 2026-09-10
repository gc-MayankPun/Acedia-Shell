#!/usr/bin/env bash
# Usage:
#   bluetooth.sh status
#   bluetooth.sh power on|off
#   bluetooth.sh scan
#   bluetooth.sh pair <address>
#   bluetooth.sh connect <address>
#   bluetooth.sh disconnect <address>

set -euo pipefail

json_escape() {
    printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

status() {
    local powered="false"
    if bluetoothctl show | grep -qi "Powered: yes"; then
        powered="true"
    fi

    local devices_json="["
    local first=true

    while IFS= read -r line; do
        [[ "$line" =~ ^Device\ ([0-9A-Fa-f:]+)\ (.+)$ ]] || continue
        local addr="${BASH_REMATCH[1]}"
        local name="${BASH_REMATCH[2]}"

        local info
        info=$(bluetoothctl info "$addr")

        local paired="false"
        local connected="false"
        grep -qi "Paired: yes" <<< "$info" && paired="true"
        grep -qi "Connected: yes" <<< "$info" && connected="true"

        [[ "$first" == true ]] && first=false || devices_json+=","
        devices_json+="{\"address\":\"$addr\",\"name\":\"$(json_escape "$name")\",\"paired\":$paired,\"connected\":$connected}"
    done < <(bluetoothctl devices)

    devices_json+="]"

    echo "{\"powered\":$powered,\"devices\":$devices_json}"
}

power() {
    bluetoothctl power "$1" >/dev/null
}

scan() {
    bluetoothctl --timeout 5 scan on >/dev/null 2>&1 || true
}

# Runs agent registration + the actual command in ONE bluetoothctl
# session via stdin, so the agent is still alive when pair/connect
# runs. Previously each line spawned a separate process, so the
# agent died before pairing ever happened — that's why it hung.
pair() {
    local addr="$1"
    timeout 15 bluetoothctl <<BTEOF || true
agent NoInputNoOutput
default-agent
pair $addr
trust $addr
connect $addr
BTEOF
}

connect() {
    local addr="$1"
    timeout 10 bluetoothctl <<BTEOF || true
connect $addr
BTEOF
}

disconnect() {
    local addr="$1"
    timeout 10 bluetoothctl <<BTEOF || true
disconnect $addr
BTEOF
}

case "${1:-status}" in
    status) status ;;
    power) power "$2" ;;
    scan) scan ;;
    pair) pair "$2" ;;
    connect) connect "$2" ;;
    disconnect) disconnect "$2" ;;
    *) echo "Unknown command: $1" >&2; exit 1 ;;
esac
