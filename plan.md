# Portable Sway Dotfiles — Master Plan

## 0. Project Goal

Build a portable, user-specific Linux desktop configuration based primarily on
the Manjaro Sway desktop-settings project, but redesigned so that the final
configuration is independent of Manjaro/Arch system paths.

The repository is intended to work on different Linux distributions such as:

- Debian
- Ubuntu
- Arch
- Manjaro
- other Linux distributions using Sway/Wayland

The repository contains USER configuration only.

The operating system is responsible for:

- installing packages
- providing system libraries
- providing kernel/device support
- providing hardware configuration
- providing system-wide configuration

The dotfiles repository is responsible for:

- Sway configuration
- Sway keybindings
- Sway modes
- Sway input configuration
- Waybar
- Foot
- Mako
- Wofi
- Swappy
- Zsh
- user-level systemd services
- scripts
- themes
- theme switching
- application configuration
- user-level desktop behavior

The configuration must not depend on Manjaro-specific `/etc` or `/usr/share`
configuration.

---

# 1. Non-Negotiable Rules

These rules must be followed throughout the project.

## 1.1 No system-specific Sway paths

DO NOT depend on:

    /etc/sway
    /usr/share/sway

The final user configuration must live under:

    ~/.config/

Scripts must use `$HOME` or XDG paths where appropriate.

---

## 1.2 No Manjaro-specific assumptions

Do not assume:

- Manjaro
- Arch
- pacman
- Pamac
- Manjaro-specific services
- Manjaro-specific system files
- Manjaro-specific directories

Manjaro is the source/reference implementation, not the runtime
environment.

---

## 1.3 No symlinks

The deployment system must COPY files.

Do not create:

    ln -s
    symbolic links
    hard links

The repository is the source of truth, but deployment is copy-based.

---

## 1.4 User configuration only

Do not modify `/etc` as part of normal dotfiles deployment.

Do not install system services into:

    /etc/systemd/system

User services belong under:

    ~/.config/systemd/user/

---

## 1.5 Theme colors have one source of truth

Do not hard-code the same palette independently in:

- Sway
- Waybar
- Foot
- Mako
- Wofi
- other applications

A theme must define the palette once.

Application-specific configuration must consume that palette.

---

## 1.6 No hard-coded Manjaro paths

If the original Manjaro configuration contains:

    /usr/share/sway/scripts/foo.sh

the portable implementation must instead reference the equivalent
user configuration path, for example:

    $HOME/.config/sway/scripts/foo.sh

or an appropriate XDG-based path.

---

## 1.7 ~/.zshrc must remain minimal

The real Zsh configuration belongs inside:

    ~/.config/zsh/

The user's home `.zshrc` should only load the repository configuration.

Example:

    source "$HOME/.config/zsh/.zshrc"

Do not put the full Zsh configuration into `~/.zshrc`.

---

# 2. Target Repository Structure

The target repository should eventually resemble:

    dotfiles/
    │
    ├── .config/
    │   │
    │   ├── sway/
    │   │   ├── config
    │   │   │
    │   │   ├── config.d/
    │   │   │   ├── 10-inputs.conf
    │   │   │   ├── 20-keybindings.conf
    │   │   │   ├── 30-window-rules.conf
    │   │   │   ├── 40-startup.conf
    │   │   │   ├── 50-modes.conf
    │   │   │   └── 90-theme.conf
    │   │   │
    │   │   ├── definitions.d/
    │   │   │   └── variables.conf
    │   │   │
    │   │   ├── inputs/
    │   │   │   ├── keyboard.conf
    │   │   │   └── touchpad.conf
    │   │   │
    │   │   ├── modes/
    │   │   │   ├── default.conf
    │   │   │   ├── resize.conf
    │   │   │   ├── recording.conf
    │   │   │   ├── screenshot.conf
    │   │   │   ├── scratchpad.conf
    │   │   │   └── shutdown.conf
    │   │   │
    │   │   ├── scripts/
    │   │   │   ├── theme.sh
    │   │   │   ├── screenshot.sh
    │   │   │   ├── recorder.sh
    │   │   │   ├── brightness.sh
    │   │   │   ├── lock.sh
    │   │   │   └── ...
    │   │   │
    │   │   ├── themes/
    │   │   │   ├── active.conf
    │   │   │   ├── matcha-green/
    │   │   │   │   └── theme.conf
    │   │   │   ├── matcha-blue/
    │   │   │   │   └── theme.conf
    │   │   │   ├── dracula/
    │   │   │   │   └── theme.conf
    │   │   │   └── catppuccin-mocha/
    │   │   │       └── theme.conf
    │   │   │
    │   │   └── generated/
    │   │       ├── waybar/
    │   │       ├── foot/
    │   │       ├── mako/
    │   │       └── wofi/
    │   │
    │   ├── waybar/
    │   │   ├── config.jsonc
    │   │   └── style.css
    │   │
    │   ├── foot/
    │   │   └── foot.ini
    │   │
    │   ├── mako/
    │   │   └── config
    │   │
    │   ├── wofi/
    │   │   ├── config
    │   │   └── style.css
    │   │
    │   ├── swappy/
    │   │   └── config
    │   │
    │   ├── systemd/
    │   │   └── user/
    │   │       ├── waybar.service
    │   │       ├── mako.service
    │   │       ├── foot-server.service
    │   │       └── ...
    │   │
    │   └── zsh/
    │       ├── .zshrc
    │       └── config.d/
    │           ├── history.zsh
    │           ├── completion.zsh
    │           ├── plugins.zsh
    │           ├── appearance.zsh
    │           ├── aliases.zsh
    │           └── local.zsh
    │
    ├── packages/
    │   ├── apt.txt
    │   └── pacman.txt
    │
    ├── scripts/
    │   ├── install.sh
    │   └── deploy.sh
    │
    ├── README.md
    └── plan.md

