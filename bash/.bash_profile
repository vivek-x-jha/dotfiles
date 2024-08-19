# Create System Variables
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Editor Configuration
export EDITOR='nvim'
export VISUAL="$EDITOR"

# Dotfiles
export DOT="$HOME/.dotfiles"

[ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"
