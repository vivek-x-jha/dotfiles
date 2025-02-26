# Construct PATH and FPATH
declare -U path=()

eval "$(/usr/libexec/path_helper -s)"
[[ -z $HOMEBREW_BIN ]] || eval "$($HOMEBREW_BIN/brew shellenv)"

path=(
  "/Library/Frameworks/Python.framework/Versions/3.13/bin"
  "$path[@]"
  "/Applications/iTerm.app/Contents/Resources/utilities"
)

fpath=(
  "$ZSH_DATA_HOME/zsh-completions/src"
  "$ZDOTDIR/funcs"
  "$fpath[@]"
)
