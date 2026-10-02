# ==============================================================================
# Oh My Zsh & Plugins Setup
# ==============================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
ZSH_CUSTOM="$ZSH/custom"

# Install Oh-My-Zsh if it doesn't exist
if [ ! -d "$ZSH" ]; then
  echo "Installing Oh-My-Zsh..."
  git clone https://github.com/ohmyzsh/ohmyzsh.git "$ZSH" >/dev/null 2>&1
fi

# Auto-fetch necessary plugins if they don't exist
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" >/dev/null 2>&1
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" >/dev/null 2>&1
fi

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# ==============================================================================
# History Configuration
# ==============================================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_ALL_DUPS
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# ==============================================================================
# Custom Functions
# ==============================================================================

# Automatically list directory contents upon changing directories
cd() {
  builtin cd "$@" && ls
}

# ==============================================================================
# Execute on Startup
# ==============================================================================
fastfetch
_matugen_color() { awk -v key="$1" '$1 == key { print $2; exit }' ~/.config/kitty/matugen-colors.conf 2>/dev/null }

kotofetch --width 80 --border false --centered true \
  --quote-color "$(_matugen_color color4)" \
  --translation-color "$(_matugen_color color7)" \
  --animation slide 