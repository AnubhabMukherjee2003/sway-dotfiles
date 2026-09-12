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

Use the deployment script to copy the repository configuration
into the real user's ~/.config directory.

No symlinks are used.
