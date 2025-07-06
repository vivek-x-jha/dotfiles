# https://zsh.sourceforge.io/
# shellcheck shell=zsh

# Instant Prompt
source "$XDG_CACHE_HOME/p10k/p10k-instant-prompt-$USER.zsh" 2>/dev/null

# History
HISTFILE="$XDG_STATE_HOME/zsh/.zsh_history"
HISTSIZE=12000
SAVEHIST=10000

# Options
setopt extendedhistory
setopt histexpiredupsfirst
setopt histignoredups
setopt histignorespace
setopt incappendhistory
setopt sharehistory
setopt autocd

# PATH + Secrets
source "$ZDOTDIR/.zprofile"

# Plugin Manager
source "$XDG_DATA_HOME/zap/zap.zsh"

# Prompt
{
  local XDG_CACHE_HOME="$XDG_CACHE_HOME/p10k"
  plug romkatv/powerlevel10k && source "$ZDOTDIR/.p10k.zsh"
  export XDG_CACHE_HOME="$HOME/.cache"
}

# Auto-complete
plug marlonrichert/zsh-autocomplete

# Auto-pairs
plug hlissner/zsh-autopair

# Auto-suggestions
# https://github.com/zsh-users/zsh-autosuggestions?tab=readme-ov-file#key-bindings
plug zsh-users/zsh-autosuggestions && {
  bindkey '^e' autosuggest-accept
  bindkey '^y' autosuggest-execute
}

# Completions
plug zsh-users/zsh-completions && {
  zstyle ':completion:*' use-cache on
  zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
  zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.dotfiles/ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
}

# Functions
fpath=("$ZDOTDIR/funcs" "${fpath[@]}")
export FPATH
for fn in "$ZDOTDIR/funcs"/*(.N:t); do autoload -Uz "$fn"; done

# Aliases
source "$ZDOTDIR/aliases"

# Color ls, tree, eza
eval "$($(command -v dircolors || command -v gdircolors) "$XDG_CONFIG_HOME/eza/.dircolors")"

# Fuzzy finder
source <(fzf --zsh) && source "$XDG_CONFIG_HOME/fzf/config.sh"

# Command history
eval "$(atuin init zsh)" && {
  bindkey -M vicmd '^r' atuin-search
  bindkey -M vicmd '^[[A' atuin-up-search
  bindkey -M vicmd '^[OA' atuin-up-search
}

# Directory jumper
eval "$(zoxide init zsh --cmd j)" && bindkey -s '^p' 'ji\n'

# Keybindings
bindkey -s '^o' 'exec "$(which zsh)"\n'
bindkey -s '^[l' 'clear\n'
bindkey -s '^n' '"$EDITOR" -S Session.vim\n'

# Syntax-highlighting
plug zsh-users/zsh-syntax-highlighting && ZSH_HIGHLIGHT_STYLES=(
  ['unknown-token']='fg=red'
  ['reserved-word']='fg=magenta'
  ['alias']='fg=green'
  ['suffix-alias']='fg=green'
  ['global-alias']='fg=green'
  ['builtin']='fg=green'
  ['function']='fg=green'
  ['command']='fg=green'
  ['precommand']='fg=magenta'
  ['commandseparator']='fg=black'
  ['hashed-command']='fg=black'
  ['autodirectory']='fg=blue'
  ['path']='fg=blue'
  ['path_pathseparator']='fg=black'
  ['path_prefix']='fg=red'
  ['path_prefix_pathseparator']=''
  ['globbing']='fg=white'
  ['history-expansion']='fg=magenta'
  ['command-substitution']='fg=yellow'
  ['command-substitution-unquoted']='fg=yellow'
  ['command-substitution-quoted']='fg=yellow'
  ['command-substitution-delimiter']='fg=blue'
  ['command-substitution-delimiter-unquoted']='fg=blue'
  ['command-substitution-delimiter-quoted']='fg=blue'
  ['process-substitution']='fg=yellow'
  ['process-substitution-delimiter']='fg=blue'
  ['arithmetic-expansion']='fg=yellow'
  ['single-hyphen-option']='fg=11'
  ['double-hyphen-option']='fg=11'
  ['back-quoted-argument']='fg=yellow'
  ['back-quoted-argument-unclosed']='fg=red'
  ['back-quoted-argument-delimiter']='fg=blue'
  ['single-quoted-argument']='fg=yellow'
  ['single-quoted-argument-unclosed']='fg=red'
  ['double-quoted-argument']='fg=yellow'
  ['double-quoted-argument-unclosed']='fg=red'
  ['dollar-quoted-argument']='fg=yellow'
  ['dollar-quoted-argument-unclosed']='fg=red'
  ['rc-quote']='fg=yellow'
  ['dollar-double-quoted-argument']='fg=black,bold'
  ['back-double-quoted-argument']='fg=black,bold'
  ['back-dollar-quoted-argument']='fg=black,bold'
  ['assign']='fg=white'
  ['redirection']='fg=white'
  ['comment']='fg=black'
  ['named-fd']='fg=yellow'
  ['numeric-fd']='fg=yellow'
  ['arg0']='fg=yellow'
)
