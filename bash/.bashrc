# Set History
export HISTFILE="$XDG_CACHE_HOME/bash/.bash_history"
export HISTTIMEFORMAT="%F %T "

# Configure Shell Options
shopt -s autocd

# Set PATH and FPATH without duplicating any directories
[[ -z $TMUX ]] || { PATH=''; eval "$(/usr/libexec/path_helper -s)"; }
[[ $PATH == *$HOMEBREW_BIN* ]] || eval "$($HOMEBREW_BIN/brew shellenv)"
[[ $PATH == */Library/Frameworks/Python.framework/Versions/3.12/bin* ]] || export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:$PATH"
[[ $PATH == */Library/TeX/texbin* ]] || export PATH="$PATH:/Library/TeX/texbin"
[[ $PATH == */Applications/iTerm.app/Contents/Resources/utilities* ]] || export PATH="$PATH:/Applications/iTerm.app/Contents/Resources/utilities"

# Configure colorschemes for ls, eza, grep, & colors
command -v gdircolors &> /dev/null || brew install coreutils
eval "$(gdircolors "$DOT/.dircolors")"
source "$DOT/.ezarc"
source "$DOT/.greprc"
source "$DOT/.colors"

# Load shell plugins
source "$XDG_DATA_HOME/blesh/ble.sh"

# Load prompt theme
command -v starship &> /dev/null || brew install starship
eval "$(starship init bash)"

# Load aliases
source "$DOT/bash/.aliases"

# Load shell functions
source "$DOT/bash/functions.sh"

# Enable Fuzzy Finder
command -v fzf &> /dev/null || brew install fzf 
eval "$(fzf --bash)"
source "$DOT/.fzfrc"

# Configure Atuin
command -v atuin &>/dev/null || brew install atuin
eval "$(atuin init bash)"
bind -x '"^e" : __atuin_history'
bind -x '"^[[A": __atuin_history --shell-up-key-binding'

# Enable 1Password plugins
source "$XDG_CONFIG_HOME/op/plugins.sh"
