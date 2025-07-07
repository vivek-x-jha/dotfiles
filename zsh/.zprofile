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

  export PATH
}

# Load secrets
# shellcheck disable=SC1091
[[ -f $HOME/.dotfiles/.env ]] && source "$HOME/.dotfiles/.env"
