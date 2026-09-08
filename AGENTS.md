# Project agent memory

This file is the project's committed home for project-intrinsic agent knowledge: build, test, release, architecture, and sharp-edge notes that should travel with the code.

- Add durable project-specific notes here as they are discovered through real work.
- Niri and Noctalia read from separate, non-overlapping config directories: niri's own files live under `~/.config/niri/` (this repo's `config/niri/`), Noctalia's own files live under `~/.config/noctalia/` (this repo's `config/noctalia/`). Never mix the two.
- niri has no top-level `color` node - colors only exist nested under blocks like `layout { focus-ring { ... } border { ... } }`. Do not hand-write niri KDL for colors. Enable Noctalia's own builtin `niri` template instead (`~/.config/noctalia/templates.toml`, `enable_builtin_templates = true`) - see `docs/THEMES.md`. Noctalia's `apply.sh` then owns `~/.config/niri/noctalia.kdl` and the `include` line in `config.kdl`.
- `config/noctalia/config.toml` must match Noctalia's real schema (e.g. `[bar.main]` with `start`/`center`/`end` widget arrays, `[wallpaper.default] path`) - Noctalia silently ignores unknown keys rather than erroring, so a schema mismatch fails quietly with no error message.
- `bin/theme-select` writes the selected theme to `~/.config/noctalia/theme.toml`; it does not generate niri colors (that's the builtin template's job, see above).
- `install.sh` has no mechanism for installing per-app terminal configs (kitty/alacritty/foot/ghostty/tmux/git/lazygit/btop) - it only installs `config/noctalia/` and `bin/`. `docs/MIGRATION.md` documents manual `cp -r config/<app> ~/.config/<app>` for those instead.
- Each terminal's config includes a same-directory theme file (e.g. kitty's `include catppuccin-mocha.conf`, alacritty's `general.import`, foot's `include=`, ghostty's `config-file =`) that nothing in this repo currently generates - it's a placeholder convention carried over from Omarchy's now-removed dynamic theme symlink, not yet wired to `bin/theme-select`.

## Maintaining this file

Keep this file for knowledge useful to almost every future agent session in this project.
Do not repeat what the codebase already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
When updating this file, preserve this bar for all agents and keep entries concise.