The exact final file names may change during implementation, but the
architecture must remain equivalent.

---

# 3. Manjaro Configuration Migration

The Manjaro Sway repository is the reference implementation.

Relevant source areas include:

    etc/sway/
    etc/skel/.config/sway/
    etc/skel/.config/waybar/
    etc/skel/.config/foot/
    etc/skel/.config/zsh/
    usr/share/sway/scripts/
    usr/share/sway/templates/
    usr/share/sway/themes/
    etc/systemd/user/

The migration process is:

    Manjaro source
          ↓
    understand functionality
          ↓
    remove system-specific assumptions
          ↓
    move into ~/.config
          ↓
    adapt paths
          ↓
    test
          ↓
    commit

Do not blindly copy the entire Manjaro repository.

Only migrate functionality that belongs to the portable user desktop.

---

# 4. Things NOT to Migrate

Do not migrate Manjaro-specific infrastructure such as:

- pacman hooks
- Pamac integration
- Manjaro package management logic
- Manjaro-only tray applications
- Manjaro-specific system-wide configuration
- system-level `/etc` configuration
- Manjaro branding unless explicitly wanted as a theme
- distribution-specific update mechanisms

If a feature requires a package, document the package dependency instead.

---

# 5. Sway Configuration

The main Sway entry point is:

    ~/.config/sway/config

The main config should include modular configuration files from:

    ~/.config/sway/config.d/

Use modular files where it improves readability.

Suggested separation:

    10-inputs.conf
        keyboard and touchpad behavior

    20-keybindings.conf
        normal keybindings

    30-window-rules.conf
        application/window rules

    40-startup.conf
        startup applications

    50-modes.conf
        Sway modes

    90-theme.conf
        theme variables

The exact numbering can be changed if required.

---

# 6. Sway Inputs

Keep input configuration user-specific.

Example areas:

- keyboard layout
- repeat rate
- touchpad
- natural/inverse scrolling
- tap-to-click
- pointer behavior

Do not depend on hardware-specific identifiers unless necessary.

Prefer stable Sway input matching rules.

---

# 7. Sway Modes

Preserve the useful Manjaro Sway modes.

Potential modes:

- default
- resize
- recording
- screenshot
- scratchpad
- shutdown

Each mode should be independently understandable.

Avoid placing large amounts of mode logic directly into the main config.

---

# 8. Sway Scripts

All Sway-specific scripts belong under:

    ~/.config/sway/scripts/

Scripts must:

- use `$HOME`
- use XDG paths where appropriate
- avoid `/usr/share/sway`
- avoid `/etc/sway`
- fail gracefully when optional dependencies are missing
- check required commands where appropriate
- remain portable between Debian and Arch where practical

Examples:

- theme switching
- screenshots
- recording
- brightness
- locking
- notifications
- scratchpad
- background
- display management

Scripts should not silently assume that Manjaro-specific utilities exist.

---

# 9. Theme System

