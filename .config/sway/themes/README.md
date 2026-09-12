# Theme System Documentation

## Overview

The theme system provides **one source of truth** for colors across all applications:

- Sway window manager
- Waybar status bar
- Foot terminal
- Mako notifications
- Wofi application launcher

Changes to a theme automatically propagate to all applications.

---

## Theme Switching

Switch themes using the `theme.sh` script:

```bash
~/.config/sway/themes/theme.sh dracula
~/.config/sway/themes/theme.sh matcha-green
~/.config/sway/themes/theme.sh catppuccin-mocha  # (when added)
```

Or from your Sway config:

```sway
# Reload Sway after running theme.sh
bindsym $mod+Shift+t exec ~/.config/sway/themes/theme.sh dracula && swaymsg reload
```

---

## Architecture

```
.config/sway/themes/
│
├── matcha-green.conf          ← Theme definition (source)
├── dracula.conf               ← Theme definition (source)
│
├── active.conf                ← Currently active theme (GENERATED)
│
├── generated/                 ← Application-specific colors (GENERATED)
│   ├── waybar-colors.css
│   ├── mako-colors
│   ├── wofi-colors.css
│   └── foot-colors.ini
│
└── theme.sh                   ← Theme orchestrator script
```

### theme.conf (Theme Definition)

Defines semantic colors using Sway variables:

```sway
set $background-color #141a1b
set $text-color #eeeeee
set $accent-color #16a085
set $color0 #000000
set $color1 #ff0000
# ... etc
```

### active.conf (Generated)

Sources the currently active theme colors. Updated by `theme.sh`.

This file is included by Sway config to apply colors immediately.

### generated/ (Generated Application Files)

Contains application-specific color configurations:

- **waybar-colors.css** — CSS variables for Waybar styling
- **mako-colors** — Configuration for Mako notifications
- **wofi-colors.css** — CSS for Wofi application launcher
- **foot-colors.ini** — Ini section for Foot terminal

Applications can source these files when starting.

---

## How Theme Switching Works

When you run `theme.sh dracula`:

1. **Validates** — Checks if `dracula.conf` exists
2. **Generates active.conf** — Extracts colors from `dracula.conf`
3. **Generates application colors** — Creates Waybar CSS, Mako config, etc.
4. **Reloads Sway** — Applies new colors immediately
5. **Restarts apps** — Kills/restarts Waybar, Mako to apply new colors

---

## Adding a New Theme

1. Create a theme definition file:

```bash
cat > ~/.config/sway/themes/catppuccin-mocha.conf << 'EOF'
# Catppuccin Mocha theme

set $background-color #1e1e2e
set $text-color #cdd6f4
set $accent-color #a6e3a1
# ... add all $colorN variables
EOF
```

2. Switch to the new theme:

```bash
~/.config/sway/themes/theme.sh catppuccin-mocha
```

3. The theme system automatically generates all application-specific colors.

---

## Required Colors in Theme Definition

Every theme must define:

- `$background-color` — Main background
- `$text-color` — Default text color
- `$accent-color` — Highlight/border color
- `$selection-color` — Selection/hover background

Additional colors (color0-color15) are used for terminal colors and extended palette.

---

## Integration with Applications

### Sway

Sway loads colors from `active.conf`:

```sway
include $HOME/.config/sway/themes/active.conf
```

Uses semantic colors for window borders:

```sway
client.focused $accent-color $accent-color $background-color ...
```

### Waybar

Waybar loads generated CSS:

```css
@import "~/.config/sway/themes/generated/waybar-colors.css";
```

### Mako

Mako loads generated config:

```bash
mako -c ~/.config/sway/themes/generated/mako-colors
```

Or include in `.config/mako/config`:

```ini
[style]
border-color=$(cat ~/.config/sway/themes/generated/mako-colors | grep border-color | cut -d= -f2)
```

### Wofi

Wofi loads generated CSS:

```css
@import "~/.config/sway/themes/generated/wofi-colors.css";
```

### Foot

Foot loads generated INI section.

---

## Currently Available Themes

- `matcha-green` (default) — Green accent, calm palette
- `dracula` — Dark purple accent, popular theme

---

## Testing Theme Switching

Verify themes work with:

```bash
# List available themes
ls ~/.config/sway/themes/*.conf | grep -v active | xargs -I {} basename {} .conf

# Switch themes
~/.config/sway/themes/theme.sh dracula

# Verify Sway reloaded
swaymsg -t get_version

# Check generated files
ls -la ~/.config/sway/themes/generated/

# Check active theme
cat ~/.config/sway/themes/active.conf | grep "# Current"
```

---

## Troubleshooting

### Theme doesn't apply immediately

Sway needs to reload:

```bash
swaymsg reload
```

Or restart the application:

```bash
pkill waybar && waybar &
```

### Colors look wrong after switching

Check that generated files were created:

```bash
ls ~/.config/sway/themes/generated/
cat ~/.config/sway/themes/active.conf
```

### Missing theme error

```bash
~/.config/sway/themes/theme.sh nonexistent
# Error: Theme not found: /home/user/.config/sway/themes/nonexistent.conf
```

Ensure the theme file exists:

```bash
ls ~/.config/sway/themes/*.conf
```

---

## Implementation Notes

- Generated files are created by `theme.sh` at runtime
- Initial `generated/` files are committed for fresh deployments
- Theme switching is idempotent (running twice has same result)
- No Sway restart required for Sway colors (included in active.conf)
- Waybar and Mako require restart to apply colors
- Color format is hex (#RRGGBB)
