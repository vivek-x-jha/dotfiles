# https://www.gnu.org/software/bash/

# Load shell environment variables
# shellcheck disable=SC1091
source "$HOME/.zshenv"

# Bash Line Editor
[[ $- == *i* ]] && source "$XDG_DATA_HOME/blesh/ble.sh" --noattach

# History Opts
export HISTFILE="$XDG_STATE_HOME/bash/.bash_history"
export HISTTIMEFORMAT="%F %T "

# Bash Opts
shopt -s autocd
set -o vi

# PATH + Secrets
source "$XDG_CONFIG_HOME/bash/.path"

# Prompt
eval "$(starship init bash)"

# Authenticate github cli with 1password
source "$XDG_CONFIG_HOME/op/plugins.sh"

# Aliases
source "$XDG_CONFIG_HOME/bash/aliases"

# Color ls, tree, eza
eval "$(dircolors "$XDG_CONFIG_HOME/eza/.dircolors")"

# Fuzzy Finder
eval "$(fzf --bash)" && source "$XDG_CONFIG_HOME/fzf/config.sh"

# History TUI
eval "$(atuin init bash)"

# Directory Jumper
eval "$(zoxide init bash --cmd j)"

# Keybindings
source "$XDG_CONFIG_HOME/bash/mappings"

# Auto-plugins + Completions + Syntax-highlighting
[[ ! ${BLE_VERSION-} ]] || ble-attach
