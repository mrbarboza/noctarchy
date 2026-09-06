#!/bin/bash
# Sync themes from Omarchy to Noctarchy
# Zero DHH/HEY content - themes are color schemes only

set -e

OMARCHY_REPO="https://github.com/omacom/omarchy"
THEMES_DIR="themes"

echo "==================================="
echo "Syncing themes from Omarchy"
echo "==================================="
echo ""

# Check if we're in the noctarchy repo
if [ ! -f "README.md" ] || [ ! -d "$THEMES_DIR" ]; then
    echo "Error: Run this from the root of the noctarchy repo"
    exit 1
fi

# Create temp dir
TEMP_DIR=$(mktemp -d)
echo "Cloning Omarchy to $TEMP_DIR..."
git clone --depth 1 --filter=blob:none --sparse $OMARCHY_REPO $TEMP_DIR 2>/dev/null

cd $TEMP_DIR
git sparse-checkout set themes
cd - > /dev/null

# Count themes
THEME_COUNT=$(ls -d $TEMP_DIR/themes/*/ 2>/dev/null | wc -l)
echo "Found $THEME_COUNT themes in Omarchy"
echo ""

# Copy each theme
for theme in $TEMP_DIR/themes/*/; do
    theme_name=$(basename "$theme")
    echo "Copying theme: $theme_name"
    
    # Create theme dir if not exists
    mkdir -p "$THEMES_DIR/$theme_name"
    
    # Copy theme files (exclude large images if desired)
    cp -r "$theme"* "$THEMES_DIR/$theme_name/"
    
    echo "  ✓ $theme_name synced"
done

# Cleanup
rm -rf $TEMP_DIR

echo ""
echo "==================================="
echo "Sync complete!"
echo "==================================="
echo ""
echo "Themes synced: $THEME_COUNT"
echo ""
echo "To see changes:"
echo "  git status"
echo ""
echo "To commit:"
echo "  git add themes/"
echo "  git commit -m 'Sync themes from Omarchy'"
echo ""