The theme system is a major component.

There must be one semantic palette per theme.

Example:

    background
    background_alt
    foreground
    foreground_muted

    primary
    secondary
    accent

    red
    green
    yellow
    blue
    magenta
    cyan

Additional semantic values may be added when needed.

A theme should look conceptually like:

    .config/sway/themes/matcha-green/theme.conf

Example:

    background="#141a1b"
    background_alt="#1e2526"

    foreground="#d3d7cf"
    foreground_muted="#9da7a0"

    primary="#88ad62"
    secondary="#5f875f"
    accent="#88ad62"

    red="#e86671"
    green="#88ad62"
    yellow="#e8c874"
    blue="#5f819d"
    magenta="#b18bbd"
    cyan="#61c0bf"

The exact colors should come from the chosen Manjaro theme/reference
implementation where appropriate.

---

# 10. Theme Switching

The main theme script:

    ~/.config/sway/scripts/theme.sh

Example usage:

    theme.sh matcha-green
    theme.sh dracula
    theme.sh catppuccin-mocha

The script must:

1. validate the requested theme
2. load the theme definition
3. make it the active theme
4. generate application-specific theme files
5. reload/restart affected user applications
6. reload Sway when necessary
7. provide useful errors when a theme does not exist

There must be no need to manually edit five applications to change a theme.

---

# 11. Active Theme

Do not use symbolic links for the active theme.

Use a regular generated/configuration file such as:

    ~/.config/sway/themes/active.conf

The theme script may rewrite this file.

The active theme should be easily inspectable.

For example:

    cat ~/.config/sway/themes/active.conf

should show the currently active palette.

---

# 12. Application Theme Generation

Sway, Waybar, Foot, Mako, Wofi and other applications have different
configuration formats.

They cannot all directly consume the same syntax.

Therefore:

    theme definition
          ↓
    active palette
          ↓
    application-specific generated configuration

Examples:

    generated/waybar/colors.css
    generated/foot/colors.ini
    generated/mako/colors.conf
    generated/wofi/colors.css

Application configs should reference these generated values where possible.

Do not duplicate the palette manually.

---

# 13. Waybar

Waybar configuration belongs under:

    ~/.config/waybar/

At minimum:

    config.jsonc
    style.css

Waybar should use generated theme colors.

Do not hard-code a complete independent color palette into Waybar.

The theme system must be able to update Waybar when switching themes.

Waybar should start automatically as part of the user desktop.

---

# 14. Foot

Foot configuration belongs under:

    ~/.config/foot/

Use:

    foot.ini

Foot configuration must not use Manjaro-specific paths.

Do not use unsupported Foot configuration options.

Before committing Foot configuration, validate it using the installed version:

    foot --check-config

or the appropriate validation mechanism supported by the installed Foot
version.

Theme colors should come from the theme system.

---

# 15. Mako

Mako configuration belongs under:

    ~/.config/mako/config

Mako should be configured as a user notification daemon.

Theme values should come from the active theme.

The configuration must not require:

    /etc/mako
    /usr/share/sway

Mako should be started as a user service or through an appropriate Sway
startup mechanism.

Do not duplicate startup mechanisms unnecessarily.

---

# 16. Wofi

Wofi configuration belongs under:

    ~/.config/wofi/

Possible files:

    config
    style.css

Wofi should consume theme colors from the theme system.

---

# 17. Swappy

Swappy configuration belongs under:

    ~/.config/swappy/config

Use it for screenshot annotation/editing if the feature is retained from
the Manjaro configuration.

---

# 18. User Systemd Services

User services belong under:

    ~/.config/systemd/user/

Do not install them into:

    /etc/systemd/system/

Potential services:

    waybar.service
    mako.service
    foot-server.service
    other useful user-level services

Services should reference user-local configuration and scripts.

They must not reference:

    /usr/share/sway
    /etc/sway

After deployment:

    systemctl --user daemon-reload

should be sufficient to make new user services available.

Only enable services that actually exist and are required.

---

# 19. Avoid Duplicate Startup

A program should not be started by multiple mechanisms.

For example, do not simultaneously start Waybar through:

    systemd user service

and:

    exec waybar

unless there is a deliberate reason.

Choose one startup mechanism.

Prefer user systemd services for persistent daemons where practical.

---

# 20. Zsh Architecture

The home directory should contain only a minimal loader:

    ~/.zshrc

