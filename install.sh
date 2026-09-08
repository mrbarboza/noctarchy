#!/usr/bin/env bash
#
# Noctarchy Installer
# Installs the Noctarchy niri configuration
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
THEME="tokyo-night"
DRY_RUN=false
FORCE=false

# Print colored output
info()    { echo -e "${BLUE}ℹ${NC}  $*"; }
success() { echo -e "${GREEN}✓${NC}  $*"; }
warn()    { echo -e "${YELLOW}⚠${NC}  $*"; }
error()   { echo -e "${RED}✗${NC}  $*" >&2; }

# Print usage
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Installs the Noctarchy niri configuration.

Options:
    -c, --config-dir DIR    Target niri config directory (default: ~/.config/niri)
    -t, --theme NAME        Initial theme to apply (default: tokyo-night)
    -n, --dry-run           Show what would be done without making changes
    -f, --force             Overwrite existing config files
    -h, --help              Show this help message

Examples:
    $(basename "$0")                      # Install with defaults
    $(basename "$0") -t gruvbox           # Install with gruvbox theme
    $(basename "$0") -c ~/.config/niri    # Install to specific directory
    $(basename "$0") --dry-run            # Preview installation

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
        -t|--theme)
            THEME="$2"
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

info "Noctarchy Installer"
echo

# Validate theme
if [[ ! -d "$REPO_ROOT/themes/$THEME" ]]; then
    error "Theme '$THEME' not found in themes/"
    echo "Available themes:"
    ls -1 "$REPO_ROOT/themes" | sed 's/^/  - /'
    exit 1
fi

# Check if running in dry-run mode
if [[ "$DRY_RUN" == true ]]; then
    warn "Dry-run mode enabled - no changes will be made"
    echo
fi

# Step 1: Check for niri
info "Checking for niri..."
if ! command -v niri &> /dev/null; then
    warn "niri not found in PATH"
    echo "   Make sure niri is installed before starting the compositor"
    echo
fi

