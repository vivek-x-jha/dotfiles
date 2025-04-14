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
while IFS= read -r -d '' path; do
  fn="${path##*/}"

  # skip hidden files
  [[ $fn == .* ]] && continue

  # handle any funcs that use cd
  [[ $fn == take ]] && eval "$fn() { mkdir -p \"\$1\" && cd \"\$1\"; }" && continue

  # load func as zsh interactive commands
  eval "$fn() { zsh -ic '$fn \"\$@\"' $fn \"\$@\"; }"
done < <(find "$ZDOTDIR/funcs" -type f -maxdepth 1 -print0)

# Authenticate CLI tools w/ 1Password
source "$XDG_CONFIG_HOME/op/plugins.sh"

# Aliases
source "$ZDOTDIR/aliases"

# Color ls, tree, eza
eval "$(dircolors "$XDG_CONFIG_HOME/eza/.dircolors")"

# Fuzzy Finders
eval "$(fzf --bash)" && source "$XDG_CONFIG_HOME/fzf/config.sh"
eval "$(atuin init bash)"
eval "$(zoxide init bash --cmd j)"

# Keybindings
bind -x '"\C-o": "exec '"$(brew --prefix)"'/bin/bash"'
bind -x '"\C-n": '"$EDITOR"' -S Session.vim'
bind -x '"\C-p": "ji"' # Zoxide interactive TODO fix so does not need an extra enter at end
bind -x '"\el": clear'
bind -m vi-command '"\C-r": "i__atuin_history\n"'
bind -m vi-command '"\e[A": "i__atuin_history --shell-up-key-binding\n"'
bind -m vi-command '"\eOA": "i__atuin_history --shell-up-key-binding\n"'

# Plugins
[[ ! ${BLE_VERSION-} ]] || ble-attach
