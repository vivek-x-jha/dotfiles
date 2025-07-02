# Prepare PATH on MacOS
[[ $(uname) == Darwin ]] && {
  unset PATH

  # Add default MacOS binaries to PATH
  eval "$(/usr/libexec/path_helper -s)"

  # Prepend homebrew to PATH
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"

  # Prepend GNU coreutils to PATH
  PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"

  # Add iTerm uilities to PATH
  PATH="$PATH:/Applications/iTerm.app/Contents/Resources/utilities"

  export PATH
}

# Load secrets
# shellcheck disable=SC1091
[[ -f $HOME/.dotfiles/.env ]] && source "$HOME/.dotfiles/.env"
