# Create file structure: https://specifications.freedesktop.org/basedir-spec/latest/
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Editing and Pagination
if [[ -f $XDG_CONFIG_HOME/nvim/init.lua || -f $XDG_CONFIG_HOME/nvim/init.vim ]]; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

export VISUAL="$EDITOR"

if [[ -f $XDG_CONFIG_HOME/bat/config ]]; then
  export PAGER='bat -p'
  export MANPAGER="sh -c 'col -bx | bat -pl man --paging=always --theme=sourdiesel'"
fi

# Supress homebrew hints & dynamically create binary path
export HOMEBREW_NO_ENV_HINTS=1
case "$(uname -m)" in
  'arm64' ) export HOMEBREW_BIN='/opt/homebrew/bin' ;;
  'x86_64') export HOMEBREW_BIN='/usr/local/bin'    ;;
esac

# TMUX
export TMUX_PLUGIN_MANAGER_PATH="$XDG_DATA_HOME/tmux/plugins"
export TMUX_FZF_LAUNCH_KEY='f'

# History 
export ATUIN_NOBIND='true'
export LESSHISTFILE="$XDG_CACHE_HOME/less/.lesshst"
export MYSQL_HISTFILE="$XDG_CACHE_HOME/mysql/.mysql_history"
export MYCLI_HISTFILE="$XDG_CACHE_HOME/mycli/.mycli-history"

# Base16 colors
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

# Other colors
export GREY='\e[38;5;248m'
export RESET='\e[0m'
export GREP_COLOR="38;5;9"
export GIT_PRETTY="%C(yellow)%h %C(blue)%an %C(brightmagenta)%ad%C(auto)%d %C(white)%s %Creset"
export EZA_COLORS="nb=00;38;5;0:nk=00;38;5;7:nm=00;38;5;3:ng=00;38;5;1:nt=00;38;5;6:lp=00;38;5;4:"

# Task
export TASKRC="$XDG_CONFIG_HOME/task/config"
export TASKDATA="$XDG_DATA_HOME/task"

# Z.lua & Zoxide
export _ZL_DATA="$XDG_DATA_HOME/z.lua/.zlua"
export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"

# Configure shell options
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export SHELL_SESSIONS_DISABLE=1
