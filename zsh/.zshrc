# INSTANT PROMPT
[[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"

# HISTORY
HISTFILE="$XDG_CACHE_HOME/zsh/.zhistory"
HISTSIZE=12000
SAVEHIST=10000

# COMPLETIONS
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.dotfiles/ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# Set PATH and FPATH without duplicating any directories
[[ -z $TMUX ]] || { PATH=''; eval "$(/usr/libexec/path_helper -s)" }
[[ $PATH == */opt/homebrew/bin* ]] || eval "$(/opt/homebrew/bin/brew shellenv)"
[[ $PATH == */Library/Frameworks/Python.framework/Versions/3.12/bin* ]] || export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:$PATH" 
[[ $PATH == */Library/TeX/texbin* ]] || export PATH="$PATH:/Library/TeX/texbin"
[[ $PATH == */Applications/iTerm.app/Contents/Resources/utilities* ]] || export PATH="$PATH:/Applications/iTerm.app/Contents/Resources/utilities"

fpath=("$(brew --prefix)/share/zsh-completions" "$ZDOTDIR/functions" "${fpath[@]}")

# Configure Colorschmes: ls/eza/grep + variables
eval "$(gdircolors "$DOT/.dircolors")"
source "$DOT/.ezacolors"
source "$DOT/.grepcolors"
source "$DOT/.colorscheme"

# Configure Shell Plugins, Theme, Aliases, Configs Functions
zsh_plugins=(
  zsh-autocomplete/zsh-autocomplete.plugin.zsh
  zsh-autopair/autopair.zsh
  zsh-autosuggestions/zsh-autosuggestions.zsh
  zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
)

zsh_configs=(
  .p10k.zsh
  .zaliases
  .zsh-syntax-highlighting.conf
)

zsh_options=(
  always_to_end
  auto_cd
  extended_history
  hist_expire_dups_first
  hist_ignore_dups
  hist_ignore_space
  inc_append_history
  share_history
)

for plugin in "${zsh_plugins[@]}"; do source "$(brew --prefix)/share/$plugin"; done
for config in "${zsh_configs[@]}"; do source "$ZDOTDIR/$config"; done
for func in "$ZDOTDIR/functions/"*; do autoload -Uz "$(basename "$func")"; done
setopt "${zsh_options[@]}" 

source <(fzf --zsh)
eval "$(lua "$(brew --prefix)/share/z.lua/z.lua" --init zsh enhanced once fzf)"

# OTHER CONFIGURATION FILES
export MYSQL_HISTFILE="$XDG_CACHE_HOME/mysql/.mysql_history"
export MYCLI_HISTFILE="$XDG_CACHE_HOME/mycli/.mycli-history"
export PYTHONSTARTUP="$DOT/.pythonstartup"
