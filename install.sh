#!/usr/bin/env bash
#
# Acedia-Shell installer
# Installs: Hyprland, Hyprlock, QuickShell, Kitty, Fastfetch, Matugen, Rofi theme, Zsh
# Matugen themes: QuickShell, Rofi and Kitty (no Zsh color template).

set -euo pipefail

# ==============================================================================
# Paths
# ==============================================================================

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP_DATE="$(date '+%Y%m%d_%H%M%S')"

HYPR_SRC="$SCRIPT_DIR/hypr"
HYPRLOCK_SRC="$SCRIPT_DIR/hyprlock"
QUICKSHELL_SRC="$SCRIPT_DIR/quickshell"
KITTY_SRC="$SCRIPT_DIR/kitty"
FASTFETCH_SRC="$SCRIPT_DIR/fastfetch"
MATUGEN_SRC="$SCRIPT_DIR/matugen"
ZSH_SRC="$SCRIPT_DIR/.zshrc"

HYPR_DST="$CONFIG_DIR/hypr"
HYPRLOCK_DST="$CONFIG_DIR/hyprlock"
QUICKSHELL_DST="$CONFIG_DIR/quickshell"
KITTY_DST="$CONFIG_DIR/kitty"
FASTFETCH_DST="$CONFIG_DIR/fastfetch"
MATUGEN_DST="$CONFIG_DIR/matugen"
ZSH_DST="$HOME/.zshrc"

ROFI_THEME_DST="$HOME/.local/share/rofi/themes"
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
DEFAULT_WALLPAPER="$QUICKSHELL_SRC/assets/images/default-wallpaper.webp"


# ==============================================================================
# Helpers
# ==============================================================================

step() { printf '\n==> %s\n' "$1"; }
info() { printf '    %s\n' "$1"; }
warn() { printf '    [!] %s\n' "$1" >&2; }
die()  { printf 'Error: %s\n' "$1" >&2; exit 1; }

# Move an existing file/dir/symlink out of the way.
backup() {
    local target="$1"
    if [[ -e "$target" || -L "$target" ]]; then
        local dest="${target}_bak_${BACKUP_DATE}"
        mv "$target" "$dest"
        info "Backup: $dest"
    fi
}

# Replace a whole directory (backs up the old one).
install_dir() {
    local src="$1" dst="$2"
    [[ -d "$src" ]] || die "Missing source directory: $src"
    backup "$dst"
    mkdir -p "$(dirname "$dst")"
    cp -a "$src" "$dst"
}

# Install a single file (backs up the old one).
install_file() {
    local src="$1" dst="$2" mode="${3:-644}"
    [[ -f "$src" ]] || die "Missing source file: $src"
    backup "$dst"
    install -Dm"$mode" "$src" "$dst"
}

have() { command -v "$1" >/dev/null 2>&1; }


# ==============================================================================
# Sanity checks
# ==============================================================================

[[ $EUID -ne 0 ]] || die "Do not run this installer as root."

for path in "$HYPR_SRC" "$HYPRLOCK_SRC" "$QUICKSHELL_SRC" "$KITTY_SRC" \
            "$FASTFETCH_SRC" "$MATUGEN_SRC" "$ZSH_SRC"; do
    [[ -e "$path" ]] || die "Run this script from the dotfiles repo (missing: $path)"
done

step "Checking dependencies"

missing_required=()
for cmd in git zsh kitty matugen quickshell hyprland; do
    have "$cmd" || missing_required+=("$cmd")
done

missing_optional=()
for cmd in hyprlock fastfetch kotofetch rofi awww-daemon cliphist wl-paste \
           playerctl brightnessctl wpctl notify-send; do
    have "$cmd" || missing_optional+=("$cmd")
done

