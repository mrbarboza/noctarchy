#!/usr/bin/env bash
#
# Noctarchy Uninstaller
# Reverses everything install.sh puts on a machine
#
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
NIRI_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/niri"
NOCTALIA_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/noctalia"
WIREPLUMBER_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/wireplumber"
DRY_RUN=false
FORCE=false
ASSUME_YES=false
NO_RESTORE=false

# Print colored output
info()    { echo -e "${BLUE}ℹ${NC}  $*"; }
success() { echo -e "${GREEN}✓${NC}  $*"; }
warn()    { echo -e "${YELLOW}⚠${NC}  $*"; }
error()   { echo -e "${RED}✗${NC}  $*" >&2; }

# Print usage
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Reverses everything install.sh puts on a machine, leaving files the
user owns (or has modified) untouched.

Options:
    -c, --config-dir DIR    Niri config directory to clean (default: ~/.config/niri)
    -n, --dry-run           Show what would be removed without making changes
    -f, --force             Also remove files that diverged from the repo's shipped copy
    -y, --yes               Do not prompt for confirmation
        --no-restore        Do not restore a config.toml backup created by install.sh
    -h, --help              Show this help message

Examples:
    $(basename "$0")                      # Uninstall with confirmation prompt
    $(basename "$0") --dry-run            # Preview what would be removed
    $(basename "$0") -y                   # Uninstall without prompting
    $(basename "$0") -f                   # Also remove locally-modified files

EOF
    exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--config-dir)
            NIRI_CONFIG_DIR="$2"
            shift 2
            ;;
        -n|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -y|--yes)
            ASSUME_YES=true
            shift
            ;;
        --no-restore)
            NO_RESTORE=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            error "Unknown option: $1"
            usage
            ;;
    esac
done

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"

echo -e "${BLUE}"
cat << 'BANNER'
 _   _                 _
