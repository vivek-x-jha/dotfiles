export BDOTDIR="$XDG_CONFIG_HOME/bash"

# Configure shell history
export HISTFILE="$XDG_CACHE_HOME/bash/.bash_history"
export HISTTIMEFORMAT="%F %T "

# Configure shell aliases & PATH
for cnf in "$BDOTDIR/configs"/*; do source "$cnf"; done

# Initialize secrets
[ -f "$HOME/.dotfiles/.env" ] && source "$HOME/.dotfiles/.env"

# Configure colorscheme: ls, tree, eza
eval "$(gdircolors "$XDG_CONFIG_HOME/eza/.dircolors")"

# Configure shell options
shopt -s autocd

# Initialize shell user functions
for fn in "$BDOTDIR/funcs"/*; do source "$fn"; done

# Initialize shell core plugins: auto-complete, auto-pair, auto-suggestions, syntax-highlighting
source "$XDG_DATA_HOME/blesh/ble.sh"

# Initialize shell aliases
source "$BDOTDIR/configs/aliases"

# Initialize & configure shell prompt theme
eval "$(starship init bash)"

# Initialize & configure fuzzy finder
eval "$(fzf --bash)" && source "$XDG_CONFIG_HOME/fzf/config.sh"

# Initialize & configure shell history manager
eval "$(atuin init bash)" && { bind -x '"\C-e": "__atuin_history"'; bind -x '"\e[A": "__atuin_history --shell-up-key-binding"'; }

# Initialize shell authentication manager: 1p -> gh
source "$XDG_CONFIG_HOME/op/plugins.sh"
