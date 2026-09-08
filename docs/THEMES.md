# Noctarchy Themes Catalog

All themes ported from Omarchy — **zero DHH/37signals/HEY references**.

## Available themes

| Theme | Colors | Style | Best for |
|-------|--------|-------|----------|
| **Catppuccin Mocha** | Dark, cool | Modern, vibrant | General use, coding |
| **Catppuccin Latte** | Light, warm | Clean, minimal | Day use, bright rooms |
| **Tokyo Night** | Dark, purple | Futuristic, cyberpunk | Night coding, gaming |
| **Gruvbox** | Dark, warm | Retro, earthy | Terminal lovers |
| **Nord** | Dark, cool | Arctic, professional | Minimalists |
| **Everforest** | Dark, green | Nature, soft | Eye comfort |
| **Kanagawa** | Dark, purple | Japanese, elegant | Designers |
| **Rose Pine** | Dark, pink | Soft, aesthetic | Creative work |
| **Flexoki Light** | Light, warm | Paper-like | Reading, writing |
| **Last Horizon** | Dark, blue | Deep, calm | Focus work |
| **Lumon** | Dark, corporate | Severance-themed | Fun, themed setups |
| **Lupine** | Dark, purple | Wolf-inspired | Night owls |
| **Matte Black** | Dark, monochrome | Minimal, sleek | Professionals |
| **Miasma** | Dark, green | Swampy, unique | Alternative look |
| **Osaka Jade** | Dark, green | Japanese, neon | Cyberpunk fans |
| **Retro 82** | Dark, amber | 80s terminal | Nostalgia |
| **Ristretto** | Dark, brown | Coffee-inspired | Warm vibes |
| **Solitude** | Dark, blue | Calm, isolated | Focus, minimal |
| **Vantablack** | Dark, black | Pure black | OLED screens |
| **White** | Light, pure | Clean, stark | Minimalists |
| **Ethereal** | Dark, misty | Dreamy, soft | Relaxing setups |
| **Hackerman** | Dark, green | Hacker, matrix | Themed fun |

## How to use

### Noctalia

Noctalia only ever reads `~/.config/noctalia/`.
Edit `~/.config/noctalia/theme.toml` to pick the active theme (written by `bin/theme-select`).

Enable Noctalia's own builtin `niri` template so it generates correct niri color config for you,
in `~/.config/noctalia/templates.toml`:

```toml
[theme.templates]
enable_builtin_templates = true
builtin_ids = ["niri", "gtk3", "gtk4", "qt", "kitty", "btop", "starship"]
```

Noctalia's own `apply.sh` then owns `~/.config/niri/noctalia.kdl` and keeps the `include` line in
`~/.config/niri/config.kdl` up to date; niri hot-reloads on file change, no manual reload needed.

### Niri

niri's own files live under `~/.config/niri/`.
Do not hand-write `color` nodes at the top level of `config.kdl` - niri only nests colors under
blocks like `layout { focus-ring { ... } border { ... } }`, which is exactly what Noctalia's
builtin `niri` template above generates for you.

### Kitty

Copy theme colors to `~/.config/kitty/catppuccin.conf`:

```conf
# Catppuccin Mocha
cursor #f5e0dc
cursor_text_color #1e1e2e
selection_foreground #1e1e2e
selection_background #cdd6f4
color0 #45475a
color1 #f38ba8
color2 #a6e3a1
color3 #f9e2af
color4 #89b4fa
color5 #f5c2e7
color6 #94e2d5
color7 #bac2de
color8 #585b70
color9 #f38ba8
color10 #a6e3a1
color11 #f9e2af
color12 #89b4fa
color13 #f5c2e7
color14 #94e2d5
color15 #a6adc8
```

### Tmux

Add to `~/.tmux.conf`:

```tmux
# Catppuccin Mocha
set -g @catppuccin_variant "mocha"
```

### Starship

Already configured in `config/starship.toml` with Catppuccin colors.

### Neovim

Add to `~/.config/nvim/init.lua`:

```lua
-- Catppuccin
require('catppuccin').setup({
  flavour = "mocha",
})
vim.cmd.colorscheme "catppuccin"
```

### VSCode

Install extension: `Catppuccin.catppuccin-vsc`

Or import theme JSON from `themes/catppuccin/vscode.json`.

## Theme sync

Themes are synced from [Omarchy](https://github.com/omacom/omarchy/tree/main/themes).

To update:

```bash
cd noctarchy
git remote add upstream https://github.com/omacom/omarchy
git fetch upstream
git checkout upstream/main -- themes/
git commit -m "Sync themes from Omarchy"
```

## Request new themes

Open an issue on GitHub with the theme name from Omarchy.

## License

Same as Omarchy (MIT).
