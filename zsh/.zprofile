# Construct PATH and FPATH
declare -U path=()

eval "$(/usr/libexec/path_helper -s)"
[[ -z $HOMEBREW_BIN ]] || eval "$($HOMEBREW_BIN/brew shellenv)"

# Load api keys
[[ -f $HOME/.dotfiles/.env ]] && source "$HOME/.dotfiles/.env"

path+=("/Applications/iTerm.app/Contents/Resources/utilities")

fpath=(
  "$ZSH_DATA_HOME/zsh-completions/src"
  "$ZDOTDIR/funcs"
  "$fpath[@]"
)
