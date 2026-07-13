# shellcheck shell=bash
# https://www.gnu.org/software/bash/

# Environment
# shellcheck disable=SC1091
source "${XDG_CONFIG_HOME:-$HOME/.config}/shells/env"

# Colorscheme
# shellcheck disable=SC1090
source "$SHELL_CONFIG/colors/$SHELL_THEME"

# Plugin Manager
[[ $- == *i* ]] && source "$XDG_DATA_HOME/blesh/ble.sh" --noattach --rcfile "$SHELL_CONFIG/bash/.blerc"

# History
export HISTFILE="$XDG_STATE_HOME/bash/.bash_history"
export HISTTIMEFORMAT="%F %T "

# Options
shopt -s autocd 2>/dev/null || true
set -o vi

# PATH + Secrets
source "$SHELL_CONFIG/profile"

# Prompt
eval "$(starship init bash)"

# Herdr helpers
source "$DOTFILES_DIR/ai/herdr/default_pane_title.sh"

# Functions
# shellcheck disable=SC1090
for fn in "$SHELL_CONFIG"/bash/funcs/*; do [[ -f $fn ]] && source "$fn"; done
unset fn

# Aliases
source "$SHELL_CONFIG/aliases"

# Fuzzy finder
source "$XDG_CONFIG_HOME/fzf/config"
eval "$(fzf --bash)"

# Compatibility for scripts that expect the bash-completion pkg
source "$SHELL_CONFIG/bash/comps/_cmp-compat.bash"

# Completions
# shellcheck disable=SC1090
for cmp in "$SHELL_CONFIG"/bash/comps/*.bash; do source "$cmp"; done
unset cmp

# Command history
eval "$(atuin init bash --disable-ai)"

# Directory jumper
eval "$(zoxide init bash)"

# Keymaps
source "$SHELL_CONFIG/bash/keymaps/interactive"

# Plugins
[[ ! ${BLE_VERSION-} ]] || ble-attach