Example:

    source "$HOME/.config/zsh/.zshrc"

Actual configuration:

    ~/.config/zsh/.zshrc

Modular configuration:

    ~/.config/zsh/config.d/

Suggested files:

    history.zsh
    completion.zsh
    plugins.zsh
    appearance.zsh
    aliases.zsh
    local.zsh

The loader must safely handle an empty `config.d` directory.

Use appropriate Zsh glob handling so an empty directory does not produce:

    no matches found

---

# 21. Zsh Plugins

The dotfiles must not assume that plugins exist.

Dependencies such as:

- zsh
- zsh-autosuggestions
- zsh-syntax-highlighting

are installed through the package manager.

The configuration may detect the expected plugin locations and load them
when present.

Missing optional plugins should not make the entire shell unusable.

---

# 22. Package Dependencies

Packages belong outside `.config`.

Repository structure:

    packages/
        apt.txt
        pacman.txt

The files may contain equivalent functionality using different package
names.

Example:

    Debian package name != Arch package name

This is expected.

The configuration should not attempt to install packages.

---

# 23. Installation

`scripts/install.sh` is responsible for installing dependencies using the
native package manager.

It should:

1. detect the distribution/package manager
2. select the correct dependency file
3. install required packages
4. report missing packages clearly
5. avoid modifying unrelated configuration

Do not assume the user has sudo configured without checking.

---

# 24. Deployment

`scripts/deploy.sh` is responsible for copying repository configuration
into the real home directory.

It must NOT create symlinks.

Source:

    dotfiles/.config/

Destination:

    ~/.config/

Example conceptual behavior:

    cp -a .config/. "$HOME/.config/"

The deployment script should:

- create destination directories when necessary
- copy files recursively
- preserve permissions where appropriate
- avoid deleting unrelated user configuration by default
- clearly report what it is doing

A destructive "replace everything" mode should only exist if explicitly
implemented and clearly documented.

---

# 25. Home-Level Files

Some configuration files are not inside `.config`.

For example:

    ~/.zshrc

If the repository manages these files, they should be explicitly stored in
the repository and deployed separately.

Do not silently overwrite unrelated home files.

---

# 26. XDG Principles

Prefer:

    $HOME
    $XDG_CONFIG_HOME
    $XDG_DATA_HOME
    $XDG_CACHE_HOME
    $XDG_STATE_HOME
    $XDG_RUNTIME_DIR

where appropriate.

Default XDG config location:

    ${XDG_CONFIG_HOME:-$HOME/.config}

Scripts should not assume `.config` is always the only possible location
when an XDG variable provides a better solution.

---

# 27. Portability

The target is:

    same repository
        +
    correct dependencies
        =
    usable desktop

on:

    Debian
    Arch
    Manjaro
    other compatible Linux distributions

Differences in:

- package names
- system paths
- package versions

must be isolated as much as possible.

Application configuration itself should remain portable.

---

# 28. Validation

Before considering the migration complete, validate:

## Sway

    sway -C ~/.config/sway/config

or the appropriate configuration validation command.

Then:

    swaymsg reload

and check for errors.

---

## Waybar

Start/restart Waybar and verify:

- bar appears
- modules work
- icons render
- theme colors are correct
- no missing command errors

---

## Foot

Validate Foot configuration.

Verify:

- terminal launches
- fonts work
- colors work
- shell launches correctly

---

## Mako

Verify:

- daemon starts
- notifications appear
- theme applies

---

## Wofi

Verify:

- launcher opens
- keyboard navigation works
- theme applies

---

## Zsh

Open a new shell and verify:

- completion
- history
- autosuggestions
- syntax highlighting
- aliases
- prompt

A missing optional plugin must not break shell startup.

---

## User services

Check:

    systemctl --user daemon-reload
    systemctl --user status <service>

Verify services do not depend on `/etc/sway` or `/usr/share/sway`.

---

# 29. Theme Validation

For every theme:

1. activate the theme
2. verify Sway colors
3. verify Waybar
4. verify Foot
5. verify Mako
6. verify Wofi
7. verify no hard-coded old colors remain

Example:

    theme.sh matcha-green

then:

    theme.sh dracula

then:

    theme.sh matcha-green

The configuration must remain functional after repeated theme switching.

---

# 30. Scripts

Scripts must be:

- executable
- readable
- reasonably defensive
- portable
- documented when non-obvious

Use:

    #!/usr/bin/env bash

