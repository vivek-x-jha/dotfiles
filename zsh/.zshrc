# Initialize shell prompt instantly
[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ] && source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"

# Load api keys
[ -f "$HOME/.dotfiles/.env" ] && source "$HOME/.dotfiles/.env"

# Configure shell opts
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

# Ensure PATH and FPATH gets set - even in shell interactive mode or tmux
source "$ZDOTDIR/.zprofile"

# Laad & configure shell prompt string 
source "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" && source "$ZDOTDIR/.p10k.zsh"

# Load & configure shell fuzzy finder
source <(fzf --zsh) && source "$XDG_CONFIG_HOME/fzf/config.sh"

# Authenticate github cli with 1password
source "$XDG_CONFIG_HOME/op/plugins.sh"

# Lazy load shell functions
for fn in "$ZDOTDIR/funcs"/*; do autoload -Uz "$(basename "$fn")"; done

# Load core shell plugins
for plug in 'autocomplete' 'autopair' 'autosuggestions' 'syntax-highlighting'; do source "$(brew --prefix)/share/zsh-$plug/$plug.zsh"; done

# Configure shell aliases, completions, & syntax-highlighting
for cnf in "$ZDOTDIR/configs"/*; do source "$cnf"; done

# Set LS_COLORS: ls, tree, eza
eval "$(gdircolors "$XDG_CONFIG_HOME/eza/.dircolors")"

# Load & configure shell history manager
eval "$(atuin init zsh)" && { bindkey '^e' atuin-search; bindkey '^[[A' atuin-up-search }

# Load & configure shell working directory manager
eval "$(lua "$(brew --prefix)/share/z.lua/z.lua" --init zsh)"
# eval "$(zoxide init zsh)"
