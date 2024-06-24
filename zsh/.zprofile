export SHELL_SESSIONS_DISABLE=1

[[ -z $TMUX ]] || { PATH=''; eval "$(/usr/libexec/path_helper -s)" }
[[ $PATH == */opt/homebrew/bin* ]] || eval "$(/opt/homebrew/bin/brew shellenv)"
[[ $PATH == */Library/Frameworks/Python.framework/Versions/3.12/bin* ]] || export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"
[[ $PATH == */Library/TeX/texbin* ]] || export PATH="${PATH}:/Library/TeX/texbin"
[[ $PATH == */Applications/iTerm.app/Contents/Resources/utilities* ]] || export PATH="${PATH}:/Applications/iTerm.app/Contents/Resources/utilities"
fpath=("$HOMEBREW_PREFIX/share/zsh-completions" "$ZDOTDIR/functions" "${fpath[@]}")
