# Load api keys
[ -f "$HOME/.dotfiles/.env" ] && source "$HOME/.dotfiles/.env"

# Configure shell opts
export HISTFILE="$XDG_CACHE_HOME/bash/.bash_history"
export HISTTIMEFORMAT="%F %T "

shopt -s autocd

# Ensure PATH gets set - even in shell interactive mode or tmux
source "$XDG_CONFIG_HOME/bash/.path"

# Laad & configure shell prompt string 
eval "$(starship init bash)"

# Load & configure shell fuzzy finder
eval "$(fzf --bash)" && source "$XDG_CONFIG_HOME/fzf/config.sh"

# Authenticate github cli with 1password
source "$XDG_CONFIG_HOME/op/plugins.sh"

# Load core shell plugins: autocomplete, autopair, autosuggestions, syntax-highlighting
source "$XDG_DATA_HOME/blesh/ble.sh"

# Load shell functions
for fn in "$XDG_CONFIG_HOME/bash/funcs"/*; do source "$fn"; done

# Configure shell aliases and ensure PATH set - even in shell interactive mode or tmux
for cnf in "$XDG_CONFIG_HOME/bash/configs"/*; do source "$cnf"; done

# Set LS_COLORS: ls, tree, eza
eval "$(gdircolors "$XDG_CONFIG_HOME/eza/.dircolors")"

# Load & configure shell history manager
eval "$(atuin init bash)" && source "$XDG_CONFIG_HOME/atuin/mappings/bash"

# Load & configure shell directory navigator (i.e. "jump to" tools)
eval "$(lua "$(brew --prefix)/share/z.lua/z.lua" --init enhanced once bash)"
eval "$(zoxide init bash --cmd j)"
