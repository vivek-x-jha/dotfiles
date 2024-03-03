# Create System Variables
export EDITOR="code"

export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_STATE_HOME=${XDG_STATE_HOME:="$HOME/.local/state"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}

export LESSHISTFILE=$XDG_CACHE_HOME/less/.lesshst

# Create ZSH Variables
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export _ZL_DATA="$XDG_CACHE_HOME/zlua/.zlua"

# Create Color Codes
export RED="FF96A3"
export GREEN="BEF9BE"
export BLUE="80D7FE"
export YELLOW="FDF9BB"
export PINK="F2CDF3"
export GREY_BACKGROUND="282C34"
export GREY_POPOUTMENU="21252B"
export GREY_SECTIONHEAD="9DA5B3"
export GREY_COMMENT="676E95"
export GREY_DIRCOLORSNORMAL="B6B6CE"
export GREY_SELF="C6CFF0"
export INACTIVE="5C617D"
