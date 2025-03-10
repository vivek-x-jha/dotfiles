# https://www.gnu.org/software/bash/

# Shell Opts
export HISTFILE="$XDG_CACHE_HOME/bash/.bash_history"
export HISTTIMEFORMAT="%F %T "

shopt -s autocd
set -o vi

# Set PATH + FPATH & load secrets
source "$XDG_CONFIG_HOME/bash/.path"

# Fzf shell bindings
eval "$(fzf --bash)" && source "$XDG_CONFIG_HOME/fzf/config.sh"

# Color ls, tree, eza
eval "$(gdircolors "$XDG_CONFIG_HOME/eza/.dircolors")"

# Shell history TUI
eval "$(atuin init bash --disable-up-arrow --disable-ctrl-r)"

# Directory Autojumper
eval "$(zoxide init bash --cmd j)"

# Shell prompt
eval "$(starship init bash)"

# Shell functions
for fn in "$XDG_CONFIG_HOME/bash/funcs"/*; do source "$fn"; done

# Shell aliases
source "$XDG_CONFIG_HOME/bash/configs/aliases"

# Authenticate github cli with 1password
source "$XDG_CONFIG_HOME/op/plugins.sh"

# Shell keybindings
source "$XDG_CONFIG_HOME/bash/configs/mappings"

# Shell "auto" plugins + syntax-highlighting
source "$XDG_DATA_HOME/blesh/ble.sh"
