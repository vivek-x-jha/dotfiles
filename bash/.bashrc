# https://www.gnu.org/software/bash/

# Set History
export HISTFILE="$XDG_CACHE_HOME/bash/.bash_history"
export HISTTIMEFORMAT="%F %T "

# Set PATH and FPATH without duplicating any directories
[[ -z $TMUX ]] || { PATH=''; eval "$(/usr/libexec/path_helper -s)"; }
[[ $PATH == *$HOMEBREW_BIN* ]] || eval "$($HOMEBREW_BIN/brew shellenv)"
[[ $PATH == */Library/Frameworks/Python.framework/Versions/3.13/bin* ]] || export PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:$PATH"
[[ $PATH == */Library/TeX/texbin* ]] || export PATH="$PATH:/Library/TeX/texbin"
[[ $PATH == */Applications/iTerm.app/Contents/Resources/utilities* ]] || export PATH="$PATH:/Applications/iTerm.app/Contents/Resources/utilities"

# Load secrets
[ -f "$DOT/.env" ] && source "$DOT/.env"

# Set Shell Options
shopt -s autocd

# Load shell plugins
source "$XDG_DATA_HOME/blesh/ble.sh"

# Load prompt theme
command -v starship &> /dev/null || brew install starship
eval "$(starship init bash)"

# Load aliases
source "$DOT/bash/.aliases"

# Load shell functions
source "$DOT/bash/functions.sh"

# Configure tree and ls: sets LS_COLORS
command -v gdircolors &> /dev/null || brew install coreutils
eval "$(gdircolors "$DOT/.dircolors")"

# Configure eza: sets EZA_COLORS
source "$DOT/.ezarc"

# Configure grep: sets GREP_COLOR
source "$DOT/.greprc"

# Configure fzf and enable shell integration
command -v fzf &> /dev/null || brew install fzf 
eval "$(fzf --bash)"
source "$DOT/.fzfrc"

# Configure atuin
command -v atuin &>/dev/null || brew install atuin
eval "$(atuin init bash)"
bind -x '"\C-e": "__atuin_history"'
bind -x '"\e[A": "__atuin_history --shell-up-key-binding"'

# Configure 1Password plugins
source "$XDG_CONFIG_HOME/op/plugins.sh"
