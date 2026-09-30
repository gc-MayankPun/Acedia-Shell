#!/usr/bin/env bash

set -euo pipefail

# ==============================================================================
# Acedia-Shell Installer
# ==============================================================================

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

CONFIG_DIR="$HOME/.config"
BACKUP_DATE="$(date '+%Y%m%d_%H%M%S')"


# ==============================================================================
# Sources
# ==============================================================================

HYPR_SOURCE="$SCRIPT_DIR/hypr"
QUICKSHELL_SOURCE="$SCRIPT_DIR/quickshell"
MATUGEN_SOURCE="$SCRIPT_DIR/matugen/config.toml"
ROFI_THEME_SOURCE="$SCRIPT_DIR/matugen/theme/Acedia.rasi"
ZSH_SOURCE="$SCRIPT_DIR/.zshrc"


# ==============================================================================
# Destinations
# ==============================================================================

HYPR_CONFIG="$CONFIG_DIR/hypr"
QUICKSHELL_CONFIG="$CONFIG_DIR/quickshell"
MATUGEN_CONFIG="$CONFIG_DIR/matugen"
ZSH_CONFIG="$HOME/.zshrc"


# ==============================================================================
# Helpers
# ==============================================================================

backup_config() {
    local target="$1"

    if [[ -e "$target" || -L "$target" ]]; then
        local backup="${target}_bak_${BACKUP_DATE}"

        mv "$target" "$backup"

        echo "Backup created:"
        echo "  $backup"
    fi
}


# ==============================================================================
# Directories
# ==============================================================================

echo "Creating Acedia directories..."

mkdir -p \
    "$HOME/Pictures/Wallpapers" \
    "$HOME/Pictures/Screenshots" \
    "$HOME/.local/share/rofi/themes" \
    "$MATUGEN_CONFIG"

echo "Directories ready."
echo


# ==============================================================================
# Header
# ==============================================================================

echo "======================================"
echo "      Applying Acedia-Shell config"
echo "======================================"
echo


# ==============================================================================
# Hyprland
# ==============================================================================

echo "Applying Hyprland configuration..."

if [[ -d "$HYPR_CONFIG" ]]; then
    backup_config "$HYPR_CONFIG"
fi

cp -a "$HYPR_SOURCE" "$CONFIG_DIR/"

echo "Hyprland configuration applied."
echo


# ==============================================================================
# QuickShell
# ==============================================================================

echo "Applying QuickShell configuration..."

if [[ -d "$QUICKSHELL_CONFIG" ]]; then
    backup_config "$QUICKSHELL_CONFIG"
fi

cp -a "$QUICKSHELL_SOURCE" "$CONFIG_DIR/"

echo "QuickShell configuration applied."
echo


# ==============================================================================
# Rofi
# ==============================================================================

echo "Applying Acedia Rofi theme..."

install -Dm644 \
    "$ROFI_THEME_SOURCE" \
    "$HOME/.local/share/rofi/themes/Acedia.rasi"

echo "Rofi theme applied."
echo


# ==============================================================================
# Matugen
# ==============================================================================

echo "Applying Matugen configuration..."

cp -f \
    "$MATUGEN_SOURCE" \
    "$MATUGEN_CONFIG/config.toml"

echo "Matugen configuration applied."
echo


# ==============================================================================
# Zsh
# ==============================================================================

echo "Applying Zsh configuration..."

if [[ -f "$ZSH_CONFIG" ]]; then
    backup_config "$ZSH_CONFIG"
fi

install -Dm644 \
    "$ZSH_SOURCE" \
    "$ZSH_CONFIG"

echo "Zsh configuration applied."
echo


# ==============================================================================
# Done
# ==============================================================================

echo "======================================"
echo "       Acedia-Shell applied!"
echo "======================================"