# Set History
export HISTFILE="$XDG_CACHE_HOME/bash/.bash_history"

# Configure Shell Options
shopt -s autocd

# Set PATH and FPATH without duplicating any directories
[[ -z $TMUX ]] || { PATH=''; eval "$(/usr/libexec/path_helper -s)"; }
[[ $PATH == *$HOMEBREW_BIN* ]] || eval "$($HOMEBREW_BIN/brew shellenv)"
[[ $PATH == */Library/Frameworks/Python.framework/Versions/3.12/bin* ]] || export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:$PATH"
[[ $PATH == */Library/TeX/texbin* ]] || export PATH="$PATH:/Library/TeX/texbin"
[[ $PATH == */Applications/iTerm.app/Contents/Resources/utilities* ]] || export PATH="$PATH:/Applications/iTerm.app/Contents/Resources/utilities"

# Configure Colorschmes: ls/eza/grep + variables
command -v gdircolors &> /dev/null || brew install coreutils
eval "$(gdircolors "$DOT/.dircolors")"

source "$DOT/.ezacolors"
source "$DOT/.grepcolors"
source "$DOT/.colorscheme"

# Configure Shell Core Plugins
source "$XDG_DATA_HOME/blesh/ble.sh"

# Configure Shell Theme, Aliases, & Functions
command -v starship &> /dev/null || brew install starship
eval "$(starship init bash)"

source "$DOT/bash/.aliases"
source "$DOT/bash/functions.sh"

# Enable Fuzzy Finder
command -v fzf &> /dev/null || brew install fzf 
eval "$(fzf --bash)"

# Log Database History
export MYSQL_HISTFILE="$XDG_CACHE_HOME/mysql/.mysql_history"
export MYCLI_HISTFILE="$XDG_CACHE_HOME/mycli/.mycli-history"

# Initialize Python Environments
export PYTHONSTARTUP="$DOT/.pythonstartup"
