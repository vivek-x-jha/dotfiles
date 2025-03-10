# https://zsh.sourceforge.io/

# Initialize instant prompt 
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

# Load fuzzy finder shell bindings
source <(fzf --zsh)

# Set LS_COLORS: ls, tree, eza
eval "$(gdircolors "$XDG_CONFIG_HOME/eza/.dircolors")"

# Load & configure shell history manager
eval "$(atuin init zsh)"

# Load & configure shell directory navigator
eval "$(zoxide init zsh --cmd j)"

# Load shell functions
for fn in "$ZDOTDIR/funcs"/*; do autoload -Uz "$(basename "$fn")"; done

# Load plugins + configs
source "$XDG_DATA_HOME/zap/zap.zsh"

plug romkatv/powerlevel10k                  # Load shell prompt
plug marlonrichert/zsh-autocomplete         # Load autocomplete
plug hlissner/zsh-autopair                  # Load auopair
plug zsh-users/zsh-autosuggestions          # Load autosuggestions 
plug zsh-users/zsh-completions              # Load completions
plug zsh-users/zsh-syntax-highlighting      # Load syntax-highlighting

plug "$ZDOTDIR/configs/aliases"             # Load aliases
plug "$ZDOTDIR/configs/completions"         # Load completions
plug "$ZDOTDIR/configs/mappings"            # Load keybindings
plug "$ZDOTDIR/configs/syntax-highlighting" # Configure syntax-highlighting

plug "$ZDOTDIR/themes/p10k-sourdiesel.zsh"  # Configure shell prompt

plug "$XDG_CONFIG_HOME/fzf/config.sh"       # Configure fuzzy finder 
plug "$XDG_CONFIG_HOME/op/plugins.sh"       # Authenticate github cli with 1p
