# ··················································
# Author: Vivek Jha
# Last Modified: Jun 2, 2024
# ··················································

# Powerlevel10k Instant Prompt
# p10k_inst_prompt="$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
# [[ ! -r $p10k_inst_prompt ]] || source $p10k_inst_prompt

# Zsh History Management
HISTFILE="$XDG_CACHE_HOME/zsh/.zhistory"
HISTSIZE=12000
SAVEHIST=10000

# Zsh Options
setopt always_to_end
setopt append_history
setopt auto_cd
setopt auto_menu
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
setopt menu_complete
setopt share_history

# Configure PATH
[[ "$PATH" == */opt/homebrew/bin* ]] || eval "$(/opt/homebrew/bin/brew shellenv)"
[[ "$PATH" == */Library/TeX/texbin* ]] || export PATH=$PATH:/Library/TeX/texbin
[[ "$PATH" == *$fzf/bin* ]] || export PATH="${PATH:+${PATH}:}$fzf/bin"

# Configure FPATH
fpath=(
  "$HOMEBREW_PREFIX/share/zsh-completions"
  "$ZDOTDIR/functions"
  "${fpath[@]}"
)

# Autoload Completions, Color, & Custom functions
autoload -Uz compinit; compinit
autoload -Uz colors && colors
for func in $ZDOTDIR/functions/*; do autoload -Uz $(basename $func); done

# Set SQL HISTORY
export MYSQL_HISTFILE=~/.cache/mysql/.mysql_history
export MYCLI_HISTFILE=~/.cache/mycli/.mycli-history

# PYTHON STARTUP
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonstartup.py"

# Custom COMPLETION CACHE and SSH known hosts
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.config/ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# Load ALIASES
source "$ZDOTDIR/.zaliases"

# Set LS and EZA
source "$XDG_CONFIG_HOME/eza/eza-colors.conf"
eval "$("$gnubin/dircolors" "$XDG_CONFIG_HOME/dircolors/sourdiesel.conf")"

# Set GREP color 
export GREP_COLOR="38;5;2"

# Set PROMPT
source "$ZDOTDIR/.p10k.zsh"
# eval "$(starship init zsh)"

# LOAD CORE PLUGINS
source "$HOMEBREW_PREFIX/share/z.lua/z.lua.plugin.zsh"
source "$HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"

source "$XDG_CONFIG_HOME/syntax-highlighting/sourdiesel.zsh"

# LOAD 2nd Tier PLUGINS
source "$ZDOTDIR/plugins/colored-man-pages.plugin.zsh"
source "$ZDOTDIR/plugins/sudo.plugin.zsh"

export YSU_MESSAGE_FORMAT="$fg[yellow][ysu reminder]$reset_color: $fg[magenta]%alias_type $fg[green]%alias$fg[white]=$fg[red]'%command'$reset_color"
source "$HOMEBREW_PREFIX/share/zsh-you-should-use/you-should-use.plugin.zsh"

