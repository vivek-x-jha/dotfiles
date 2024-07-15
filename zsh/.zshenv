# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Editor Configuration
export EDITOR='nvim'
export VISUAL="$EDITOR"

# History Configuration
export LESSHISTFILE="$XDG_CACHE_HOME/less/.lesshst"

# Zsh Configuration
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export _ZL_DATA="$XDG_CACHE_HOME/zlua/.zlua"
