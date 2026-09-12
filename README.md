# Portable Sway Dotfiles

Personal Linux desktop configuration based initially on the
Manjaro Sway desktop-settings project.

The goal is a portable, user-local configuration that works across
Linux distributions without depending on:

- /etc/sway
- /usr/share/sway
- Manjaro-specific configuration paths

## Structure

- `.config/sway` - Sway configuration, scripts, modes and themes
- `.config/waybar` - Waybar
- `.config/foot` - Foot terminal
- `.config/mako` - notifications
- `.config/wofi` - application launcher
- `.config/systemd/user` - user services
- `.config/zsh` - Zsh configuration
- `packages/` - distribution-specific dependencies

## Deployment

Install dependencies and deploy from any checkout location:

	./install.sh

The installer detects `apt` or `pacman`, installs the matching package
list, and calls `deploy.sh`. Deployment copies the repository
configuration into `${XDG_CONFIG_HOME:-~/.config}` after creating a
timestamped backup.

No symlinks are used.
