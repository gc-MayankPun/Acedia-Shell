# ==============================================================================
# Oh My Zsh
# ==============================================================================

export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"

ZSH_THEME=""

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
fi


# ==============================================================================
# Matugen
# ==============================================================================

export ACEDIA_CACHE="$HOME/.cache/acedia"
export ACEDIA_COLORS="$ACEDIA_CACHE/matugen-colors.zsh"

if [[ -r "$ACEDIA_COLORS" ]]; then
    source "$ACEDIA_COLORS"
fi


# ==============================================================================
# History
# ==============================================================================

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_ALL_DUPS
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY


# ==============================================================================
# Shell Behaviour
# ==============================================================================

cd() {
    builtin cd "$@" && ls
}


# ==============================================================================
# Prompt
# ==============================================================================

if [[ -n "$ACEDIA_COLOR_PRIMARY" ]]; then

    PROMPT='%F{$ACEDIA_COLOR_PRIMARY}╭─%f %F{$ACEDIA_COLOR_TEXT}%~%f
%F{$ACEDIA_COLOR_PRIMARY}╰─❯%f '

else

    PROMPT='%F{cyan}╭─%f %~%f
%F{cyan}╰─❯%f '

fi

# ==============================================================================
# Startup
# ==============================================================================
# fastfetch
kotofetch \
    --width 80 \
    --centered true \
    --quote-color "$ACEDIA_COLOR_PRIMARY" \
    --translation-color "$ACEDIA_COLOR_TEXT"