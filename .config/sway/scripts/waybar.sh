#!/usr/bin/env bash
# wrapper script for waybar with args, see https://github.com/swaywm/sway/issues/5724

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
USER_CONFIG_PATH="$CONFIG_HOME/waybar/config.jsonc"
USER_STYLE_PATH="$CONFIG_HOME/waybar/style.css"

pkill -U $USER -x waybar

exec waybar -c "$USER_CONFIG_PATH" -s "$USER_STYLE_PATH"
