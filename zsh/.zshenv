# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Dotfiles
export DOT="$HOME/.dotfiles"

# Editor Configuration
export EDITOR='nvim'
export VISUAL="$EDITOR"

# History Configuration
export LESSHISTFILE="$XDG_CACHE_HOME/less/.lesshst"

# Zsh Configuration
export ZDOTDIR="$DOT/zsh"
export _ZL_DATA="$XDG_CACHE_HOME/zlua/.zlua"
export SHELL_SESSIONS_DISABLE=1

# Tmux
export TPM="$XDG_CONFIG_HOME/tmux/plugins/tpm"

# Homebrew
case "$(uname -m)" in
  'arm64' ) export HOMEBREW_BIN='/opt/homebrew/bin' ;;
  'x86_64') export HOMEBREW_BIN='/usr/local/bin'    ;;
esac
