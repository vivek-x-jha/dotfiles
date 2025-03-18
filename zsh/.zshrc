# https://zsh.sourceforge.io/

# Instant Prompt 
[[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"

# History Opts
HISTFILE="$XDG_STATE_HOME/zsh/.zsh_history"
HISTSIZE=12000
SAVEHIST=10000

setopt extendedhistory histexpiredupsfirst histignoredups histignorespace incappendhistory sharehistory

# Zsh Opts
setopt autocd interactivecomments 

# PATH + Secrets
source "$ZDOTDIR/.zprofile"

# Plugin Manager
source "$XDG_DATA_HOME/zap/zap.zsh"

# Prompt
plug romkatv/powerlevel10k && source "$ZDOTDIR/themes/.p10k-sourdiesel.zsh"

# Functions
for fn in "$ZDOTDIR/funcs"/*; do autoload -Uz "$(basename "$fn")"; done

# Authenticate github cli with 1password
source "$XDG_CONFIG_HOME/op/plugins.sh"

# Auto-plugins
plug marlonrichert/zsh-autocomplete; plug hlissner/zsh-autopair; plug zsh-users/zsh-autosuggestions

# Completions
plug zsh-users/zsh-completions && source "$XDG_CONFIG_HOME/zsh/configs/completions"

# Syntax-highlighting
plug zsh-users/zsh-syntax-highlighting && source "$ZDOTDIR/configs/syntax-highlighting"

# Aliases
source "$ZDOTDIR/configs/aliases"

# Color ls, tree, eza
eval "$(gdircolors "$XDG_CONFIG_HOME"/eza/.dircolors || dircolors "$XDG_CONFIG_HOME"/eza/.dircolors)"

# Fuzzy Finder
source <(fzf --zsh) && source "$XDG_CONFIG_HOME/fzf/config.sh"

# History TUI
eval "$(atuin init zsh)"

# Directory Jumper
eval "$(zoxide init zsh --cmd j)"

# Keybindings
source "$ZDOTDIR/configs/mappings"
