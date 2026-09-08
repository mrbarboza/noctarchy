# Migration Guide: Omarchy → Noctarchy

Move from Omarchy (Hyprland + Quickshell) to Noctarchy (Niri + Noctalia) — **zero DHH/37signals/HEY content**.

## What changes

| Component | Omarchy | Noctarchy |
|-----------|---------|------------|
| Compositor | Hyprland (Lua) | Niri (KDL) |
| Desktop Shell | Quickshell (QML) | Noctalia (TOML) |
| Config style | Lua + QML | KDL + TOML |
| DHH content | ✅ Present | ❌ Removed |

## What to keep

These configs from Omarchy work as-is:

- `config/kitty/` — Terminal
- `config/tmux/` — Terminal multiplexer
- `config/git/` — Git config
- `config/lazygit/` — Git TUI
- `config/btop/` — System monitor
- `config/starship.toml` — Shell prompt
- `bin/` — Utility scripts
- `.editorconfig` — Editor settings

## What to adapt

### 1. Compositor config

**Omarchy:** `config/hypr/*.lua`
**Noctarchy:** `config/niri/config.kdl`

Key differences:
- Niri uses **KDL** (Rust config format)
- Scrollable-tiling paradigm (columns, not grids)
- Hot-reload automatic
- No `exec-once` (use `spawn-at-startup`)

### 2. Desktop shell

**Omarchy:** `shell/` (Quickshell/QML widgets)
**Noctalia:** `config/noctalia/config.toml`

Noctalia provides:
- Bar (top panel)
- Launcher (app search)
- Notifications
- Lockscreen
- Wallpaper
- Clipboard history

### 3. Keybindings

Replace HEY shortcuts:

```kdl
// ❌ Omarchy (DHH/HEY)
// bind "Mod+Shift+E" { spawn "hey-electron"; }
// bind "Mod+Shift+C" { spawn "hey-calendar"; }

// ✅ Noctarchy (generic) — niri binds have no "bind" keyword and no
// quotes around the key combo; see config/niri/config.kdl for the full set.
Mod+Shift+E { spawn "firefox"; }
Mod+Shift+C { spawn "kitty" "-e" "btop"; }
```

## Step-by-step migration

### 1. Backup

```bash
mv ~/.config/hypr ~/.config/hypr.backup
mv ~/.config/quickshell ~/.config/quickshell.backup
```

### 2. Install Niri + Noctalia

```bash
# Arch
yay -S niri-git noctalia-git

# NixOS
# Add inputs.niri and inputs.noctalia to flake
```

### 3. Copy Noctarchy configs

```bash
git clone https://github.com/mrbarboza/noctarchy
cd noctarchy

# Copy niri + noctalia
cp -r config/niri ~/.config/niri
cp -r config/noctalia ~/.config/noctalia

# Copy apps (kitty, tmux, etc.)
cp -r config/kitty ~/.config/kitty
cp -r config/tmux ~/.config/tmux
cp -r config/git ~/.config/git
cp -r config/lazygit ~/.config/lazygit
cp -r config/btop ~/.config/btop
cp config/starship.toml ~/.config/starship.toml
```

### 4. Start Niri

```bash
# From TTY
niri

# Or add to display manager
```

### 5. Test and adjust

- Check keybindings work
- Adjust scale/output in `config.kdl`
- Customize Noctalia bar in `config.toml`

## Troubleshooting

### Niri won't start

```bash
# Check logs
niri --help

# Test config
niri -c ~/.config/niri/config.kdl
```

### Noctalia bar not showing

```bash
# Check if running
pgrep noctalia

# Restart
killall noctalia && noctalia &
```

### Missing apps

```bash
# Install common deps
yay -S kitty tmux git lazygit btop starship firefox
```

## Resources

- [Niri docs](https://niri.computer/)
- [Noctalia docs](https://docs.noctalia.dev/)
- [KDL format](https://kdl.dev/)
