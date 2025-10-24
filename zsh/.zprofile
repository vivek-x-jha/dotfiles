# Prepare PATH on MacOS
[[ $(uname) == Darwin ]] && {
  unset PATH

  # Add default MacOS binaries to PATH
  eval "$(/usr/libexec/path_helper -s)"

  # Prepend homebrew to PATH
  export HOMEBREW_NO_ENV_HINTS=1
  export HOMEBREW_INSTALL_BADGE="📦"
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"

  # Add iTerm uilities to PATH
  PATH="$PATH:/Applications/iTerm.app/Contents/Resources/utilities"
}

# Prepend uv tools to PATH
export PATH="$HOME/.local/bin:$PATH"

# Add nvim-bin to PATH
PATH="$XDG_DATA_HOME/bob/nvim-bin:$PATH"

export PATH

# Load secrets only once per top-level login shell
# shellcheck disable=SC1091
[[ -z ${DOTFILES_SECRETS_INIT:-} ]] &&
  export DOTFILES_SECRETS_INIT=1 &&
  [[ -f $HOME/.dotfiles/.env ]] &&
  source "$HOME/.dotfiles/.env"