if ((${#missing_required[@]})); then
    warn "Missing required: ${missing_required[*]}"
fi
if ((${#missing_optional[@]})); then
    warn "Missing optional: ${missing_optional[*]}"
fi
if ((${#missing_required[@]} == 0 && ${#missing_optional[@]} == 0)); then
    info "All dependencies found."
fi

fc-list 2>/dev/null | grep -qi "JetBrainsMono.*Nerd\|JetBrainsMono Nerd" \
    || warn "JetBrainsMono Nerd Font not found (kitty/fastfetch icons may not render)."


# ==============================================================================
# Directories
# ==============================================================================

step "Creating directories"

mkdir -p \
    "$WALLPAPER_DIR" \
    "$HOME/Pictures/Screenshots" \
    "$ROFI_THEME_DST" \
    "$CONFIG_DIR" \
    "$MATUGEN_DST/templates"

info "Done."


# ==============================================================================
# Hyprland / Hyprlock
# ==============================================================================

step "Hyprland"
install_dir "$HYPR_SRC" "$HYPR_DST"

step "Hyprlock"
install_dir "$HYPRLOCK_SRC" "$HYPRLOCK_DST"


# ==============================================================================
# QuickShell
# ==============================================================================

step "QuickShell"
install_dir "$QUICKSHELL_SRC" "$QUICKSHELL_DST"
find "$QUICKSHELL_DST/scripts" -type f -name '*.sh' -exec chmod +x {} +
info "Scripts marked executable."


# ==============================================================================
# Kitty
# ==============================================================================

step "Kitty"
mkdir -p "$KITTY_DST"
install_file "$KITTY_SRC/kitty.conf" "$KITTY_DST/kitty.conf"

# kitty.conf includes this file. Matugen overwrites it on every wallpaper change.
if [[ ! -f "$KITTY_DST/matugen-colors.conf" ]]; then
    : > "$KITTY_DST/matugen-colors.conf"
    info "Created empty matugen-colors.conf (filled on first color generation)."
fi


# ==============================================================================
# Fastfetch
# ==============================================================================

step "Fastfetch"
install_dir "$FASTFETCH_SRC" "$FASTFETCH_DST"
chmod +x "$FASTFETCH_DST/random_logo.sh"
info "random_logo.sh marked executable."


# ==============================================================================
# Matugen (config + templates) and Rofi theme
# ==============================================================================

step "Matugen"
install_file "$MATUGEN_SRC/config.toml" "$MATUGEN_DST/config.toml"

# Only the Kitty template lives here. The Rofi template ships inside
# quickshell/templates and is referenced from there by config.toml.
install_file "$MATUGEN_SRC/templates/kitty-colors.conf" \
             "$MATUGEN_DST/templates/kitty-colors.conf"

step "Rofi theme"
install_file "$MATUGEN_SRC/theme/Acedia.rasi" "$ROFI_THEME_DST/Acedia.rasi"


# ==============================================================================
# Zsh
# ==============================================================================

step "Zsh"
install_file "$ZSH_SRC" "$ZSH_DST"

if [[ "${SHELL:-}" != *zsh ]] && have zsh; then
    info "Your login shell is not zsh. Run: chsh -s \"$(command -v zsh)\""
fi


# ==============================================================================
# Initial color generation
# ==============================================================================

step "Generating colors"

wallpaper=""
if [[ -d "$WALLPAPER_DIR" ]]; then
    wallpaper="$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \
           -o -iname '*.webp' -o -iname '*.bmp' \) | sort | head -n 1)"
fi
[[ -n "$wallpaper" ]] || wallpaper="$DEFAULT_WALLPAPER"

if ! have matugen; then
    warn "matugen not installed, skipping. Install it, then run:"
    warn "  $QUICKSHELL_DST/scripts/generate_colors.sh <wallpaper>"
elif [[ ! -f "$wallpaper" ]]; then
    warn "No wallpaper found, skipping color generation."
elif "$QUICKSHELL_DST/scripts/generate_colors.sh" "$wallpaper"; then
    info "Colors generated from: $wallpaper"
else
    warn "Color generation failed. Check [config.custom_colors] in $MATUGEN_DST/config.toml"
    warn "and your matugen version (matugen --version)."
fi


# ==============================================================================
# Done
# ==============================================================================

printf '\n======================================\n'
printf '       Acedia-Shell applied!\n'
printf '======================================\n'
info "Open a new kitty window. Reload colors with ctrl+shift+f5."