| \ | | __ _ _ __  ___| |_
|  \| |/ _` | '_ \/ __| __|
| |\  | (_| | |_) \__ \ |_
|_| \_|\__,_| .__/|___/\__|
            |_|            niri config
BANNER
echo -e "${NC}\n"

info "Noctarchy Uninstaller"
echo

if [[ "$DRY_RUN" == true ]]; then
    warn "Dry-run mode enabled - no changes will be made"
    echo
fi

DIVERGED=()

# Track whether a file was actually removed (or was already absent) so
# the config.toml backup restore step knows whether it is safe to act.
remove_single_file() {
    local installed="$1" source="$2" label="$3"

    if [[ ! -f "$installed" ]]; then
        return 0
    fi

    if [[ ! -f "$source" ]]; then
        warn "$label has no shipped copy to compare against, leaving in place: $installed"
        DIVERGED+=("$installed")
        return 0
    fi

    if cmp -s "$installed" "$source"; then
        if [[ "$DRY_RUN" == true ]]; then
            echo "   Would remove: $installed"
        else
            rm -f "$installed"
            success "Removed $label"
        fi
        return 0
    fi

    if [[ "$FORCE" == true ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            echo "   Would remove (diverged, --force): $installed"
        else
            rm -f "$installed"
            warn "Removed diverged $label (--force)"
        fi
    else
        warn "$label diverged from the repo's shipped copy, leaving in place: $installed"
        DIVERGED+=("$installed")
    fi
}

remove_dir_of_files() {
    local installed_dir="$1" source_dir="$2" label_prefix="$3"

    [[ -d "$source_dir" ]] || return 0

    local f name
    for f in "$source_dir"/*; do
        [[ -f "$f" ]] || continue
        name="$(basename "$f")"
        remove_single_file "$installed_dir/$name" "$f" "$label_prefix/$name"
    done
}

remove_theme_dir() {
    local name="$1"
    local src="$REPO_ROOT/themes/$name"
    local dst="$NIRI_CONFIG_DIR/themes/$name"

    [[ -d "$dst" ]] || return 0

    if diff -rq "$src" "$dst" >/dev/null 2>&1; then
        if [[ "$DRY_RUN" == true ]]; then
            echo "   Would remove: $dst"
        else
            rm -rf "$dst"
            success "Removed theme: $name"
        fi
        return 0
    fi

    if [[ "$FORCE" == true ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            echo "   Would remove (diverged, --force): $dst"
        else
            rm -rf "$dst"
            warn "Removed diverged theme dir (--force): $name"
        fi
    else
        warn "Theme '$name' diverged from the repo's shipped copy, leaving in place: $dst"
        DIVERGED+=("$dst")
    fi
}

is_generated_theme_toml() {
    local f="$1"
    [[ -f "$f" ]] || return 1
    local l1 l2
    IFS= read -r l1 < "$f" || true
    l2="$(sed -n '2p' "$f")"
    [[ "$l1" == "# Selected theme" && "$l2" =~ ^name\ =\ \"[A-Za-z0-9_.-]+\"$ ]]
}

remove_theme_toml() {
    local installed="$NOCTALIA_CONFIG_DIR/theme.toml"
    local source="$REPO_ROOT/config/noctalia/theme.toml"

    [[ -f "$installed" ]] || return 0

    if cmp -s "$installed" "$source" || is_generated_theme_toml "$installed"; then
        if [[ "$DRY_RUN" == true ]]; then
            echo "   Would remove: $installed"
        else
            rm -f "$installed"
            success "Removed theme.toml"
        fi
        return 0
    fi

    if [[ "$FORCE" == true ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            echo "   Would remove (diverged, --force): $installed"
        else
            rm -f "$installed"
            warn "Removed diverged theme.toml (--force)"
        fi
    else
        warn "theme.toml diverged from the repo's shipped copy, leaving in place: $installed"
        DIVERGED+=("$installed")
    fi
}

remove_fcitx5_service() {
    local installed="$SYSTEMD_USER_DIR/noctarchy-fcitx5.service"
    local source="$REPO_ROOT/config/fcitx5/systemd/noctarchy-fcitx5.service"

    [[ -f "$installed" ]] || return 0

    local do_remove=false diverged=false
    if cmp -s "$installed" "$source"; then
        do_remove=true
    elif [[ "$FORCE" == true ]]; then
        do_remove=true
        diverged=true
    fi

    if [[ "$do_remove" == false ]]; then
        warn "noctarchy-fcitx5.service diverged from the repo's shipped copy, leaving in place: $installed"
        DIVERGED+=("$installed")
        return 0
    fi

    if [[ "$DRY_RUN" == true ]]; then
        echo "   Would disable and stop: noctarchy-fcitx5.service"
        echo "   Would remove: $installed"
        echo "   Would run: systemctl --user daemon-reload"
        return 0
    fi

    if systemctl --user show-environment >/dev/null 2>&1; then
        if systemctl --user disable --now noctarchy-fcitx5.service >/dev/null 2>&1; then
            success "Disabled noctarchy-fcitx5.service"
        else
            warn "Could not disable noctarchy-fcitx5.service (it may not have been active)"
        fi
        rm -f "$installed"
        systemctl --user daemon-reload >/dev/null 2>&1 || true
    else
        warn "No reachable user systemd session - skipping service disable"
        rm -f "$installed"
    fi

    if [[ "$diverged" == true ]]; then
        warn "Removed diverged noctarchy-fcitx5.service unit (--force)"
    else
        success "Removed noctarchy-fcitx5.service unit"
    fi
}

rmdir_if_empty() {
    rmdir "$1" 2>/dev/null || true
}

# Confirmation prompt
if [[ "$DRY_RUN" == false && "$ASSUME_YES" == false ]]; then
    echo "This will remove Noctarchy-installed files from:"
    echo "  - $NIRI_CONFIG_DIR"
    echo "  - $NOCTALIA_CONFIG_DIR"
    echo "  - $WIREPLUMBER_CONFIG_DIR"
    echo "  - ${XDG_CONFIG_HOME:-$HOME/.config}/chromium-flags.conf"
    echo "  - fcitx5 config under ${XDG_CONFIG_HOME:-$HOME/.config}/fcitx5, environment.d, systemd/user, autostart"
    echo "  - $HOME/.XCompose"
    echo "Only files matching the repo's shipped copies are removed (use --force for diverged files)."
    echo
    read -r -p "Proceed? [y/N] " REPLY
    if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
        info "Aborted, no changes made"
        exit 0
    fi
    echo
fi

# Step 1: fcitx5 (disable service before removing its unit)
echo
echo "Removing fcitx5 input method config..."
XDG_CONFIG_HOME_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
FCITX5_CONFIG_DIR="$XDG_CONFIG_HOME_DIR/fcitx5/conf"
ENVIRONMENT_D_DIR="$XDG_CONFIG_HOME_DIR/environment.d"
SYSTEMD_USER_DIR="$XDG_CONFIG_HOME_DIR/systemd/user"
AUTOSTART_DIR="$XDG_CONFIG_HOME_DIR/autostart"

remove_fcitx5_service
remove_single_file "$FCITX5_CONFIG_DIR/xcb.conf" "$REPO_ROOT/config/fcitx5/conf/xcb.conf" "fcitx5/conf/xcb.conf"
remove_single_file "$FCITX5_CONFIG_DIR/clipboard.conf" "$REPO_ROOT/config/fcitx5/conf/clipboard.conf" "fcitx5/conf/clipboard.conf"
remove_single_file "$ENVIRONMENT_D_DIR/10-noctarchy-fcitx.conf" "$REPO_ROOT/config/fcitx5/environment.d/10-noctarchy-fcitx.conf" "environment.d/10-noctarchy-fcitx.conf"
remove_single_file "$AUTOSTART_DIR/org.fcitx.Fcitx5.desktop" "$REPO_ROOT/config/fcitx5/autostart/org.fcitx.Fcitx5.desktop" "autostart/org.fcitx.Fcitx5.desktop"
remove_single_file "$HOME/.XCompose" "$REPO_ROOT/config/fcitx5/xcompose" ".XCompose"

if [[ "$DRY_RUN" == false ]]; then
    rmdir_if_empty "$FCITX5_CONFIG_DIR"
    rmdir_if_empty "$(dirname "$FCITX5_CONFIG_DIR")"
    rmdir_if_empty "$ENVIRONMENT_D_DIR"
    rmdir_if_empty "$SYSTEMD_USER_DIR"
    rmdir_if_empty "$(dirname "$SYSTEMD_USER_DIR")"
    rmdir_if_empty "$AUTOSTART_DIR"
fi

# Step 2: utility scripts
echo
echo "Removing utility scripts..."
remove_dir_of_files "$NIRI_CONFIG_DIR/scripts" "$REPO_ROOT/scripts" "scripts"
[[ "$DRY_RUN" == false ]] && rmdir_if_empty "$NIRI_CONFIG_DIR/scripts"

# Step 3: Chromium Wayland flags
echo
echo "Removing Chromium Wayland flags..."
CHROMIUM_FLAGS_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/chromium-flags.conf"
remove_single_file "$CHROMIUM_FLAGS_FILE" "$REPO_ROOT/config/chromium-flags.conf" "chromium-flags.conf"

# Step 4: themes directory (reference copy)
echo
echo "Removing themes directory (reference copy)..."
if [[ -d "$REPO_ROOT/themes" ]]; then
    for theme_dir in "$REPO_ROOT/themes"/*/; do
        [[ -d "$theme_dir" ]] || continue
        remove_theme_dir "$(basename "$theme_dir")"
    done
fi
[[ "$DRY_RUN" == false ]] && rmdir_if_empty "$NIRI_CONFIG_DIR/themes"

# Step 5: bin scripts
echo
echo "Removing bin scripts..."
remove_dir_of_files "$NIRI_CONFIG_DIR/bin" "$REPO_ROOT/bin" "bin"
[[ "$DRY_RUN" == false ]] && rmdir_if_empty "$NIRI_CONFIG_DIR/bin"

# Step 6: wireplumber config
echo
echo "Removing wireplumber configuration..."
remove_dir_of_files "$WIREPLUMBER_CONFIG_DIR/wireplumber.conf.d" "$REPO_ROOT/config/wireplumber/wireplumber.conf.d" "wireplumber.conf.d"
if [[ "$DRY_RUN" == false ]]; then
    rmdir_if_empty "$WIREPLUMBER_CONFIG_DIR/wireplumber.conf.d"
    rmdir_if_empty "$WIREPLUMBER_CONFIG_DIR"
fi

# Step 7: themed configs
echo
echo "Removing theme configurations..."
remove_dir_of_files "$NOCTALIA_CONFIG_DIR/themed" "$REPO_ROOT/config/noctalia/themed" "themed"
[[ "$DRY_RUN" == false ]] && rmdir_if_empty "$NOCTALIA_CONFIG_DIR/themed"

# Step 8: theme.toml and config.toml
echo
echo "Removing Noctalia config files..."
remove_theme_toml
remove_single_file "$NOCTALIA_CONFIG_DIR/config.toml" "$REPO_ROOT/config/noctalia/config.toml" "config.toml"

# Step 9: restore config.toml backup
if [[ "$NO_RESTORE" == false ]]; then
    echo
    echo "Checking for config.toml backup..."
    LATEST_BACKUP=""
    for f in "$NOCTALIA_CONFIG_DIR"/config.toml.backup.*; do
        [[ -f "$f" ]] || continue
        if [[ -z "$LATEST_BACKUP" || "$f" -nt "$LATEST_BACKUP" ]]; then
            LATEST_BACKUP="$f"
        fi
    done

    if [[ -n "$LATEST_BACKUP" ]]; then
        if [[ -f "$NOCTALIA_CONFIG_DIR/config.toml" ]]; then
            warn "Backup found ($LATEST_BACKUP) but config.toml is still present, skipping restore"
        else
            if [[ "$DRY_RUN" == true ]]; then
                echo "   Would restore backup: $LATEST_BACKUP -> $NOCTALIA_CONFIG_DIR/config.toml"
            else
                mv "$LATEST_BACKUP" "$NOCTALIA_CONFIG_DIR/config.toml"
                success "Restored backup: $LATEST_BACKUP"
            fi
        fi
    else
        info "No config.toml backup found"
    fi
fi

[[ "$DRY_RUN" == false ]] && rmdir_if_empty "$NOCTALIA_CONFIG_DIR"
[[ "$DRY_RUN" == false ]] && rmdir_if_empty "$NIRI_CONFIG_DIR"

# Final summary
echo
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
if [[ "$DRY_RUN" == true ]]; then
    success "Dry run complete - no changes were made"
else
    success "Uninstall complete!"
fi
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

if [[ ${#DIVERGED[@]} -gt 0 ]]; then
    warn "The following files diverged from the repo's shipped copies and were left in place:"
    for f in "${DIVERGED[@]}"; do
        echo "  - $f"
    done
    echo "Re-run with --force to remove them anyway."
    echo
fi

echo "Noctarchy does not uninstall packages. If no longer needed, remove manually:"
echo "  - niri"
echo "  - noctalia"
echo "  - fcitx5"
echo "  - gpu-screen-recorder"
echo "  - ffmpeg"
echo
