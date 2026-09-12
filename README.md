# Portable Sway Dotfiles

Personal Linux desktop configuration based initially on the Manjaro
Sway desktop-settings project.

The repository is intentionally user-local and portable. It keeps the
configuration in the user profile and avoids system-wide desktop paths.

This dotfiles repo is designed to work on Debian and Arch-based
systems using the same source tree and a distro-aware installer.

## What is included

The configuration includes a working Sway session with:

- Sway window manager configuration
- Waybar status bar
- Foot terminal
- Mako notifications
- Wofi launcher
- user-level systemd services
- modular Zsh configuration
- centralized theme system with generated app colors

## Structure

- `.config/sway` - Sway configuration, scripts, modes, config fragments, and themes
- `.config/sway/themes` - active theme state and generated app-specific colors
- `.config/waybar` - Waybar config and generated style import
- `.config/foot` - Foot config
- `.config/mako` - notification daemon config
- `.config/wofi` - launcher config
- `.config/systemd/user` - user services for Waybar, Mako, and Foot server
- `.config/zsh` - zsh loader and modular config fragments
- `packages/` - distro-specific dependency lists for apt and pacman
- `scripts/` - deployment and installer entry points

## Major migration work completed

The repo has been migrated from a Manjaro-oriented setup to a portable,
user-local structure.

Completed work includes:

- fixed invalid shell startup behavior in `.config/zsh/.zshrc`
- made install and deploy logic work from any checkout location
- removed hard-coded system path dependencies from Sway-related config
- populated missing desktop app configs for Mako and Wofi
- added a central theme engine at `.config/sway/themes/theme.sh`
- added a second theme (`dracula`) and active theme generation flow
- integrated generated theme colors into Waybar, Mako, Wofi, and Foot
- added user service files for Waybar, Mako, and Foot
- split Zsh configuration into modular fragments under `.config/zsh/config.d/`
- added modular Sway fragments under `.config/sway/config.d/`
- verified shell syntax and file presence after migration

## Deployment

Install dependencies and deploy from any checkout location:

	./install.sh

The installer detects `apt` or `pacman`, installs the matching package
list, and calls `deploy.sh`. Deployment copies the repository
configuration into `${XDG_CONFIG_HOME:-~/.config}` after creating a
timestamped backup.

No symlinks are used.

## Theme system

Themes are managed centrally from `.config/sway/themes/theme.sh`.

Example:

	~/.config/sway/themes/theme.sh dracula
	~/.config/sway/themes/theme.sh matcha-green

This writes the active theme state and generates app-specific theme files
used by Sway, Waybar, Mako, Wofi, and Foot.

## Validation status

The migration has been validated with fresh shell checks and file checks for
modular config fragments and service files.
