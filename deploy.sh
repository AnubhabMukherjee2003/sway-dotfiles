#!/usr/bin/env bash

set -euo pipefail

DOTFILES="$HOME/dotfiles"
SOURCE="$DOTFILES/.config"
TARGET="$HOME/.config"

echo "======================================"
echo "       Deploying dotfiles"
echo "======================================"
echo
echo "Source:"
echo "  $SOURCE"
echo
echo "Target:"
echo "  $TARGET"
echo

mkdir -p "$TARGET"

# --------------------------------------------------
# Backup current configuration
# --------------------------------------------------

BACKUP="$HOME/.config.backup-$(date +%Y%m%d-%H%M%S)"

echo "Creating backup:"
echo "  $BACKUP"

cp -a "$TARGET" "$BACKUP"

# --------------------------------------------------
# Copy dotfiles
# --------------------------------------------------

echo
echo "Copying configuration..."

cp -a "$SOURCE/." "$TARGET/"

# --------------------------------------------------
# Make scripts executable
# --------------------------------------------------

if [[ -d "$TARGET/sway/scripts" ]]; then
    find "$TARGET/sway/scripts" \
        -type f \
        \( -name "*.sh" -o -name "*.py" \) \
        -exec chmod +x {} \;
fi

echo
echo "======================================"
echo " Deployment complete"
echo "======================================"
echo
echo "Backup:"
echo "  $BACKUP"
echo
echo "Sway:"
echo "  swaymsg reload"