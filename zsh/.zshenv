# https://zsh.sourceforge.io/

# Dotfiles
export DOT="$HOME/.dotfiles"

# XDG base directory specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Shell home and z.lua cache
export ZDOTDIR="$DOT/zsh"
export _ZL_DATA="$XDG_CACHE_HOME/zlua/.zlua"
export SHELL_SESSIONS_DISABLE=1

# Neovim editing options
export EDITOR='nvim'
export VISUAL="$EDITOR"

# Homebrew
export HOMEBREW_NO_ENV_HINTS=1
case "$(uname -m)" in
  'arm64' ) export HOMEBREW_BIN='/opt/homebrew/bin' ;;
  'x86_64') export HOMEBREW_BIN='/usr/local/bin'    ;;
esac

# Tmux plugin manager
export TPM="$XDG_CONFIG_HOME/tmux/plugins/tpm"

# History 
export ATUIN_NOBIND='true'
export LESSHISTFILE="$XDG_CACHE_HOME/less/.lesshst"
export MYSQL_HISTFILE="$XDG_CACHE_HOME/mysql/.mysql_history"
export MYCLI_HISTFILE="$XDG_CACHE_HOME/mycli/.mycli-history"

# Python
export PYTHONUSERDIR="$DOT/python"
# export PYTHONSTARTUP="$PYTHONUSERDIR/startup.py"
