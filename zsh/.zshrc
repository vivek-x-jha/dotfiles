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

# Load & configure fuzzy finder
source <(fzf --zsh)

# Set LS_COLORS: ls, tree, eza
eval "$(gdircolors "$XDG_CONFIG_HOME/eza/.dircolors")"

# Load & configure shell history manager
eval "$(atuin init zsh)"

# Load & configure shell directory navigator
eval "$(zoxide init zsh --cmd j)"

# Lazy load shell functions
for fn in "$ZDOTDIR/funcs"/*; do autoload -Uz "$(basename "$fn")"; done

# Set repos & configurations
zsh_plugins=(
  romkatv/powerlevel10k
  marlonrichert/zsh-autocomplete
  hlissner/zsh-autopair
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-completions
  zsh-users/zsh-syntax-highlighting

  "$ZDOTDIR/configs/aliases"
  "$ZDOTDIR/configs/completions"
  "$ZDOTDIR/configs/mappings"
  "$ZDOTDIR/configs/syntax-highlighting"

  "$ZDOTDIR/themes/p10k-sourdiesel.zsh"

  "$XDG_CONFIG_HOME/fzf/config.sh"
  "$XDG_CONFIG_HOME/op/plugins.sh"
  "$XDG_CONFIG_HOME/atuin/mappings/zsh"
)

# Initialize shell plugin manager & load plugins + configs
source "$XDG_DATA_HOME/zap/zap.zsh" && for tool in "$zsh_plugins[@]"; do plug "$tool"; done
