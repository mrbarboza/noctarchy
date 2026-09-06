# Noctarchy

A beautiful, themeable niri window manager configuration with 22 curated color schemes.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/mrbarboza/noctarchy.git
cd noctarchy

# Run the installer (installs to ~/.config/niri with tokyo-night theme)
./install.sh

# Or install with a different theme
./install.sh -t gruvbox

# Start niri
niri
```

## Available Themes

Noctarchy includes **22 carefully curated themes**:

| Theme | Description |
|-------|-------------|
| `tokyo-night` | Dark blue/purple Tokyo night sky (default) |
| `gruvbox` | Warm retro terminal colors |
| `nord` | Cool arctic blue tones |
| `catppuccin` | Modern pastel purple |
| `everforest` | Natural green forest tones |
| `kanagawa` | Japanese wave-inspired |
| `rose-pine` | Soft rose and pine |
| `miasma` | GitHub dark dimmed |
| `matte-black` | Sleek dark dracula |
| `lumon` | Severance-inspired red |
| `lupine` | Purple wolf theme |
| `solitude` | Calm moon variant |
| `hackerman` | Matrix green terminal |
| `flexoki-light` | Light flexible palette |
| `osaka-jade` | Green jade tones |
| `retro-82` | Synthwave neon |
| `ristretto` | Warm coffee tones |
| `vantablack` | Pure black minimal |
| `white` | Clean light GitHub |
| `ethereal` | Dreamy blue moon |
| `last-horizon` | Pink sunset horizon |
| `catppuccin-latte` | Light catppuccin |

## Theme Switching

Switch themes anytime with:

```bash
# Switch to a theme
~/.config/niri/bin/theme-select <theme-name>

# Example: switch to gruvbox
~/.config/niri/bin/theme-select gruvbox

# List available themes
ls ~/.config/niri/themes
```

## Manual Installation

If you prefer manual setup:

```bash
# Copy config files
cp config/noctalia/config.toml ~/.config/niri/config.toml
cp config/noctalia/theme.toml ~/.config/niri/theme.toml
cp config/noctalia/themed/*.toml ~/.config/niri/themed/

# Copy scripts
cp bin/* ~/.config/niri/bin/
chmod +x ~/.config/niri/bin/*

# Copy themes (optional reference)
cp -r themes ~/.config/niri/

# Copy utility scripts
cp scripts/* ~/.config/niri/scripts/
chmod +x ~/.config/niri/scripts/*

# Apply initial theme
~/.config/niri/bin/theme-select tokyo-night
```

## Project Structure

```
noctarchy/
├── config/
│   └── noctalia/
│       ├── config.toml      # Main niri config
│       ├── theme.toml       # Default theme setting
│       └── themed/          # Pre-generated theme configs
├── themes/
│   └── <theme-name>/
│       ├── colors.toml      # Full color palette
│       ├── icons.theme      # Icon pack reference
│       ├── keyboard.rgb     # Keyboard backlight color
│       ├── neovim.lua       # Neovim plugin config
│       ├── shell.lock.toml  # Lock screen colors
│       └── vscode.json      # VS Code theme reference
├── bin/
│   └── theme-select         # Theme switching script
├── scripts/
│   └── sync-themes.sh       # Theme sync utility
├── install.sh               # Installation script
└── README.md
```

## Configuration

### Default Theme

Edit `~/.config/niri/theme.toml` to change the default:

```toml
# Default theme for Noctalia
name = "tokyo-night"
```

### Custom Colors

Each theme's `colors.toml` in `themes/<name>/` defines:
- Background/foreground colors
- Accent colors
- Special colors (red, green, yellow, blue, etc.)
- UI element colors

## Requirements

- [niri](https://github.com/YaLTeR/niri) window manager
- Bash 4.0+ (for the installer)

## License

MIT

## Contributing

1. Fork the repo
2. Create a feature branch
3. Make your changes
4. Submit a PR

---

**Enjoy Noctarchy! 🌙**
