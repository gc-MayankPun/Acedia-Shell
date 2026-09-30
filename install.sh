#!/usr/bin/env bash

set -euo pipefail

# Always run paths relative to this script/repository
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

CONFIG_DIR="$HOME/.config"
BACKUP_DATE="$(date '+%Y%m%d_%H%M%S')"

HYPR_SOURCE="$SCRIPT_DIR/hypr"
QUICKSHELL_SOURCE="$SCRIPT_DIR/quickshell"
MATUGEN_SOURCE="$SCRIPT_DIR/matugen/config.toml"
ROFI_THEME_SOURCE="$SCRIPT_DIR/matugen/theme/Acedia.rasi"

HYPR_CONFIG="$CONFIG_DIR/hypr"
QUICKSHELL_CONFIG="$CONFIG_DIR/quickshell"
MATUGEN_CONFIG="$CONFIG_DIR/matugen"

echo "Creating Acedia directories..."

mkdir -p \
    "$HOME/Pictures/Wallpapers" \
    "$HOME/Pictures/Screenshots" \
    "$HOME/.local/share/rofi/themes" \
    "$CONFIG_DIR/matugen"

echo "Directories ready."

echo "======================================"
echo "      Applying Acedia-Shell config"
echo "======================================"
echo

# --------------------------------------
# Hyprland
# --------------------------------------

echo "Creating backup for Hyprland..."

if [[ -d "$HYPR_CONFIG" ]]; then
    mv "$HYPR_CONFIG" "${HYPR_CONFIG}_bak_${BACKUP_DATE}"
    echo "Backup created:"
    echo "  ${HYPR_CONFIG}_bak_${BACKUP_DATE}"
else
    echo "No existing Hyprland config found."
fi

echo "Applying Acedia Hyprland files..."

cp -a "$HYPR_SOURCE" "$CONFIG_DIR/"

echo "Hyprland configuration applied."
echo

# --------------------------------------
# QuickShell
# --------------------------------------

if [[ -d "$QUICKSHELL_CONFIG" ]]; then
    echo "Creating backup for QuickShell..."

    mv "$QUICKSHELL_CONFIG" \
       "${QUICKSHELL_CONFIG}_bak_${BACKUP_DATE}"

    echo "Backup created:"
    echo "  ${QUICKSHELL_CONFIG}_bak_${BACKUP_DATE}"
else
    echo "No existing QuickShell config found."
fi

echo "Applying Acedia QuickShell files..."

cp -a "$QUICKSHELL_SOURCE" "$CONFIG_DIR/"

echo "QuickShell configuration applied."
echo

# --------------------------------------
# Rofi theme
# --------------------------------------

echo "Applying Acedia theme to Rofi..."

install -Dm644 \
    "$ROFI_THEME_SOURCE" \
    "$HOME/.local/share/rofi/themes/Acedia.rasi"

echo "Rofi theme applied."
echo

# --------------------------------------
# Matugen
# --------------------------------------

echo "Applying Matugen configuration..."

mkdir -p "$MATUGEN_CONFIG"

cp -f \
    "$MATUGEN_SOURCE" \
    "$MATUGEN_CONFIG/config.toml"

echo "Matugen configuration applied."
echo

# --------------------------------------
# Done
# --------------------------------------

echo "======================================"
echo "       Acedia-Shell applied!"
echo "======================================"