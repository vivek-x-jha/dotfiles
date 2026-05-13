_setup_path() {
  local brewbin=''
  local dir=''
  local paths=(
    "$HOME/.local/bin"
    "$XDG_DATA_HOME/fzf/bin"
    "$CARGO_HOME/bin"
    "$XDG_DATA_HOME/bob/nvim-bin"
  )

  # Add MacOS tools - Homebrew + iTerm2 utilities
  [[ $(uname) == Darwin ]] && {
    for brewbin in '/opt/homebrew/sbin' '/opt/homebrew/bin'; do PATH="$brewbin:$PATH"; done
    PATH="$PATH:/Applications/iTerm.app/Contents/Resources/utilities"
  }

  # Add user-managed tool directories
  for dir in "${paths[@]}"; do PATH="$dir:$PATH"; done

  # Dedupe PATH (keep first occurrence) in zsh only
  [[ -n ${ZSH_VERSION-} ]] && typeset -U PATH

  export PATH

  # Load secrets from a regular file only; special files such as FIFOs can block shell startup
  # shellcheck disable=SC1091
  [[ -f "$HOME/.dotfiles/.env" ]] && source "$HOME/.dotfiles/.env"
}

_setup_path
unfunction _setup_path
