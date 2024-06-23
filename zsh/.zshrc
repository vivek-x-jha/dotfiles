# ·············································································
# SHELL-CONFIGURATION:
# - Instant Prompt
# - History
# - Options
# - PATH/FPATH
# - Completions
# - Aliases
# - Functions
# - Widgets
# - Prompt
# - Plugins
# ·············································································

[[ ! -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]] || source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"

HISTFILE="$XDG_CACHE_HOME/zsh/.zhistory"
HISTSIZE=12000
SAVEHIST=10000

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

[[ -z $TMUX ]] || { PATH=''; eval "$(/usr/libexec/path_helper -s)" }
[[ "$PATH" == */opt/homebrew/bin* ]] || eval "$(/opt/homebrew/bin/brew shellenv)"
[[ "$PATH" == */Library/TeX/texbin* ]] || export PATH=$PATH:/Library/TeX/texbin
[[ "$PATH" == */Applications/iTerm.app/Contents/Resources/utilities* ]] || export PATH=$PATH:/Applications/iTerm.app/Contents/Resources/utilities
fpath=("$HOMEBREW_PREFIX/share/zsh-completions" "$ZDOTDIR/functions" "${fpath[@]}")

autoload -Uz compinit; compinit
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.config/ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

for alias in $ZDOTDIR/aliases/*; do source $alias; done
for func in $ZDOTDIR/functions/*; do autoload -Uz $(basename $func); done
for widget in $ZDOTDIR/widgets/*; do source $widget; done

source "$ZDOTDIR/themes/powerlevel10k"

source "$HOMEBREW_PREFIX/share/z.lua/z.lua.plugin.zsh"
source "$HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" && source "$XDG_CONFIG_HOME/syntax-highlighting/sourdiesel.zsh"
source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"

# ·············································································
# OTHER CONFIGURATION:
# - eza
# - dircolors
# - grep
# - mysql/mycli
# - python
# ·············································································

source "$XDG_CONFIG_HOME/eza/eza-colors.conf"
eval "$(gdircolors "$XDG_CONFIG_HOME/dircolors/sourdiesel.conf")"
export GREP_COLOR="38;5;3"
export MYSQL_HISTFILE=~/.cache/mysql/.mysql_history
export MYCLI_HISTFILE=~/.cache/mycli/.mycli-history
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonstartup.py"