# Step 2: Create config directory
info "Config directory: $NIRI_CONFIG_DIR"
if [[ ! -d "$NIRI_CONFIG_DIR" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
        echo "   Would create: $NIRI_CONFIG_DIR"
    else
        mkdir -p "$NIRI_CONFIG_DIR"
        success "Created config directory"
    fi
else
    success "Config directory exists"
fi

# Step 3: Backup existing config (if any)
if [[ -f "$NOCTALIA_CONFIG_DIR/config.toml" ]]; then
    if [[ "$FORCE" == true ]]; then
        warn "Existing config.toml will be overwritten (--force)"
    else
        if [[ "$DRY_RUN" == true ]]; then
            echo "   Would backup: $NOCTALIA_CONFIG_DIR/config.toml"
        else
            BACKUP_FILE="$NOCTALIA_CONFIG_DIR/config.toml.backup.$(date +%Y%m%d%H%M%S)"
            cp "$NOCTALIA_CONFIG_DIR/config.toml" "$BACKUP_FILE"
            success "Backed up existing config to: $BACKUP_FILE"
        fi
    fi
fi

# Step 4: Copy config files
echo
echo "Copying configuration files..."

if [[ "$DRY_RUN" == true ]]; then
    echo "   Would create: $NOCTALIA_CONFIG_DIR"
else
    mkdir -p "$NOCTALIA_CONFIG_DIR"
fi

# Copy main config
if [[ "$DRY_RUN" == true ]]; then
    echo "   Would copy: config/noctalia/config.toml → $NOCTALIA_CONFIG_DIR/config.toml"
else
    if [[ "$FORCE" == true ]] || [[ ! -f "$NOCTALIA_CONFIG_DIR/config.toml" ]]; then
        cp "$REPO_ROOT/config/noctalia/config.toml" "$NOCTALIA_CONFIG_DIR/config.toml"
        success "Copied config.toml"
    else
        warn "config.toml already exists (use --force to overwrite)"
    fi
fi

# Copy theme config
if [[ "$DRY_RUN" == true ]]; then
    echo "   Would copy: config/noctalia/theme.toml → $NOCTALIA_CONFIG_DIR/theme.toml"
else
    if [[ "$FORCE" == true ]] || [[ ! -f "$NOCTALIA_CONFIG_DIR/theme.toml" ]]; then
        cp "$REPO_ROOT/config/noctalia/theme.toml" "$NOCTALIA_CONFIG_DIR/theme.toml"
        success "Copied theme.toml"
    else
        warn "theme.toml already exists (use --force to overwrite)"
    fi
fi

# Step 5: Copy themed configs
echo
echo "Copying theme configurations..."
if [[ "$DRY_RUN" == true ]]; then
    echo "   Would copy: config/noctalia/themed/* → $NOCTALIA_CONFIG_DIR/themed/"
else
    mkdir -p "$NOCTALIA_CONFIG_DIR/themed"
    cp "$REPO_ROOT/config/noctalia/themed/"*.toml "$NOCTALIA_CONFIG_DIR/themed/" 2>/dev/null || true
    success "Copied themed configs"
fi

# Step 6: Copy wireplumber config
echo
echo "Copying wireplumber configuration..."
if [[ "$DRY_RUN" == true ]]; then
    echo "   Would copy: config/wireplumber/wireplumber.conf.d/* → $WIREPLUMBER_CONFIG_DIR/wireplumber.conf.d/"
else
    mkdir -p "$WIREPLUMBER_CONFIG_DIR/wireplumber.conf.d"
    cp "$REPO_ROOT/config/wireplumber/wireplumber.conf.d/"*.conf "$WIREPLUMBER_CONFIG_DIR/wireplumber.conf.d/" 2>/dev/null || true
    success "Copied wireplumber config"
fi

# Step 7: Copy bin scripts
echo
echo "Installing bin scripts..."
if [[ "$DRY_RUN" == true ]]; then
    echo "   Would copy: bin/* → $NIRI_CONFIG_DIR/bin/"
else
    mkdir -p "$NIRI_CONFIG_DIR/bin"
    cp "$REPO_ROOT/bin/"* "$NIRI_CONFIG_DIR/bin/"
    chmod +x "$NIRI_CONFIG_DIR/bin/"*
    success "Installed bin scripts"
fi

# Step 8: Copy themes directory (optional, for reference)
echo
echo "Copying themes directory (optional reference)..."
if [[ "$DRY_RUN" == true ]]; then
    echo "   Would copy: themes/ → $NIRI_CONFIG_DIR/themes/"
else
    if [[ -d "$REPO_ROOT/themes" ]]; then
        mkdir -p "$NIRI_CONFIG_DIR/themes"
        cp -r "$REPO_ROOT/themes/"* "$NIRI_CONFIG_DIR/themes/"
        success "Copied themes directory"
    fi
fi

# Step 9: Apply initial theme
echo
echo "Applying initial theme: $THEME"
if [[ "$DRY_RUN" == true ]]; then
    echo "   Would run: $NIRI_CONFIG_DIR/bin/theme-select $THEME"
else
    if [[ -x "$NIRI_CONFIG_DIR/bin/theme-select" ]]; then
        "$NIRI_CONFIG_DIR/bin/theme-select" "$THEME"
        success "Applied theme: $THEME"
    else
        warn "theme-select not executable, skipping theme application"
    fi
fi

# Step 10: Copy scripts directory
echo
echo "Copying utility scripts..."
if [[ "$DRY_RUN" == true ]]; then
    echo "   Would copy: scripts/ → $NIRI_CONFIG_DIR/scripts/"
else
    if [[ -d "$REPO_ROOT/scripts" ]]; then
        mkdir -p "$NIRI_CONFIG_DIR/scripts"
        cp "$REPO_ROOT/scripts/"* "$NIRI_CONFIG_DIR/scripts/" 2>/dev/null || true
        chmod +x "$NIRI_CONFIG_DIR/scripts/"* 2>/dev/null || true
        success "Copied utility scripts"
    fi
fi

# Final summary
echo
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
success "Installation complete!"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo "Niri config directory:     $NIRI_CONFIG_DIR"
echo "Noctalia config directory: $NOCTALIA_CONFIG_DIR"
echo "Active theme:              $THEME"
echo
echo "Next steps:"
echo "  1. Start niri: niri"
echo "  2. Switch themes: $NIRI_CONFIG_DIR/bin/theme-select <theme>"
echo "  3. List themes:   ls $NIRI_CONFIG_DIR/themes"
echo
echo "Enjoy Noctarchy! 🌙"
