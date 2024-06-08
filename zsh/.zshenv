# ·····························································
# Author: Vivek Jha
# Last Modified: Jun 8, 2024
# ·····························································

# export EDITOR="vim"

export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_STATE_HOME=${XDG_STATE_HOME:="$HOME/.local/state"}

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

export PAGER=less
export LESSHISTFILE=$XDG_CACHE_HOME/less/.lesshst

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export _ZL_DATA="$XDG_CACHE_HOME/zlua/.zlua"

