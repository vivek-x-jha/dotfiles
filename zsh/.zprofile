# Reset default PATH
unset PATH && eval "$(/usr/libexec/path_helper -s)"

# Prepend homebrew & coreutils to PATH on MacOS
[[ $(uname) == Darwin ]] && {
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
  PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
}

# Load secrets
# shellcheck disable=SC1091
[[ -f $HOME/.dotfiles/.env ]] && source "$HOME/.dotfiles/.env"

# Append iTerm uilities to PATH
PATH="$PATH:/Applications/iTerm.app/Contents/Resources/utilities"
export PATH
