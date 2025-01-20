# https://zsh.sourceforge.io/

# Invoke instant prompt
[[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"

# Configure history options
HISTFILE="$XDG_CACHE_HOME/zsh/.zhistory"
HISTSIZE=12000
SAVEHIST=10000

# Cache common completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.dotfiles/ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# Set PATH and FPATH without duplicating any directories
[[ -z $TMUX ]] || { PATH=''; eval "$(/usr/libexec/path_helper -s)" }
[[ $PATH == *$HOMEBREW_BIN* ]] || eval "$($HOMEBREW_BIN/brew shellenv)"
[[ $PATH == */Library/Frameworks/Python.framework/Versions/3.13/bin* ]] || export PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:$PATH" 
[[ $PATH == */Library/TeX/texbin* ]] || export PATH="$PATH:/Library/TeX/texbin"
[[ $PATH == */Applications/iTerm.app/Contents/Resources/utilities* ]] || export PATH="$PATH:/Applications/iTerm.app/Contents/Resources/utilities"

[ -d "$(brew --prefix)/share/zsh-completions" ] || brew install zsh-completions
fpath=("$(brew --prefix)/share/zsh-completions" "$ZDOTDIR/functions" "${fpath[@]}")

# Load secrets
[ -f "$DOT/.env" ] && source "$DOT/.env"

# Set shell options
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

# Load shell plugins
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

# Configure syntax highlighting theme
source "$ZDOTDIR/.zsh-syntax-highlighting"

# Load prompt theme
[ -f "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" ] || brew install powerlevel10k
source "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme"
source "$ZDOTDIR/.p10k.zsh"

# Load aliases
source "$ZDOTDIR/.zaliases"

# Autoload shell functions
for func in "$ZDOTDIR/functions/"*; do autoload -Uz "$(basename "$func")"; done

# Configure tree and ls: sets LS_COLORS
command -v gdircolors &> /dev/null || brew install coreutils
eval "$(gdircolors "$DOT/.dircolors")"

# Configure eza: sets EZA_COLORS
source "$DOT/.ezarc"

# Configure grep: sets GREP_COLOR
source "$DOT/.greprc"

# Configure fzf and enable shell integration
command -v fzf &> /dev/null || brew install fzf
source <(fzf --zsh)
source "$DOT/.fzfrc"

# Configure atuin
command -v atuin &> /dev/null || brew install atuin
eval "$(atuin init zsh)"
bindkey '^e' atuin-search
bindkey '^[[A' atuin-up-search

# Configure 1Password plugins
source "$XDG_CONFIG_HOME/op/plugins.sh"

# Configure z.lua
[ -d "$(brew --prefix)/share/z.lua" ] || brew install z.lua
eval "$(lua "$(brew --prefix)/share/z.lua/z.lua" --init zsh enhanced once)"
