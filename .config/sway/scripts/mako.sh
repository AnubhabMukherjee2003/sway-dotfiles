#!/usr/bin/env sh
# wrapper script for mako

if pgrep -x mako >/dev/null 2>&1; then
    exit 0
fi

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
USER_CONFIG_PATH="${CONFIG_HOME}/mako/config"

if [ -f "$USER_CONFIG_PATH" ]; then
    exec mako -c "$USER_CONFIG_PATH"
else
    exec mako \
        --font "${MAKO_FONT:-Monospace 10}" \
        --text-color "${MAKO_TEXT_COLOR:-#d8dee9}" \
        --border-color "${MAKO_BORDER_COLOR:-#4c566a}" \
        --background-color "${MAKO_BG_COLOR:-#2e3440}" \
        --border-size 3 --width 400 --height 200 --padding 20 --margin 20 --default-timeout 15000 \
        $MAKO_ARGS
fi
