# Set History
export HISTFILE="$XDG_CACHE_HOME/bash/.bash_history"
export HISTTIMEFORMAT="%F %T "

# Set PATH and FPATH without duplicating any directories
[[ -z $TMUX ]] || { PATH=''; eval "$(/usr/libexec/path_helper -s)"; }
[[ $PATH == *$HOMEBREW_BIN* ]] || eval "$($HOMEBREW_BIN/brew shellenv)"
[[ $PATH == */Library/Frameworks/Python.framework/Versions/3.13/bin* ]] || export PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:$PATH"
[[ $PATH == */Library/TeX/texbin* ]] || export PATH="$PATH:/Library/TeX/texbin"
[[ $PATH == */Applications/iTerm.app/Contents/Resources/utilities* ]] || export PATH="$PATH:/Applications/iTerm.app/Contents/Resources/utilities"

# Set color variables
colors=(
  0   black         '#cccccc'  '\e[0;30m'
  1   red           '#ffc7c7'  '\e[0;31m'
  2   green         '#ceffc9'  '\e[0;32m'
  3   yellow        '#fdf7cd'  '\e[0;33m'
  4   blue          '#c4effa'  '\e[0;34m'
  5   magenta       '#eccef0'  '\e[0;35m'
  6   cyan          '#8ae7c5'  '\e[0;36m'
  7   white         '#f4f3f2'  '\e[0;37m'

  8   brightblack   '#5c617d'  '\e[0;90m'
  9   brightred     '#f096b7'  '\e[0;91m'
  10  brightgreen   '#d2fd9d'  '\e[0;92m'
  11  brightyellow  '#f3b175'  '\e[0;93m'
  12  brightblue    '#80d7fe'  '\e[0;94m'
  13  brightmagenta '#c9ccfb'  '\e[0;95m'
  14  brightcyan    '#47e7b1'  '\e[0;96m'
  15  brightwhite   '#ffffff'  '\e[0;97m'

  248 grey          '#313244'  '\e[38;5;248m'
  ''  reset         ''         '\e[0m'
)
for ((i=0; i<${#colors[@]}; i+=4)); do declare "${colors[i+1]}"="${colors[i+3]}"; done

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
