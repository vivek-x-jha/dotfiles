# ··················································
# Author: Vivek Jha
# Last Modified: Jun 11, 2024
# ··················································

# Initialize Instant Prompt
p10k_inst_prompt="$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
[[ ! -r $p10k_inst_prompt ]] || source $p10k_inst_prompt

# Configure Shell History
HISTFILE="$XDG_CACHE_HOME/zsh/.zhistory"
HISTSIZE=12000
SAVEHIST=10000

# Configure Shell Options
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
[[ -z $TMUX ]] || { PATH=''; eval "$(/usr/libexec/path_helper -s)" }
[[ "$PATH" == */opt/homebrew/bin* ]] || eval "$(/opt/homebrew/bin/brew shellenv)"
[[ "$PATH" == */Library/TeX/texbin* ]] || export PATH=$PATH:/Library/TeX/texbin
[[ "$PATH" == */Applications/iTerm.app/Contents/Resources/utilities* ]] || export PATH=$PATH:/Applications/iTerm.app/Contents/Resources/utilities

# Configure FPATH
fpath=("$HOMEBREW_PREFIX/share/zsh-completions" "$ZDOTDIR/functions" "${fpath[@]}")

# Initialize completion and lazy load all user defined functions/widgets
autoload -Uz compinit; compinit
for alias in $ZDOTDIR/aliases/*; do source $alias; done
for func in $ZDOTDIR/functions/*; do autoload -Uz $(basename $func); done
# for widget in $ZDOTDIR/widgets/*; do autoload -Uz $(basename $widget); done

# Custom COMPLETION CACHE and SSH known hosts
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.config/ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# Configure Prompt
source "$ZDOTDIR/.p10k.zsh"

# Load Plugins
source "$HOMEBREW_PREFIX/share/z.lua/z.lua.plugin.zsh"
source "$HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"

source "$XDG_CONFIG_HOME/syntax-highlighting/sourdiesel.zsh"

# Configure colorschemes for EZA, LS, and GREP
source "$XDG_CONFIG_HOME/eza/eza-colors.conf"
eval "$(gdircolors "$XDG_CONFIG_HOME/dircolors/sourdiesel.conf")"
export GREP_COLOR="38;5;3"

# Configure SQL History
export MYSQL_HISTFILE=~/.cache/mysql/.mysql_history
export MYCLI_HISTFILE=~/.cache/mycli/.mycli-history

# Configure Python Initialization
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonstartup.py"
