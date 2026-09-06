# Noctarchy

**Niri + Noctalia** desktop configuration inspired by Omarchy

## What is this?

A clean, opinionated Wayland desktop setup using:
- **Niri** — Scrollable-tiling Wayland compositor (Rust)
- **Noctalia** — Modern desktop shell (bar, launcher, notifications, lockscreen)

## Quick start

### Arch Linux

```bash
# Install
yay -S niri-git noctalia-git

# Clone this repo
git clone https://github.com/mrbarboza/noctarchy.git
cd noctarchy

# Copy configs
cp -r config/niri ~/.config/niri
cp -r config/noctalia ~/.config/noctalia

# Start
niri
```

### NixOS

```nix
{
  programs.niri.enable = true;
  home.packages = [ inputs.noctalia.packages.${system}.default ];
}
```

## Config structure

```
config/
├── niri/           # Niri compositor (config.kdl)
├── noctalia/       # Noctalia shell (config.toml)
├── kitty/          # Terminal
├── tmux/           # Terminal multiplexer
└── lazygit/        # Git TUI
```

## Keybindings

| Key | Action |
|-----|--------|
| `Super+Return` | Open terminal (kitty) |
| `Super+Space` | Launcher / Overview |
| `Super+H/J/K/L` | Navigate windows |
| `Super+Shift+Q` | Close window |
| `Super+1-9` | Switch workspace |
| `Super+Shift+1-9` | Move to workspace |
| `Super+Shift+S` | Screenshot UI |
| `Super+Shift+E` | Open Firefox (no HEY!) |
| `Super+Shift+C` | Open btop (no HEY Calendar!) |

## Why Niri + Noctalia?

- **Scrollable-tiling**: Infinite columns, unique workflow
- **Unified shell**: Noctalia handles bar, launcher, notifications, lockscreen
- **Hot-reload**: Niri auto-reloads config
- **Native Wayland**: No X11 legacy
- **Clean**: Zero DHH/37signals/HEY content

## Migration from Omarchy

Keep:
- `config/kitty/`, `config/tmux/`, `config/lazygit/`, `config/git/`
- Scripts in `bin/`
- Themes, `.editorconfig`, `.starship.toml`

Adapt:
- `config/hypr/*` → `config/niri/config.kdl`
- `shell/*` (Quickshell) → `config/noctalia/config.toml`

See `docs/MIGRATION.md` for details.

## License

MIT
