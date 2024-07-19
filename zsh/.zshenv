# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Dotfiles
export DOT="$HOME/dotfiles"

# Zsh Configuration
export ZDOTDIR="$DOT/zsh"

# Editor Configuration
export EDITOR='nvim'
export VISUAL="$EDITOR"

# History Configuration
export LESSHISTFILE="$XDG_CACHE_HOME/less/.lesshst"

# Z.lua Directory Frecency Database
export _ZL_DATA="$XDG_CACHE_HOME/zlua/.zlua"
