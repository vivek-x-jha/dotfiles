# https://www.gnu.org/software/bash/

# Configure shell opts
export HISTFILE="$XDG_CACHE_HOME/bash/.bash_history"
export HISTTIMEFORMAT="%F %T "

shopt -s autocd
set -o vi

# Ensure PATH gets set - even in shell interactive mode or tmux
source "$XDG_CONFIG_HOME/bash/.path"

# Load & configure shell fuzzy finder
eval "$(fzf --bash)" && source "$XDG_CONFIG_HOME/fzf/config.sh"

# Set LS_COLORS: ls, tree, eza
eval "$(gdircolors "$XDG_CONFIG_HOME/eza/.dircolors")"

# Load & configure shell history manager
eval "$(atuin init bash)"

# Load & configure shell directory navigator
eval "$(zoxide init bash --cmd j)"

# Laad & configure shell prompt string 
eval "$(starship init bash)"

# Load shell functions
for fn in "$XDG_CONFIG_HOME/bash/funcs"/*; do source "$fn"; done

# Load core shell plugins: autocomplete, autopair, autosuggestions, syntax-highlighting
source "$XDG_DATA_HOME/blesh/ble.sh"

# Load aliases
source "$XDG_CONFIG_HOME/bash/configs/aliases"

# Load keybindings
source "$XDG_CONFIG_HOME/bash/configs/mappings"

# Authenticate github cli with 1password
source "$XDG_CONFIG_HOME/op/plugins.sh"
