# Set History
export HISTFILE="$XDG_CACHE_HOME/bash/.bash_history"

# Starship
export STARSHIP_CONFIG="$DOT/starship/starship.toml"

# Set Options
shopt -s autocd

# Set PATH and FPATH without duplicating any directories
[[ -z $TMUX ]] || { PATH=''; eval "$(/usr/libexec/path_helper -s)"; }
[[ $PATH == */opt/homebrew/bin* ]] || eval "$(/opt/homebrew/bin/brew shellenv)"
[[ $PATH == */Library/Frameworks/Python.framework/Versions/3.12/bin* ]] || export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:$PATH"
[[ $PATH == */Library/TeX/texbin* ]] || export PATH="$PATH:/Library/TeX/texbin"
[[ $PATH == */Applications/iTerm.app/Contents/Resources/utilities* ]] || export PATH="$PATH:/Applications/iTerm.app/Contents/Resources/utilities"

# Configure Colorschmes: ls/eza/grep + variables
eval "$(gdircolors "$DOT/dircolors/.dircolors")"
source "$DOT/eza/.eza_colors"
source "$DOT/grep/.grep_colors"
source "$DOT/.colorscheme"

# Configure Shell Theme + Plugins
source "$DOT/bash/.aliases"
source "$DOT/bash/functions.sh"

eval "$(starship init bash)"
eval "$(fzf --bash)"

# OTHER CONFIGURATION FILES
export MYSQL_HISTFILE="$XDG_CACHE_HOME/mysql/.mysql_history"
export MYCLI_HISTFILE="$XDG_CACHE_HOME/mycli/.mycli-history"
export PYTHONSTARTUP="$DOT/python/pythonstartup.py"

source "$XDG_DATA_HOME/blesh/ble.sh"
