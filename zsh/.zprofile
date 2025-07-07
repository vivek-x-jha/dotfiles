# Prepare PATH on MacOS
[[ $(uname) == Darwin ]] && {
  unset PATH

  # Add default MacOS binaries to PATH
  eval "$(/usr/libexec/path_helper -s)"

  # Prepend homebrew to PATH
  eval "$("$([[ $(uname -m) == arm64 ]] && echo /opt/homebrew || echo /usr/local)"/bin/brew shellenv)"

  # Add iTerm uilities to PATH
  PATH="$PATH:/Applications/iTerm.app/Contents/Resources/utilities"

  export PATH
}

# Load secrets
# shellcheck disable=SC1091
[[ -f $HOME/.dotfiles/.env ]] && source "$HOME/.dotfiles/.env"
