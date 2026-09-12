#!/bin/sh

get_updates() {
    CACHE_FILE="/tmp/checkupdates-$USER"
    if [ -f "$CACHE_FILE" ] && [ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE"))) -lt 30 ]; then
        cat "$CACHE_FILE"
    elif command -v checkupdates >/dev/null 2>&1; then
        checkupdates | tee "$CACHE_FILE"
    elif command -v apt >/dev/null 2>&1; then
        apt list --upgradable 2>/dev/null | sed '1d' | tee "$CACHE_FILE"
    else
        : > "$CACHE_FILE"
    fi
}

case $1'' in
'status')
    UPDATES=$(get_updates)
    COUNT=$(echo "$UPDATES" | grep -v '^$' | wc -l)
    TOOLTIP=$(echo "$UPDATES" | awk 1 ORS='\\n' | sed 's/\\n$//')
    jq -cn --arg count "$COUNT" --arg tooltip "$TOOLTIP" '{"text": $count, "tooltip": $tooltip}'
    ;;
'check')
    UPDATES=$(get_updates)
    [ $(echo "$UPDATES" | grep -v '^$' | wc -l) -gt 0 ]
    exit $?
    ;;
'upgrade')
    if [ -x "$(command -v pacseek)" ]; then
        xdg-terminal-exec pacseek -u
    elif [ -x "$(command -v topgrade)" ]; then
        xdg-terminal-exec topgrade
    elif command -v apt >/dev/null 2>&1; then
        xdg-terminal-exec sh -c 'sudo apt update && sudo apt upgrade'
    elif command -v pacman >/dev/null 2>&1; then
        xdg-terminal-exec pacman -Syu
    else
        printf '%s\n' 'No supported package manager found.' >&2
        exit 1
    fi
    ;;
esac
