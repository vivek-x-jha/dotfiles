path_prepend() { [[ :$PATH: == *":$1:"* ]] || PATH="$1:$PATH"; }

# Add MacOS tools - Homebrew + iTerm2 utilities
[[ $(/usr/bin/uname) == Darwin ]] && {
  path_prepend '/opt/homebrew/sbin'
  path_prepend '/opt/homebrew/bin'
  PATH="$PATH:/Applications/iTerm.app/Contents/Resources/utilities"
}

# Add user-managed tool directories
path_prepend "$HOME/.local/bin"
path_prepend "$XDG_DATA_HOME/fzf/bin"
path_prepend "$CARGO_HOME/bin"
path_prepend "$XDG_DATA_HOME/bob/nvim-bin"

unset -f path_prepend

export PATH

# Load secrets after PATH setup so private overrides see the final baseline environment
# Use a regular file only; special files such as FIFOs can block shell startup
# shellcheck disable=SC1091
[[ -f "$HOME/.dotfiles/.env" ]] && source "$HOME/.dotfiles/.env"
