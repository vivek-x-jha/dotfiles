# INSTANT PROMPT
[[ ! -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]] || source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"

# HISTORY
HISTFILE="$XDG_CACHE_HOME/zsh/.zhistory"
HISTSIZE=12000
SAVEHIST=10000

# OPTIONS
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

# COMPLETIONS
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.config/ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# PATH/FPATH
[[ -z $TMUX ]] || { PATH=''; eval "$(/usr/libexec/path_helper -s)" }
[[ $PATH == */opt/homebrew/bin* ]] || eval "$(/opt/homebrew/bin/brew shellenv)"
[[ $PATH == */Library/Frameworks/Python.framework/Versions/3.12/bin* ]] || export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:$PATH"
[[ $PATH == */Library/TeX/texbin* ]] || export PATH="$PATH:/Library/TeX/texbin"
[[ $PATH == */Applications/iTerm.app/Contents/Resources/utilities* ]] || export PATH="$PATH:/Applications/iTerm.app/Contents/Resources/utilities"

fpath=("$(brew --prefix)/share/zsh-completions" "$ZDOTDIR/functions" "${fpath[@]}")

# ALIASES/FUNCTIONS/WIDGETS
for alias in $ZDOTDIR/aliases/*; do source $alias; done
for func in $ZDOTDIR/functions/*; do autoload -Uz $(basename $func); done
# for widget in $ZDOTDIR/widgets/*; do source $widget; done

# LS/EZA/GREP and PROMPT THEME
eval "$(gdircolors "$DOT/dircolors/.dircolors")"

source "$DOT/eza/.eza_colors"
source "$DOT/grep/.grep_colors"
source "$DOT/.colorscheme"

source "$ZDOTDIR/.p10k.zsh"

# SHELL-PLUGINS
source "$(brew --prefix)/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
source "$(brew --prefix)/share/zsh-autopair/autopair.zsh"
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

source "$ZDOTDIR/syntaxes/sourdiesel.zsh"
source <(fzf --zsh)
eval "$(lua "$(brew --prefix)/share/z.lua/z.lua" --init zsh enhanced once fzf)"

# OTHER CONFIGURATION FILES
export MYSQL_HISTFILE=~/.cache/mysql/.mysql_history
export MYCLI_HISTFILE=~/.cache/mycli/.mycli-history
export PYTHONSTARTUP="$DOT/python/pythonstartup.py"
