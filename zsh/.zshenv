# Create System Variables
# export EDITOR="vim"

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
    export BRIGHT_BLACK=$(tput setaf 8)
    export BRIGHT_RED=$(tput setaf 9)
    export BRIGHT_GREEN=$(tput setaf 10)
    export BRIGHT_YELLOW=$(tput setaf 11)
    export BRIGHT_BLUE=$(tput setaf 12)
    export BRIGHT_MAGENTA=$(tput setaf 13)
    export BRIGHT_CYAN=$(tput setaf 14)
    export BRIGHT_WHITE=$(tput setaf 15)
fi

declare -Ag color2hex=(
    black "#cccccc"
    red "#ffc7c7"
    green "#c8ffc2"
    yellow "#fff6c7"
    blue "#c4effa"
    magenta "#f2cdf3"
    cyan "#c5fdf1"
    white "#f4f3f2"
    bright-black "#5c617d"
    bright-red "#ff80ab"
    bright-green "#bee883"
    bright-yellow "#ffad6a"
    bright-blue "#80d7fe"
    bright-magenta "#c289f0"
    bright-cyan "#79e1cb"
    bright-white "#ffffff"
    grey-background "#282C34"
    grey-popoutmenu "#21252B"
    grey-sectionhead "#9DA5B3"
    grey-comment "#676E95"
    grey-self "#C6CFF0"
)
