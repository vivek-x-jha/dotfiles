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

if [[ ${+commands[tput]} -eq 0 ]]; then
    echo "WARNING: tput command not found in PATH.\n"
else
    export NONE=$(tput sgr0)
    export BOLD=$(tput bold)
    export BLACK=$(tput setaf 0)
    export RED=$(tput setaf 1)
    export GREEN=$(tput setaf 2)
    export YELLOW=$(tput setaf 3)
    export BLUE=$(tput setaf 4)
    export MAGENTA=$(tput setaf 5)
    export CYAN=$(tput setaf 6)
    export WHITE=$(tput setaf 7)
    export BLACK_BRIGHT=$(tput setaf 8)
    export RED_BRIGHT=$(tput setaf 9)
    export GREEN_BRIGHT=$(tput setaf 10)
    export YELLOW_BRIGHT=$(tput setaf 11)
    export BLUE_BRIGHT=$(tput setaf 12)
    export MAGENTA_BRIGHT=$(tput setaf 13)
    export CYAN_BRIGHT=$(tput setaf 14)
    export WHITE_BRIGHT=$(tput setaf 15)
    export PINK=$(tput setaf 225)
fi

declare -Ag COLORS_HEX=(
    BLACK "#000000"
    RED "#FF96A3"
    GREEN "#BEF9BE"
    YELLOW "#FDF9BB"
    BLUE "#40C4FE"
    MAGENTA "#FF87FF"
    CYAN "#64FCDA"
    WHITE "#F4F3F2"
    BLACK_BRIGHT "#B2B2B2"
    RED_BRIGHT "#80D7FE"
    GREEN_BRIGHT "#A7FDEB"
    YELLOW_BRIGHT "#B9F6C9"
    BLUE_BRIGHT "#FF80AB"
    MAGENTA_BRIGHT "#FF96A3"
    CYAN_BRIGHT "#F4F3F2"
    WHITE_BRIGHT "#FFE47E"
    PINK "#F2CDF3"
    GREY_BACKGROUND "#282C34"
    GREY_POPOUTMENU "#21252B"
    GREY_SECTIONHEAD "#9DA5B3"
    GREY_COMMENT "#676E95"
    GREY_DIRCOLORSNORMAL "#B6B6CE"
    GREY_SELF "#C6CFF0"
    INACTIVE "#5C617D"
)
