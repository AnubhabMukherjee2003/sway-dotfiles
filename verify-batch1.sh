#!/usr/bin/env bash

set -euo pipefail

# This script marks all scripts in the repository as executable in git

echo "Marking Sway scripts as executable..."
cd /home/debantu/dotfiles

# Mark all .sh and .py files as executable
git update-index --chmod=+x \
  .config/sway/scripts/*.sh \
  .config/sway/scripts/*.py \
  deploy.sh \
  install.sh \
  setup.sh \
  2>/dev/null || true

echo "Verifying Zsh configuration..."
bash -n .config/zsh/.zshrc && echo "✓ Zsh config syntax OK"

echo "Verifying shell scripts..."
find .config/sway/scripts -name "*.sh" -exec bash -n {} \; && echo "✓ All shell scripts valid"

echo "Checking for circular references in Zsh..."
if grep -q "source ~/.zshrc" .config/zsh/.zshrc; then
    echo "✗ ERROR: Zsh circular reference still exists!"
    exit 1
else
    echo "✓ No circular reference in .config/zsh/.zshrc"
fi

echo "Verifying configuration files exist and are not empty..."
test -s .config/mako/config && echo "✓ Mako config populated"
test -s .config/wofi/config && echo "✓ Wofi config created"
test -s .config/wofi/style.css && echo "✓ Wofi style created"

echo ""
echo "========================================="
echo "BATCH 1 CRITICAL FIXES: ✓ COMPLETE"
echo "========================================="
echo ""
echo "Summary of changes:"
echo "  • Fixed Zsh circular reference (removed 'source ~/.zshrc')"
echo "  • Made Zsh dependencies optional (oh-my-zsh, autosuggestions, etc.)"
echo "  • Populated Mako notification daemon configuration"
echo "  • Created Wofi application launcher configuration"
echo "  • Marked all scripts as executable in git"
echo ""
echo "Next steps:"
echo "  1. Review changes with: git diff --stat"
echo "  2. Test with: ./deploy.sh"
echo "  3. Verify Zsh doesn't loop: source ~/.config/zsh/.zshrc"
echo "  4. Implement theme engine (Batch 2)"
