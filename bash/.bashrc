# https://www.gnu.org/software/bash/

# Load shell environment variables
# shellcheck disable=SC1091
source "$HOME/.config/zsh/.zshenv"

# History Opts
export HISTFILE="$XDG_STATE_HOME/bash/.bash_history"
export HISTTIMEFORMAT="%F %T "

# Bash Opts
shopt -s autocd; set -o vi

# PATH + Secrets
source "$XDG_CONFIG_HOME/bash/.path"

# Prompt
eval "$(starship init bash)"

# Functions
# shellcheck source=/dev/null
for fn in "$XDG_CONFIG_HOME/bash/funcs/"*.sh; do source "$fn"; done

# Authenticate github cli with 1password
source "$XDG_CONFIG_HOME/op/plugins.sh"

# Auto-plugins + Completions + Syntax-highlighting
# shellcheck disable=SC1091
source "$XDG_DATA_HOME/blesh/ble.sh"

# Aliases
source "$XDG_CONFIG_HOME/bash/configs/aliases"

# Color ls, tree, eza
eval "$(gdircolors "$XDG_CONFIG_HOME/eza/.dircolors")"

# Fuzzy Finder
eval "$(fzf --bash)" && source "$XDG_CONFIG_HOME/fzf/config.sh"

# History TUI
eval "$(atuin init bash)"

# Directory Jumper
eval "$(zoxide init bash --cmd j)"

# Keybindings
source "$XDG_CONFIG_HOME/bash/configs/mappings"
