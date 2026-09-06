#!/bin/bash
# Noctarchy — Install script (Arch Linux)
# Zero DHH/37signals/HEY references

set -e

echo "==================================="
echo "Noctarchy — Niri + Noctalia Setup"
echo "==================================="
echo ""

# Check if running on Arch
if [ ! -f /etc/arch-release ]; then
    echo "Warning: This script is for Arch Linux."
    echo "On other distros, install niri + noctalia manually."
    read -p "Continue? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Install dependencies
echo "Installing niri + noctalia..."
if command -v yay &> /dev/null; then
    yay -S --noconfirm niri-git noctalia-git
elif command -v paru &> /dev/null; then
    paru -S --noconfirm niri-git noctalia-git
else
    echo "Error: Install yay or paru first (AUR helper)"
    exit 1
fi

# Backup existing configs
echo ""
echo "Backing up existing configs..."
[ -d ~/.config/niri ] && mv ~/.config/niri ~/.config/niri.backup.$(date +%Y%m%d)
[ -d ~/.config/noctalia ] && mv ~/.config/noctalia ~/.config/noctalia.backup.$(date +%Y%m%d)

# Copy configs
echo ""
echo "Copying Noctarchy configs..."
mkdir -p ~/.config/niri ~/.config/noctalia

cp config/niri/config.kdl ~/.config/niri/config.kdl
cp config/noctalia/config.toml ~/.config/noctalia/config.toml

# Optional: copy kitty, tmux, lazygit if they don't exist
[ ! -d ~/.config/kitty ] && cp -r config/kitty ~/.config/kitty 2>/dev/null || true
[ ! -d ~/.config/tmux ] && cp -r config/tmux ~/.config/tmux 2>/dev/null || true
[ ! -d ~/.config/lazygit ] && cp -r config/lazygit ~/.config/lazygit 2>/dev/null || true

echo ""
echo "==================================="
echo "Installation complete!"
echo "==================================="
echo ""
echo "To start Noctarchy:"
echo "  1. Logout of your current session"
echo "  2. From TTY, run: niri"
echo "  3. Or add to your display manager (greetd, ly, etc.)"
echo ""
echo "Keybindings:"
echo "  Super+Return    — Terminal (kitty)"
echo "  Super+Space     — Launcher / Overview"
echo "  Super+H/J/K/L   — Navigate windows"
echo "  Super+Shift+Q   — Close window"
echo "  Super+1-9       — Switch workspace"
echo "  Super+Shift+E   — Firefox (no HEY!)"
echo "  Super+Shift+C   — Btop (no HEY Calendar!)"
echo ""
echo "Enjoy your DHH-free desktop!"
