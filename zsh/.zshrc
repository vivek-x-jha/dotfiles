# https://zsh.sourceforge.io/
# shellcheck shell=zsh

# Instant Prompt
_p10k_inst_prompt="$XDG_CACHE_HOME/p10k/p10k-instant-prompt-$USER.zsh"
[[ -r $_p10k_inst_prompt ]] && source "$_p10k_inst_prompt"

# History
HISTFILE="$XDG_STATE_HOME/zsh/.zsh_history"
HISTSIZE=12000
SAVEHIST=10000

# Options
zsh_opts=(
  extendedhistory
  histexpiredupsfirst
  histignoredups
  histignorespace
  incappendhistory
  sharehistory
  autocd
  interactivecomments
)
setopt "${zsh_opts[@]}"

# PATH + Secrets
source "$ZDOTDIR/.zprofile"

# Plugin Manager
source "$XDG_DATA_HOME/zap/zap.zsh"

# Prompt
{
  local XDG_CACHE_HOME="$XDG_CACHE_HOME/p10k"
  plug romkatv/powerlevel10k && source "$ZDOTDIR/.p10k.zsh"
}

# Plugins
plug marlonrichert/zsh-autocomplete
plug hlissner/zsh-autopair
plug zsh-users/zsh-autosuggestions
plug zsh-users/zsh-completions && source "$ZDOTDIR/completions"
plug zsh-users/zsh-syntax-highlighting && source "$ZDOTDIR/highlights"

# Functions
fpath=("$ZDOTDIR/funcs" "${fpath[@]}")
export FPATH
for fn in "$ZDOTDIR/funcs"/*(.N:t); do autoload -Uz "$fn"; done

# Authenticate CLI tools w/ 1Password
source "$XDG_CONFIG_HOME/op/plugins.sh"

# Aliases
source "$ZDOTDIR/aliases"

# Color ls, tree, eza
eval "$(dircolors "$XDG_CONFIG_HOME/eza/.dircolors")"

# Fuzzy Finders
source <(fzf --zsh) && source "$XDG_CONFIG_HOME/fzf/config.sh"
eval "$(atuin init zsh)"
eval "$(zoxide init zsh --cmd j)"

# Keybindings
source "$ZDOTDIR/keymaps"
