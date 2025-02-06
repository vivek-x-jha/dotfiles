# Construct PATH and FPATH
declare -U path=()

eval "$(/usr/libexec/path_helper -s)"
eval "$($HOMEBREW_BIN/brew shellenv)"

path=(
  "/Library/Frameworks/Python.framework/Versions/3.13/bin"
  "$path[@]"
  "/Applications/iTerm.app/Contents/Resources/utilities"
)

fpath=(
  "$(brew --prefix)/share/zsh-completions"
  "$ZDOTDIR/funcs"
  "$fpath[@]"
)
