# Configure shell history
export HISTFILE="$XDG_CACHE_HOME/bash/.bash_history"
export HISTTIMEFORMAT="%F %T "

# Re-initialize PATH in new tmux sessions
[ -z "$TMUX" ] || source "$DOT/bash/configs/.path"

# Initialize secrets
[ -f "$DOT/.env" ] && source "$DOT/.env"

# Configure colorscheme: ls, tree
eval "$(gdircolors "$DOT/.dircolors")"

# Configure colorscheme: eza
source "$DOT/.ezarc"

# Configure shell options
shopt -s autocd

# Initialize shell user functions
source "$DOT/bash/functions.sh"

# Initialize shell core plugins: auto-complete, auto-pair, auto-suggestions, syntax-highlighting
source "$XDG_DATA_HOME/blesh/ble.sh"

# Initialize shell aliases
source "$DOT/bash/configs/.aliases"

# Initialize & configure shell prompt theme
eval "$(starship init bash)"

# Initialize & configure fuzzy finder
eval "$(fzf --bash)" && source "$DOT/.fzfrc"

# Initialize & configure shell history manager
eval "$(atuin init bash)" && { bind -x '"\C-e": "__atuin_history"'; bind -x '"\e[A": "__atuin_history --shell-up-key-binding"'; }

# Initialize shell authentication manager: 1p -> gh
source "$XDG_CONFIG_HOME/op/plugins.sh"
