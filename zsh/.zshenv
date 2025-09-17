# Create file structure: https://specifications.freedesktop.org/basedir-spec/latest/
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Configure shell options
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZAP_GIT_PREFIX='git@github.com:'
export SHELL_SESSIONS_DISABLE=1

# Set default editor
export EDITOR=nvim

# Set graphical editor
export VISUAL="$EDITOR"

# Set default pagination
[[ -f $XDG_CONFIG_HOME/bat/config ]] && {
  export PAGER='bat -p'
  export MANPAGER="sh -c 'col -bx | bat -pl man --paging=always --theme=sourdiesel'"
}

# TMUX
export TMUX_PLUGIN_MANAGER_PATH="$XDG_DATA_HOME/tmux/plugins"
export TMUX_FZF_LAUNCH_KEY='f'

# Zoxide
export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"

# History
export LESSHISTFILE="$XDG_STATE_HOME/less/.less_history"
export MYSQL_HISTFILE="$XDG_STATE_HOME/mysql/.mysql_history"
export MYCLI_HISTFILE="$XDG_STATE_HOME/mycli/.mycli_history"
export PYTHON_HISTORY="$XDG_STATE_HOME/python/.python_history"

# AI
export CODEX_HOME="$XDG_CONFIG_HOME/codex"

# ANSI escape codes
export BLACK='\e[0;30m'
export RED='\e[0;31m'
export GREEN='\e[0;32m'
export YELLOW='\e[0;33m'
export BLUE='\e[0;34m'
export MAGENTA='\e[0;35m'
export CYAN='\e[0;36m'
export WHITE='\e[0;37m'

export BRIGHTBLACK='\e[0;90m'
export BRIGHTRED='\e[0;91m'
export BRIGHTGREEN='\e[0;92m'
export BRIGHTYELLOW='\e[0;93m'
export BRIGHTBLUE='\e[0;94m'
export BRIGHTMAGENTA='\e[0;95m'
export BRIGHTCYAN='\e[0;96m'
export BRIGHTWHITE='\e[0;97m'

export GREY='\e[38;5;248m'
export RESET='\e[0m'

# ANSI hex codes
export BLACK_HEX='#cccccc'
export RED_HEX='#ffc7c7'
export GREEN_HEX='#ceffc9'
export YELLOW_HEX='#fdf7cd'
export BLUE_HEX='#c4effa'
export MAGENTA_HEX='#eccef0'
export CYAN_HEX='#8ae7c5'
export WHITE_HEX='#f4f3f2'

export BRIGHTBLACK_HEX='#5c617d'
export BRIGHTRED_HEX='#f096b7'
export BRIGHTGREEN_HEX='#d2fd9d'
export BRIGHTYELLOW_HEX='#f3b175'
export BRIGHTBLUE_HEX='#80d7fe'
export BRIGHTMAGENTA_HEX='#c9ccfb'
export BRIGHTCYAN_HEX='#47e7b1'
export BRIGHTWHITE_HEX='#ffffff'

export DARK_HEX='#1b1c28'
export GREY_HEX='#313244'

export NVIM_BG_HEX='NONE'
export WEZTERM_BG_HEX='#212030'

# Application colors
export EZA_COLORS="nb=00;38;5;0:nk=00;38;5;7:nm=00;38;5;3:ng=00;38;5;1:nt=00;38;5;6:lp=00;38;5;4:"
export GIT_PRETTY="%C(yellow)%h %C(blue)%an %C(brightmagenta)%ad%C(auto)%d %C(white)%s %Creset"
export GREP_COLOR="1;38;5;2"
