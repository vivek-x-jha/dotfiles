# Add MacOS tools - Homebrew + iTerm2 utilities
[[ $(uname) == Darwin ]] && {
  PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
  PATH="$PATH:/Applications/iTerm.app/Contents/Resources/utilities"
}

# Add user-managed tool directories
PATH="$HOME/.local/bin:$PATH"
PATH="$XDG_DATA_HOME/fzf/bin:$PATH"
PATH="$CARGO_HOME/bin:$PATH"
PATH="$XDG_DATA_HOME/bob/nvim-bin:$PATH"

# Dedupe PATH (keep first occurrence) in zsh only
[[ -n ${ZSH_VERSION-} ]] && typeset -U PATH

export PATH

# Load secrets after PATH setup so private overrides see the final baseline environment
# Use a regular file only; special files such as FIFOs can block shell startup
# shellcheck disable=SC1091
[[ -f "$HOME/.dotfiles/.env" ]] && source "$HOME/.dotfiles/.env"
