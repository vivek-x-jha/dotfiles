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

# Colors
source "$HOME/.dotfiles/.colorscheme"

# Zoxide
export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"

# Configure shell options
source "$XDG_CONFIG_HOME/bash/.bashrc"
