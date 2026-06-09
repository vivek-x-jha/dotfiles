# https://www.gnu.org/software/bash/

# Environment
# shellcheck disable=SC1091
source "$HOME/.dotfiles/shells/env"

# Colorscheme
# shellcheck disable=SC1090
source "$SHELL_CONFIG/colors/$SHELL_THEME"

# Plugin Manager
[[ $- == *i* ]] && source "$XDG_DATA_HOME/blesh/ble.sh" --noattach --rcfile "$SHELL_CONFIG/bash/.blerc"

# History
export HISTFILE="$XDG_STATE_HOME/bash/.bash_history"
export HISTTIMEFORMAT="%F %T "

# Options
shopt -s autocd
set -o vi

# PATH + Secrets
source "$SHELL_CONFIG/profile"

# Prompt
eval "$(starship init bash)"

# Functions
# shellcheck disable=SC1090
for fn in "$SHELL_CONFIG"/bash/funcs/*; do [[ -f $fn ]] && source "$fn"; done

# Aliases
source "$SHELL_CONFIG/aliases"

# Color ls + eza
dircolors_bin="$(command -v dircolors || command -v gdircolors)"
eval "$("$dircolors_bin" "$XDG_CONFIG_HOME/eza/.dircolors")"

# Fuzzy finder
eval "$(fzf --bash)" && source "$XDG_CONFIG_HOME/fzf/fzf.sh"

# Completions
for completion in "$SHELL_CONFIG"/bash/completions/*.bash; do
  [[ -f $completion ]] && source "$completion"
done

# Command history
eval "$(atuin init bash --disable-ai)" && {
  export ATUIN_TMUX_POPUP=true
  bind -m vi-command '"\C-r": "i__atuin_history\n"'
  bind -m vi-command '"\e[A": "i__atuin_history --shell-up-key-binding\n"'
  bind -m vi-command '"\eOA": "i__atuin_history --shell-up-key-binding\n"'
}

# Directory jumper
eval "$(zoxide init bash)" && bind '"\C-p": "zi\n"'

# Keybindings
bind -x '"\C-o": printf \"\\ec\"; exec '"$(which bash)"
bind -x '"\el": clear'
bind -x '"\C-n": '"$EDITOR"' -S Session.vim'
bind '"\C-g": "glg -5\n"'

# Plugins
[[ ! ${BLE_VERSION-} ]] || ble-attach
