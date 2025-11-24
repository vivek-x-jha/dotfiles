[[ $(uname) == Darwin ]] && {
  # Prepend homebrew to PATH
  PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

  # Add iTerm uilities to PATH
  PATH="$PATH:/Applications/iTerm.app/Contents/Resources/utilities"
}

# Prepend uv tools to PATH
export PATH="$HOME/.local/bin:$PATH"

# Add cargo bin to PATH (respects XDG CARGO_HOME override)
export PATH="$CARGO_HOME/bin:$PATH"

# Add nvim-bin to PATH
PATH="$XDG_DATA_HOME/bob/nvim-bin:$PATH"

# Dedupe PATH (keep first occurrence)
typeset -U PATH

export PATH

# Load secrets (ignore if missing)
# shellcheck disable=SC1091
source "$HOME/.dotfiles/.env" 2>/dev/null
