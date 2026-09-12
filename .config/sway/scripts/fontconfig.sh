#!/usr/bin/env sh
set -u

export CATEGORY=${1:-"monospace"}
export FONT=${2:-"JetBrainsMono NF"}

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
FONTCONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/fontconfig/conf.d"
TEMPLATE="$CONFIG_HOME/sway/templates/fontconfig.conf"

if [ ! -f "$TEMPLATE" ]; then
	printf 'Missing local fontconfig template: %s\n' "$TEMPLATE" >&2
	exit 1
fi

mkdir -p $FONTCONFIG_DIR

envsubst < "$TEMPLATE" > "$FONTCONFIG_DIR/51-${CATEGORY}.conf"
