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
command -v gdircolors &> /dev/null || brew install coreutils
eval "$(gdircolors "$DOT/.dircolors")"
source "$DOT/.ezacolors"
source "$DOT/.grepcolors"
source "$DOT/.colorscheme"

# Configure Shell Core Plugins
zsh_plugins=(
  autocomplete
  autopair
  autosuggestions
  syntax-highlighting
)

for plugin in "${zsh_plugins[@]}"; do
  [ -d "$(brew --prefix)/share/zsh-$plugin" ] || brew install "zsh-$plugin"
  source "$(brew --prefix)/share/zsh-$plugin/$plugin.zsh"
done

# Configure Shell Theme, Aliases, & Syntax-Highlighting
zsh_configs=(
  .p10k.zsh
  .zaliases
  .zsh-syntax-highlighting
)
for config in "${zsh_configs[@]}"; do source "$ZDOTDIR/$config"; done

# Configure Shell Options
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
setopt "${zsh_options[@]}" 

# Autoload Shell Functions
for func in "$ZDOTDIR/functions/"*; do autoload -Uz "$(basename "$func")"; done

# Enable Fuzzy Finder
command -v fzf &> /dev/null || brew install fzf 
source <(fzf --zsh)

# Enable Fast Directory Movement
[ -d "$(brew --prefix)/share/z.lua" ] || brew install z.lua
eval "$(lua "$(brew --prefix)/share/z.lua/z.lua" --init zsh enhanced once fzf)"

# Log Database History
export MYSQL_HISTFILE="$XDG_CACHE_HOME/mysql/.mysql_history"
export MYCLI_HISTFILE="$XDG_CACHE_HOME/mycli/.mycli-history"

# Initialize Python Environments
export PYTHONSTARTUP="$DOT/.pythonstartup"
