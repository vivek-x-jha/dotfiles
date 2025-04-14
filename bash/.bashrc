# https://www.gnu.org/software/bash/
# shellcheck disable=SC1091

# Environment
source "$HOME/.zshenv"

# Plugin Manager
[[ $- == *i* ]] && source "$XDG_DATA_HOME/blesh/ble.sh" --noattach

# History
export HISTFILE="$XDG_STATE_HOME/bash/.bash_history"
export HISTTIMEFORMAT="%F %T "

# Options
shopt -s autocd
set -o vi

# PATH + Secrets
source "$ZDOTDIR/.zprofile"

# Prompt
eval "$(starship init bash)"

# Functions
source "$XDG_CONFIG_HOME/bash/funcs"

# Authenticate CLI tools w/ 1Password
source "$XDG_CONFIG_HOME/op/plugins.sh"

# Aliases
source "$XDG_CONFIG_HOME/bash/aliases"

# Color ls, tree, eza
eval "$(dircolors "$XDG_CONFIG_HOME/eza/.dircolors")"

# Fuzzy Finders
eval "$(fzf --bash)" && source "$XDG_CONFIG_HOME/fzf/config.sh"
eval "$(atuin init bash)"
eval "$(zoxide init bash --cmd j)"

# Keybindings
source "$XDG_CONFIG_HOME/bash/keymaps"

# Plugins
[[ ! ${BLE_VERSION-} ]] || ble-attach
