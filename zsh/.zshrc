# https://zsh.sourceforge.io/

# Initialize shell prompt instantly
[[ -r $XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh ]] && source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"

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

# Initialize plugin manager
source "$XDG_DATA_HOME/zap/zap.zsh"

# Load & configure theme
plug romkatv/powerlevel10k && plug "$ZDOTDIR/.p10k.zsh"

# Load core plugins
plug marlonrichert/zsh-autocomplete
plug hlissner/zsh-autopair
plug zsh-users/zsh-autosuggestions
plug zsh-users/zsh-completions

# Lazy load shell functions
for fn in "$ZDOTDIR/funcs"/*; do autoload -Uz "$(basename "$fn")"; done

# Load aliases
plug "$ZDOTDIR/configs/aliases"

# Load completions
plug "$ZDOTDIR/configs/completions"

# Initialize & configure syntax-highlighting
plug zsh-users/zsh-syntax-highlighting && plug "$ZDOTDIR/configs/syntax-highlighting"

# Load & configure fuzzy finder
source <(fzf --zsh) && plug "$XDG_CONFIG_HOME/fzf/config.sh"

# Authenticate github cli with 1password
plug "$XDG_CONFIG_HOME/op/plugins.sh"

# Set LS_COLORS: ls, tree, eza
eval "$(gdircolors "$XDG_CONFIG_HOME/eza/.dircolors")"

# Load & configure shell history manager
eval "$(atuin init zsh)" && plug "$XDG_CONFIG_HOME/atuin/mappings/zsh"

# Load & configure shell directory navigator
eval "$(zoxide init zsh --cmd j)"
