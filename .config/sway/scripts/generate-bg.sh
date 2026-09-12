#!/usr/bin/env sh
set -u

export CROWN=${1:-}
export ROOT=${2:-}
export BACKGROUND=${3:-}

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
TEMPLATE="$CONFIG_HOME/sway/templates/manjarosway-scalable.svg"

if [ ! -f "$TEMPLATE" ]; then
	printf 'Missing local background template: %s\n' "$TEMPLATE" >&2
	exit 1
fi

envsubst < "$TEMPLATE" > "$CONFIG_HOME/sway/generated_background.svg"
