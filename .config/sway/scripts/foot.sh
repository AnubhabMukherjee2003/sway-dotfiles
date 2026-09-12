#!/usr/bin/env sh
# wrapper script for foot

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
USER_CONFIG_PATH="${CONFIG_HOME}/foot/foot.ini"
USER_THEME_CONFIG_PATH="${CONFIG_HOME}/foot/foot-theme.ini"

if [ -f "$USER_THEME_CONFIG_PATH" ]; then
    USER_CONFIG=$USER_THEME_CONFIG_PATH
fi

if [ -f "$USER_CONFIG_PATH" ]; then
    USER_CONFIG=$USER_CONFIG_PATH
fi

exec foot -c "${USER_CONFIG:-$USER_CONFIG_PATH}" "$@"
