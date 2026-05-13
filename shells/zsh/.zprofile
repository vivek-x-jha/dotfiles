# Add a directory to the front of PATH when it exists
prepend_path() {
  [[ ${1:-} == '-h' || ${1:-} == '--help' ]] && {
    print 'usage: prepend_path <directory>'
    return
  }

  [[ -d "$1" ]] && PATH="$1:$PATH"
}

# Add MacOS tools - Homebrew + iTerm2 utilities
[[ $(uname) == Darwin ]] && {
  for dir in '/opt/homebrew/sbin' '/opt/homebrew/bin'; do prepend_path "$dir"; done
  PATH="$PATH:/Applications/iTerm.app/Contents/Resources/utilities"
}

# Add rest
paths=(
  "$HOME/.local/bin"
  "$XDG_DATA_HOME/fzf/bin"
  "$CARGO_HOME/bin"
  "$XDG_DATA_HOME/bob/nvim-bin"
)

for dir in "${paths[@]}"; do prepend_path "$dir"; done

# Dedupe PATH (keep first occurrence) in zsh only
[[ -n ${ZSH_VERSION-} ]] && typeset -U PATH

export PATH

# Load secrets from a regular file only; special files such as FIFOs can block shell startup
# shellcheck disable=SC1091
[[ -f "$HOME/.dotfiles/.env" ]] && source "$HOME/.dotfiles/.env"
