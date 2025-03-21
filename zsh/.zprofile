# Reset default PATH
declare -U path=() && eval "$(/usr/libexec/path_helper -s)"

# Prepend homebrew to PATH
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null)" || eval "$(/usr/local/bin/brew shellenv)"

# Load secrets
[[ -f $HOME/.dotfiles/.env ]] && source "$HOME/.dotfiles/.env"

# Append iTerm uilities to PATH
path+=("/Applications/iTerm.app/Contents/Resources/utilities")

# Prepend Zsh completions and functions to FPATH
fpath=("$ZSH_DATA_HOME/zsh-completions/src" "$ZDOTDIR/funcs" "$fpath[@]")
export FPATH
