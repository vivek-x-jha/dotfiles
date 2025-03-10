# https://zsh.sourceforge.io/

# Instant Prompt 
[[ -r $XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh ]] && source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"

# Shell Opts
HISTFILE="$XDG_CACHE_HOME/zsh/.zhistory"
HISTSIZE=12000
SAVEHIST=10000

setopt alwaystoend
setopt autocd
setopt extendedhistory
setopt histexpiredupsfirst
setopt histignoredups
setopt histignorespace
setopt incappendhistory
setopt interactivecomments
setopt sharehistory

# Set PATH + FPATH & load secrets
source "$ZDOTDIR/.zprofile"

# Fzf shell bindings
source <(fzf --zsh) && source "$XDG_CONFIG_HOME/fzf/config.sh"

# Color ls, tree, eza
eval "$(gdircolors "$XDG_CONFIG_HOME/eza/.dircolors")"

# Shell history TUI
eval "$(atuin init zsh --disable-up-arrow --disable-ctrl-r)"

# Directory Autojumper
eval "$(zoxide init zsh --cmd j)"

# Shell plugin manager
source "$XDG_DATA_HOME/zap/zap.zsh"

# Shell prompt
plug romkatv/powerlevel10k && source "$ZDOTDIR/themes/p10k-sourdiesel.zsh"

# Shell functions
for fn in "$ZDOTDIR/funcs"/*; do autoload -Uz "$(basename "$fn")"; done

# Shell aliases
source "$ZDOTDIR/configs/aliases"

# Authenticate github cli with 1password
source "$XDG_CONFIG_HOME/op/plugins.sh"

# Shell "auto" plugins
plug marlonrichert/zsh-autocomplete
plug hlissner/zsh-autopair
plug zsh-users/zsh-autosuggestions

# Shell completions
plug zsh-users/zsh-completions && source "$XDG_CONFIG_HOME/zsh/configs/completions"

# Shell keybindings
source "$ZDOTDIR/configs/mappings"

# Syntax-highlighting
plug zsh-users/zsh-syntax-highlighting && source "$ZDOTDIR/configs/syntax-highlighting"
