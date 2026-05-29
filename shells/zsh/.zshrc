# https://zsh.sourceforge.io/
# shellcheck shell=zsh

# Instant Prompt
source "$XDG_CACHE_HOME/p10k/p10k-instant-prompt-$USER.zsh" 2>/dev/null

# Colorscheme
source "$SHELL_CONFIG/colors/$SHELL_THEME"

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

# Plugin Manager
source "$XDG_DATA_HOME/zap/zap.zsh"

# Color ls + eza
dircolors_bin="$(command -v dircolors || command -v gdircolors)"
eval "$("$dircolors_bin" "$XDG_CONFIG_HOME/eza/.dircolors")"

# Prompt
{
  local XDG_CACHE_HOME="$XDG_CACHE_HOME/p10k"
  plug romkatv/powerlevel10k && source "$ZDOTDIR/.p10k.zsh"
  export XDG_CACHE_HOME="$HOME/.cache"
}

# Auto-complete
plug marlonrichert/zsh-autocomplete || {
  autoload -Uz compinit
  compinit -d "$XDG_CACHE_HOME/zsh/.zcompdump"
}

zstyle ':completion:*:unambiguous' format \
  $'%{\e[0;2m%}%Bcommon substring:%b %{\e[0m%}%{\e[38;5;1m%}%d%{\e[0m%}'

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
  zsh_completion_colors=(${(s.:.)LS_COLORS} 'ma=00;38;5;14')

  zstyle ':completion:*:default' list-colors "${zsh_completion_colors[@]}"
  zstyle ':completion:*' use-cache on
  zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
  zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts \
    'reply=(${=${${(f)"$(cat /etc/ssh_hosts ~/.config/ssh/known_hosts 2>/dev/null)"}%%[# ]*}//,/ })'
}

# Functions
fpath=("$ZDOTDIR/funcs" "${fpath[@]}")
export FPATH
for fn in "$ZDOTDIR/funcs"/*(.N:t); do autoload -Uz "$fn"; done

# Aliases
source "$SHELL_CONFIG/aliases"

# Fuzzy finder
source <(fzf --zsh) && source "$XDG_CONFIG_HOME/fzf/fzf.sh"

# Command history
eval "$(atuin init zsh)" && {
  bindkey -M vicmd '^r' atuin-search
  bindkey -M vicmd '^[[A' atuin-up-search
  bindkey -M vicmd '^[OA' atuin-up-search
}

# Directory jumper
eval "$(zoxide init zsh)" && bindkey -s '^p' 'zi\n'

# Keybindings
bindkey -s '^o' 'exec zsh\n'
bindkey -s '^[l' 'clear\n'
bindkey -s '^n' '"$EDITOR" -S Session.vim\n'
bindkey -s '^g' 'glg -5\n'

# Syntax-highlighting
plug zsh-users/zsh-syntax-highlighting
