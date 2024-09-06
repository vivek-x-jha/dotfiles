# Dotfiles
export DOT="$HOME/.dotfiles"

# XDG base directory specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Neovim editing options
export EDITOR='nvim'
export VISUAL="$EDITOR"

# Homebrew binary path
case "$(uname -m)" in
  'arm64' ) export HOMEBREW_BIN='/opt/homebrew/bin' ;;
  'x86_64') export HOMEBREW_BIN='/usr/local/bin'    ;;
esac

# Tmux plugin manager
export TPM="$XDG_CONFIG_HOME/tmux/plugins/tpm"

# History 
export LESSHISTFILE="$XDG_CACHE_HOME/less/.lesshst"
export MYSQL_HISTFILE="$XDG_CACHE_HOME/mysql/.mysql_history"
export MYCLI_HISTFILE="$XDG_CACHE_HOME/mycli/.mycli-history"

# Python
export PYTHONUSERDIR="$DOT/python"
export PYTHONSTARTUP="$PYTHONUSERDIR/startup.py"

# User Configurations
[ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"