or:

    #!/usr/bin/env sh

where appropriate.

Do not use Bash-only syntax when the script claims to be POSIX shell.

Do not assume commands exist without considering dependency documentation.

---

# 31. Generated Files

Generated files must be clearly distinguished from source configuration.

Source:

    themes/*/theme.conf

Generated:

    generated/

Do not manually edit generated theme files.

The theme generator is the source of generated configuration.

If generated files are committed to Git, document why.

Otherwise, prefer generating them during:

    installation
    deployment
    theme switching

---

# 32. Git

The Git repository should contain the portable source configuration.

Do not commit:

- caches
- runtime files
- logs
- machine-specific state
- generated temporary files
- secrets
- SSH private keys
- browser profiles
- credentials

Machine-specific overrides should be kept in clearly documented local
configuration files.

---

# 33. Machine-Specific Configuration

The main configuration should remain portable.

When machine-specific configuration is unavoidable, isolate it.

Examples:

    config.d/local.conf
    zsh/config.d/local.zsh

These files should either:

- be ignored by Git
- or contain only safe generic defaults

Do not pollute the core configuration with one-machine hardware settings.

---

# 34. Manjaro Theme Compatibility

The Manjaro Sway theme system should be used as the visual reference.

Relevant concepts to preserve:

- theme definitions
- theme packages
- Foot themes
- Waybar colors
- Sway colors
- theme switching
- background handling
- notification colors

However, the implementation must be adapted to the portable
`.config` architecture.

Do not reproduce Manjaro's system-wide installation layout.

---

# 35. Implementation Order

Implement in this order.

## Phase 1 — Repository structure

Create:

    .config/
    packages/
    scripts/
    README.md
    plan.md

---

## Phase 2 — Sway base

Migrate:

- Sway config
- config.d
- inputs
- modes
- definitions

Make Sway start successfully.

---

## Phase 3 — Sway scripts

Migrate useful scripts.

Replace:

    /etc/sway
    /usr/share/sway

references with user-local/XDG paths.

---

## Phase 4 — Theme engine

Implement:

    themes/
    active.conf
    theme.sh

Start with one theme:

    matcha-green

Then add additional themes.

---

## Phase 5 — Application configs

Migrate:

- Waybar
- Foot
- Mako
- Wofi
- Swappy

Connect them to the theme engine.

---

## Phase 6 — User services

Migrate useful user services.

Remove duplicate startup methods.

---

## Phase 7 — Zsh

Create modular Zsh configuration.

Keep:

    ~/.zshrc

as a minimal loader.

---

## Phase 8 — Package management

Complete:

    packages/apt.txt
    packages/pacman.txt
    scripts/install.sh

---

## Phase 9 — Deployment

Complete:

    scripts/deploy.sh

Deployment must be copy-only.

---

## Phase 10 — Testing

Test on:

- current Debian system
- clean/second Linux environment if available

Verify that the configuration works after copying `.config`.

---

# 36. Definition of Done

The project is complete when:

- [ ] Sway works from `~/.config/sway`
- [ ] No Sway config depends on `/etc/sway`
- [ ] No Sway config depends on `/usr/share/sway`
- [ ] Waybar works
- [ ] Foot works
- [ ] Mako works
- [ ] Wofi works
- [ ] Swappy works if retained
- [ ] Zsh works
- [ ] User systemd services work
- [ ] Sway scripts work
- [ ] Theme system works
- [ ] Theme switching works
- [ ] One palette controls all supported applications
- [ ] No duplicated hard-coded theme palettes exist
- [ ] Matcha Green works
- [ ] At least one additional theme works
- [ ] `.zshrc` is only a loader
- [ ] Package dependencies are documented
- [ ] Debian package installation works
- [ ] Arch package installation works
- [ ] Deployment uses copying, not symlinks
- [ ] Deployment does not destroy unrelated configuration
- [ ] No Manjaro-specific runtime paths remain
- [ ] No secrets are committed
- [ ] README explains installation
- [ ] README explains deployment
- [ ] README explains theme switching
- [ ] README explains dependencies

---

# 37. Current Status

Before modifying anything, inspect the existing repository and mark each
item as:

    DONE
    PARTIAL
    TODO
    NOT NEEDED

Do not recreate working configuration unnecessarily.

Preserve working parts and refactor them toward the architecture defined
above.

The Manjaro repository is the reference implementation.

The final repository is the portable implementation.