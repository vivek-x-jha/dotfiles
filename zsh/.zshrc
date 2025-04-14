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

# Auto-plugins
plug marlonrichert/zsh-autocomplete
plug hlissner/zsh-autopair
plug zsh-users/zsh-autosuggestions

# Completions
plug zsh-users/zsh-completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.dotfiles/ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

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

# Reload zsh
bindkey -s '^o' 'exec "$(brew --prefix)/bin/zsh"\n'

# Keybindings
# https://github.com/zsh-users/zsh-autosuggestions?tab=readme-ov-file#key-bindings
bindkey '^e' autosuggest-accept
bindkey '^y' autosuggest-execute
bindkey -s '^[l' 'clear\n'
bindkey -s '^p' 'ji\n' # Zoxide interactive
bindkey -s '^n' '"$EDITOR" -S Session.vim\n'
bindkey -M vicmd '^r' atuin-search
bindkey -M vicmd '^[[A' atuin-up-search
bindkey -M vicmd '^[OA' atuin-up-search

# Syntax-highlighting
plug zsh-users/zsh-syntax-highlighting

ZSH_HIGHLIGHT_STYLES['unknown-token']=fg=red
ZSH_HIGHLIGHT_STYLES['reserved-word']=fg=magenta
ZSH_HIGHLIGHT_STYLES['alias']=fg=green
ZSH_HIGHLIGHT_STYLES['suffix-alias']=fg=green
ZSH_HIGHLIGHT_STYLES['global-alias']=fg=green
ZSH_HIGHLIGHT_STYLES['builtin']=fg=green
ZSH_HIGHLIGHT_STYLES['function']=fg=green
ZSH_HIGHLIGHT_STYLES['command']=fg=green
ZSH_HIGHLIGHT_STYLES['precommand']=fg=magenta
ZSH_HIGHLIGHT_STYLES['commandseparator']=fg=black
ZSH_HIGHLIGHT_STYLES['hashed-command']=fg=black
ZSH_HIGHLIGHT_STYLES['autodirectory']=fg=blue
ZSH_HIGHLIGHT_STYLES['path']=fg=blue
ZSH_HIGHLIGHT_STYLES['path_pathseparator']=fg=black
ZSH_HIGHLIGHT_STYLES['path_prefix']=fg=red
ZSH_HIGHLIGHT_STYLES['path_prefix_pathseparator']=
ZSH_HIGHLIGHT_STYLES['globbing']=fg=white
ZSH_HIGHLIGHT_STYLES['history-expansion']=fg=magenta
ZSH_HIGHLIGHT_STYLES['command-substitution']=fg=yellow
ZSH_HIGHLIGHT_STYLES['command-substitution-unquoted']=fg=yellow
ZSH_HIGHLIGHT_STYLES['command-substitution-quoted']=fg=yellow
ZSH_HIGHLIGHT_STYLES['command-substitution-delimiter']=fg=blue
ZSH_HIGHLIGHT_STYLES['command-substitution-delimiter-unquoted']=fg=blue
ZSH_HIGHLIGHT_STYLES['command-substitution-delimiter-quoted']=fg=blue
ZSH_HIGHLIGHT_STYLES['process-substitution']=fg=yellow
ZSH_HIGHLIGHT_STYLES['process-substitution-delimiter']=fg=blue
ZSH_HIGHLIGHT_STYLES['arithmetic-expansion']=fg=yellow
ZSH_HIGHLIGHT_STYLES['single-hyphen-option']=fg=11
ZSH_HIGHLIGHT_STYLES['double-hyphen-option']=fg=11
ZSH_HIGHLIGHT_STYLES['back-quoted-argument']=fg=yellow
ZSH_HIGHLIGHT_STYLES['back-quoted-argument-unclosed']=fg=red
ZSH_HIGHLIGHT_STYLES['back-quoted-argument-delimiter']=fg=blue
ZSH_HIGHLIGHT_STYLES['single-quoted-argument']=fg=yellow
ZSH_HIGHLIGHT_STYLES['single-quoted-argument-unclosed']=fg=red
ZSH_HIGHLIGHT_STYLES['double-quoted-argument']=fg=yellow
ZSH_HIGHLIGHT_STYLES['double-quoted-argument-unclosed']=fg=red
ZSH_HIGHLIGHT_STYLES['dollar-quoted-argument']=fg=yellow
ZSH_HIGHLIGHT_STYLES['dollar-quoted-argument-unclosed']=fg=red
ZSH_HIGHLIGHT_STYLES['rc-quote']=fg=yellow
ZSH_HIGHLIGHT_STYLES['dollar-double-quoted-argument']=fg=black,bold
ZSH_HIGHLIGHT_STYLES['back-double-quoted-argument']=fg=black,bold
ZSH_HIGHLIGHT_STYLES['back-dollar-quoted-argument']=fg=black,bold
ZSH_HIGHLIGHT_STYLES['assign']=fg=white
ZSH_HIGHLIGHT_STYLES['redirection']=fg=white
ZSH_HIGHLIGHT_STYLES['comment']=fg=black
ZSH_HIGHLIGHT_STYLES['named-fd']=fg=yellow
ZSH_HIGHLIGHT_STYLES['numeric-fd']=fg=yellow
ZSH_HIGHLIGHT_STYLES['arg0']=fg=yellow
