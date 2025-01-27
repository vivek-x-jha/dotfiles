# Dotfiles
export DOT="$HOME/.dotfiles"

# Create file structure: https://specifications.freedesktop.org/basedir-spec/latest/
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Editing and Pagination
if command -v nvim &>/dev/null; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

export VISUAL="$EDITOR"

command -v bat &>/dev/null && export PAGER='bat -p'

# Supress homebrew hints & dynamically create binary path
export HOMEBREW_NO_ENV_HINTS=1
case "$(uname -m)" in
  'arm64' ) export HOMEBREW_BIN='/opt/homebrew/bin' ;;
  'x86_64') export HOMEBREW_BIN='/usr/local/bin'    ;;
esac

# TMUX plugin manager path
export TPM="$XDG_CONFIG_HOME/tmux/plugins/tpm"

# History 
export ATUIN_NOBIND='true'
export LESSHISTFILE="$XDG_CACHE_HOME/less/.lesshst"
export MYSQL_HISTFILE="$XDG_CACHE_HOME/mysql/.mysql_history"
export MYCLI_HISTFILE="$XDG_CACHE_HOME/mycli/.mycli-history"

# Python
export PYTHONUSERDIR="$DOT/python"
# export PYTHONSTARTUP="$PYTHONUSERDIR/startup.py"

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

# Configure shell options: https://zsh.sourceforge.io/
export ZDOTDIR="$DOT/zsh"
export _ZL_DATA="$XDG_CACHE_HOME/zlua/.zlua"
export SHELL_SESSIONS_DISABLE=1
export P10K_INSTA_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"

export ZOPTS=(
  alwaystoend
  autocd
  extendedhistory
  histexpiredupsfirst
  histignoredups
  histignorespace
  incappendhistory
  interactivecomments
  sharehistory
)

export ZPLUGS=(
  autocomplete
  autopair
  autosuggestions
  syntax-highlighting
)
