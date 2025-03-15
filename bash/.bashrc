# https://www.gnu.org/software/bash/

# Shell Opts
export HISTFILE="$XDG_CACHE_HOME/bash/.bash_history"; export HISTTIMEFORMAT="%F %T "

shopt -s autocd; set -o vi

# Set PATH + FPATH & load secrets
source "$XDG_CONFIG_HOME/bash/.path"

# Shell prompt
eval "$(starship init bash)"

# Shell functions
source "$XDG_CONFIG_HOME/bash/funcs/utils.sh" && source "$XDG_CONFIG_HOME/bash/funcs/update.sh"

# Shell aliases
source "$XDG_CONFIG_HOME/bash/configs/aliases"

# Authenticate github cli with 1password
source "$XDG_CONFIG_HOME/op/plugins.sh"

# Shell "auto" plugins + completions + syntax-highlighting
# shellcheck disable=SC1091
source "$XDG_DATA_HOME/blesh/ble.sh"

# Color ls, tree, eza
eval "$(gdircolors "$XDG_CONFIG_HOME/eza/.dircolors")"

# Fzf shell bindings
eval "$(fzf --bash)" && source "$XDG_CONFIG_HOME/fzf/config.sh"

# Shell history TUI
eval "$(atuin init bash)"

# Directory Autojumper
eval "$(zoxide init bash --cmd j)"

# Shell keybindings
source "$XDG_CONFIG_HOME/bash/configs/mappings"
