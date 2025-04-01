# https://zsh.sourceforge.io/

# Instant Prompt 
# shellcheck source=/dev/null
# shellcheck disable=SC2296
[[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"

# History Opts
HISTFILE="$XDG_STATE_HOME/zsh/.zsh_history"
HISTSIZE=12000
# shellcheck disable=SC2034
SAVEHIST=10000

setopt extendedhistory histexpiredupsfirst histignoredups histignorespace incappendhistory sharehistory

# Zsh Opts
setopt autocd interactivecomments 

# PATH + Secrets
source "$ZDOTDIR/.zprofile"

# Plugin Manager
# shellcheck disable=SC1091
source "$XDG_DATA_HOME/zap/zap.zsh"

# Prompt
# shellcheck disable=SC1094
plug romkatv/powerlevel10k && source "$ZDOTDIR/.p10k.zsh"

# Functions
for fn in "$ZDOTDIR/funcs"/*; do autoload -Uz "$(basename "$fn")"; done

# Authenticate github cli with 1password
source "$XDG_CONFIG_HOME/op/plugins.sh"

# Auto-plugins
plug marlonrichert/zsh-autocomplete; plug hlissner/zsh-autopair; plug zsh-users/zsh-autosuggestions

# Completions
plug zsh-users/zsh-completions && source "$XDG_CONFIG_HOME/zsh/completions"

# Syntax-highlighting
plug zsh-users/zsh-syntax-highlighting && source "$ZDOTDIR/syntax-highlighting"

# Aliases
source "$ZDOTDIR/aliases"

# Color ls, tree, eza
eval "$(gdircolors "$XDG_CONFIG_HOME"/eza/.dircolors || dircolors "$XDG_CONFIG_HOME"/eza/.dircolors)"

# Fuzzy Finder
# shellcheck source=/dev/null
source <(fzf --zsh) && source "$XDG_CONFIG_HOME/fzf/config.sh"

# History TUI
eval "$(atuin init zsh)"

# Directory Jumper
eval "$(zoxide init zsh --cmd j)"

# Keybindings
source "$ZDOTDIR/mappings"
