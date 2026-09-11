#!/usr/bin/env bash
set -euo pipefail

SEEN_FILE="$HOME/.cache/quickshell/bt-seen.tsv"
NEARBY_WINDOW_SECONDS=45

mkdir -p "$(dirname "$SEEN_FILE")"
touch "$SEEN_FILE"

json_escape() {
    printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

is_recently_seen() {
    local addr="$1"
    local now
    now=$(date +%s)
    local ts
    ts=$(awk -F'\t' -v a="$addr" '$1==a {print $2}' "$SEEN_FILE" | tail -1)
    [[ -z "$ts" ]] && return 1
    (( now - ts <= NEARBY_WINDOW_SECONDS ))
}

status() {
    local powered="false"
    if bluetoothctl show | grep -qi "Powered: yes"; then
        powered="true"
    fi

    local tmpdir
    tmpdir=$(mktemp -d)

    local addrs=()
    local names=()

    while IFS= read -r line; do
        [[ "$line" =~ ^Device\ ([0-9A-Fa-f:]+)\ (.+)$ ]] || continue
        addrs+=("${BASH_REMATCH[1]}")
        names+=("${BASH_REMATCH[2]}")
    done < <(bluetoothctl devices)

    # Fire all "bluetoothctl info" calls in parallel instead of
    # one after another — this is what was making status() slow
    # with multiple devices, not the polling interval.
    for i in "${!addrs[@]}"; do
        bluetoothctl info "${addrs[$i]}" > "$tmpdir/$i" 2>/dev/null &
    done
    wait

    local devices_json="["
    local first=true

    for i in "${!addrs[@]}"; do
        local addr="${addrs[$i]}"
        local name="${names[$i]}"
        local info
        info=$(cat "$tmpdir/$i" 2>/dev/null || echo "")

        local paired="false"
        local connected="false"
        grep -qi "Paired: yes" <<< "$info" && paired="true"
        grep -qi "Connected: yes" <<< "$info" && connected="true"

        if [[ "$paired" == "false" ]] && ! is_recently_seen "$addr"; then
            continue
        fi

        [[ "$first" == true ]] && first=false || devices_json+=","
        devices_json+="{\"address\":\"$addr\",\"name\":\"$(json_escape "$name")\",\"paired\":$paired,\"connected\":$connected}"
    done

    rm -rf "$tmpdir"

    devices_json+="]"
    echo "{\"powered\":$powered,\"devices\":$devices_json}"
}

power() {
    bluetoothctl power "$1" >/dev/null
}

scan() {
    local now
    now=$(date +%s)

    while IFS= read -r line; do
        if [[ "$line" =~ Device\ ([0-9A-Fa-f:]+) ]]; then
            local addr="${BASH_REMATCH[1]}"
            grep -v -P "^${addr}\t" "$SEEN_FILE" > "$SEEN_FILE.tmp" 2>/dev/null || true
            mv "$SEEN_FILE.tmp" "$SEEN_FILE" 2>/dev/null || true
            printf '%s\t%s\n' "$addr" "$now" >> "$SEEN_FILE"
        fi
    done < <(bluetoothctl --timeout 5 scan on 2>&1) || true
}

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

    timeout 10 bluetoothctl <<BTEOF >/dev/null 2>&1 || true
connect $addr
BTEOF

    # Poll until BlueZ actually reports Connected: yes, instead of
    # trusting bluetoothctl's exit (which fires as soon as the
    # command is sent, not once the connection is truly established).
    for i in $(seq 1 10); do
        if bluetoothctl info "$addr" 2>/dev/null | grep -qi "Connected: yes"; then
            break
        fi
        sleep 0.5
    done
}

disconnect() {
    local addr="$1"

    timeout 10 bluetoothctl <<BTEOF >/dev/null 2>&1 || true
disconnect $addr
BTEOF

    for i in $(seq 1 10); do
        if bluetoothctl info "$addr" 2>/dev/null | grep -qi "Connected: no"; then
            break
        fi
        sleep 0.5
    done
}

LOCK_FILE="$HOME/.cache/quickshell/bt.lock"
mkdir -p "$(dirname "$LOCK_FILE")"

# Serialize every invocation of this script through one lock, so
# a status poll and an in-flight connect/disconnect/pair never
# hit bluetoothctl at the same time. Concurrent bluetoothctl
# calls can return incomplete output under BlueZ, which is what
# was causing "powered" to flicker false for a moment.
exec 200>"$LOCK_FILE"
flock -w 15 200 || exit 1

case "${1:-status}" in
    status) status ;;
    power) power "$2" ;;
    scan) scan ;;
    pair) pair "$2" ;;
    connect) connect "$2" ;;
    disconnect) disconnect "$2" ;;
    *) echo "Unknown command: $1" >&2; exit 1 ;;
esac
