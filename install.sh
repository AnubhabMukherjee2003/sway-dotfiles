#!/usr/bin/env bash

set -euo pipefail

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES="$DOTFILES/packages"

if command -v apt-get >/dev/null 2>&1; then
    manager=apt
    package_file="$PACKAGES/apt.txt"
elif command -v pacman >/dev/null 2>&1; then
    manager=pacman
    package_file="$PACKAGES/pacman.txt"
else
    echo "No supported package manager found (apt-get or pacman)." >&2
    exit 1
fi

mapfile -t packages < <(sed '/^[[:space:]]*#/d;/^[[:space:]]*$/d' "$package_file")

if [[ ${#packages[@]} -eq 0 ]]; then
    echo "No packages listed in $package_file" >&2
    exit 1
fi

case "$manager" in
    apt)
        sudo apt-get update
        sudo apt-get install -y "${packages[@]}"
        ;;
    pacman)
        sudo pacman -Syu --needed "${packages[@]}"
        ;;
esac

"$DOTFILES/deploy.sh"
