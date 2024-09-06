# Invoke Instant Prompt
[[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"

# History
HISTFILE="$XDG_CACHE_HOME/zsh/.zhistory"
HISTSIZE=12000
SAVEHIST=10000

export MYSQL_HISTFILE="$XDG_CACHE_HOME/mysql/.mysql_history"
export MYCLI_HISTFILE="$XDG_CACHE_HOME/mycli/.mycli-history"

# Completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.dotfiles/ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# Set PATH and FPATH without duplicating any directories
[[ -z $TMUX ]] || { PATH=''; eval "$(/usr/libexec/path_helper -s)" }
[[ $PATH == *$HOMEBREW_BIN* ]] || eval "$($HOMEBREW_BIN/brew shellenv)"
[[ $PATH == */Library/Frameworks/Python.framework/Versions/3.12/bin* ]] || export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:$PATH" 
[[ $PATH == */Library/TeX/texbin* ]] || export PATH="$PATH:/Library/TeX/texbin"
[[ $PATH == */Applications/iTerm.app/Contents/Resources/utilities* ]] || export PATH="$PATH:/Applications/iTerm.app/Contents/Resources/utilities"

[ -d "$(brew --prefix)/share/zsh-completions" ] || brew install zsh-completions
fpath=("$(brew --prefix)/share/zsh-completions" "$ZDOTDIR/functions" "${fpath[@]}")

# Configure Colorschmes: ls/eza/grep
command -v gdircolors &>/dev/null || brew install coreutils
eval "$(gdircolors "$DOT/.dircolors")"
source "$DOT/.ezacolors"
source "$DOT/.grepcolors"

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
  .p10k.zsh                 # Powerlevel10k config
  .zaliases
  .zsh-syntax-highlighting
)
for config in "${zsh_configs[@]}"; do source "$ZDOTDIR/$config"; done

# Configure shell options
zsh_options=(
  always_to_end
  auto_cd
  extended_history
  hist_expire_dups_first
  hist_ignore_dups
  hist_ignore_space
  inc_append_history
  interactive_comments
  share_history
)
setopt "${zsh_options[@]}" 

# Autoload shell functions
for func in "$ZDOTDIR/functions/"*; do autoload -Uz "$(basename "$func")"; done

# Configure fzf and enable shell integration
command -v fzf &>/dev/null || brew install fzf 
source <(fzf --zsh)
source "$DOT/.fzfrc"

# Configure z.lua
[ -d "$(brew --prefix)/share/z.lua" ] || brew install z.lua
eval "$(lua "$(brew --prefix)/share/z.lua/z.lua" --init zsh enhanced once fzf)"

# Initialize Python nvi
export PYTHONSTARTUP="$DOT/.pythonstartup"
