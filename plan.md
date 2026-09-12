# Portable Sway Dotfiles — Development Plan

## Objective

Build a portable personal Linux desktop configuration based initially
on Manjaro Sway.

The repository must be independent of Manjaro's system paths.

The repository is the source of truth.

Deployment copies:

    ~/dotfiles/.config/*

into:

    ~/.config/

No symlinks are used.

---

# Current Status

## Imported

- [x] Sway base configuration
- [x] Sway definitions
- [x] Sway modes
- [x] Sway input configuration
- [x] Manjaro Sway scripts
- [x] Matcha Green theme
- [x] Waybar initial configuration
- [x] Foot initial configuration
- [x] Swappy configuration
- [x] Zsh initial configuration

## Already working on the current machine

- [x] Sway
- [x] GDM
- [x] Foot
- [x] Waybar
- [x] Wofi
- [x] Mako
- [x] PipeWire
- [x] WirePlumber
- [x] Webcam/V4L2
- [x] Touchpad
- [x] Zsh
- [x] zsh-autosuggestions
- [x] zsh-syntax-highlighting

---

# Architecture

Everything user-specific belongs under:

    .config/

Sway-specific resources:

    .config/sway/

Other applications remain in their normal XDG locations:

    .config/waybar/
    .config/foot/
    .config/mako/
    .config/wofi/
    .config/swaylock/
    .config/swappy/

User systemd services:

    .config/systemd/user/

Zsh:

    .config/zsh/

---

# Sway

The main entry point is:

    .config/sway/config

Keep the main file small.

Use modular files:

    config.d/
    definitions.d/
    inputs/
    modes/

Do not put the entire configuration into one large file.

---

# Important portability rule

NEVER depend on:

    /etc/sway/
    /usr/share/sway/
    /usr/share/sway/scripts/
    /usr/share/sway/themes/

Convert Manjaro paths to user-local paths.

For example:

BAD:

    /usr/share/sway/scripts/lock.sh

GOOD:

    ~/.config/sway/scripts/lock.sh

BAD:

    /etc/sway/modes/resize

GOOD:

    ~/.config/sway/modes/resize.conf

---

# Sway scripts

All Sway-specific scripts belong in:

    .config/sway/scripts/

Before keeping a Manjaro script unchanged, inspect it for:

- pacman
- pamac
- Manjaro-specific commands
- /etc paths
- /usr/share paths
- hard-coded Manjaro paths

Replace those dependencies with portable alternatives.

Scripts should prefer:

    $HOME
    $XDG_CONFIG_HOME

where appropriate.

---

# Themes

Themes belong in:

    .config/sway/themes/

The initial theme is:

    matcha-green

The theme should be able to control the visual appearance of:

- Sway
- Waybar
- Foot
- Mako
- Wofi
- GTK where practical
- cursor/icons where practical

Do not create unnecessary duplicate color definitions.

Prefer one source of truth for the palette.

---

# Waybar

Configuration:

    .config/waybar/

Files:

    config.jsonc
    style.css

Waybar should be controlled by Sway/user systemd.

Do not depend on:

    /usr/share/sway/

---

# Foot

Configuration:

    .config/foot/foot.ini

Foot theme files may be stored alongside the Sway theme.

Make sure the final Foot configuration is valid for the installed Foot version.

Do not copy unsupported options from older/newer Foot versions blindly.

---

# Mako

Configuration:

    .config/mako/config

Mako should be started through a user service or Sway startup.

Do not depend on:

    /etc/mako
    /usr/share/sway

---

# Wofi

Configuration:

    .config/wofi/

Keep Wofi's configuration separate from Sway.

Sway only launches Wofi.

---

# Screenshots

Sway screenshot functionality should use the installed tools:

    grim
    slurp
    swappy

The orchestration script belongs in:

    .config/sway/scripts/

Example:

    screenshot.sh

---

# Screen recording

Recording functionality belongs in:

    .config/sway/scripts/recorder.sh

Use available system tools rather than Manjaro-specific wrappers.

Verify Wayland compatibility.

---

# Audio / video

Use the system multimedia stack:

    PipeWire
    WirePlumber
    xdg-desktop-portal
    xdg-desktop-portal-wlr

Do not bundle system multimedia configuration into the dotfiles unless
it is genuinely user-specific.

---

# User systemd

User service files belong in:

    .config/systemd/user/

Do not use system-wide services for desktop applications unless
required by the operating system.

After changes:

    systemctl --user daemon-reload

Services should use portable paths.

---

# Zsh

Zsh configuration:

    .config/zsh/

The main configuration should remain modular.

Support:

    zsh-autosuggestions
    zsh-syntax-highlighting

Do not make Oh My Zsh mandatory.

The configuration should work with plain Zsh.

---

# Package dependencies

Do not install packages from configuration files.

Dependencies belong in:

    packages/apt.txt
    packages/pacman.txt

The installation process should detect the package manager.

The same configuration should work after installing equivalent
dependencies on the target operating system.

---

# Deployment

The repository contains:

    deploy.sh

Deployment means COPY.

Do not create symlinks.

Before deployment:

1. Create a timestamped backup of ~/.config.
2. Copy repository .config contents into ~/.config.
3. Make Sway scripts executable.
4. Reload/restart affected services where appropriate.

---

# Development workflow

1. Import Manjaro configuration.
2. Commit the untouched imported baseline.
3. Inspect each component.
4. Remove Manjaro-specific paths.
5. Make paths user-local.
6. Fix configuration for the installed versions of applications.
7. Test Sway.
8. Test Waybar.
9. Test Foot.
10. Test Mako.
11. Test Wofi.
12. Test screenshots.
13. Test recording.
14. Test audio/video.
15. Test Zsh.
16. Test user services.
17. Test deployment from a clean user configuration.

---

# Do not over-engineer

The goal is a practical personal desktop.

Do not introduce a framework merely for the sake of abstraction.

Prefer:

    simple files
    simple scripts
    predictable paths
    standard XDG locations
    portable shell

over complicated configuration generators.

---

# Final goal

The final repository should allow:

    git clone <repository>
    cd dotfiles
    ./install.sh
    ./deploy.sh

followed by installation of the required packages.

After deployment, the desktop should behave consistently across
Debian, Arch, and other compatible Linux systems.

The operating system provides:

    kernel
    drivers
    packages
    hardware access
    system services

The dotfiles provide:

    Sway
    Waybar
    Foot
    Mako
    Wofi
    themes
    scripts
    keybindings
    layouts
    user services
    Zsh
    desktop behavior