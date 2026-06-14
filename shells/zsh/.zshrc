# https://zsh.sourceforge.io/
# shellcheck shell=zsh

# Instant Prompt
inst_prompt="$XDG_CACHE_HOME/p10k/p10k-instant-prompt-$USER.zsh"
[[ -r $inst_prompt ]] && source "$inst_prompt"

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

# Completion/function lookup path
fpath=("$ZDOTDIR/comps" "$ZDOTDIR/funcs" "${fpath[@]}")
export FPATH

# Plugin Manager
source "$XDG_DATA_HOME/zap/zap.zsh"

# Zsh core helpers
zmodload zsh/terminfo
autoload -Uz add-zsh-hook add-zle-hook-widget is-at-least zmathfunc

# Completions
plug zsh-users/zsh-completions
plug marlonrichert/zsh-autocomplete || {
  autoload -Uz compinit
  compinit -d "$XDG_CACHE_HOME/zsh/.zcompdump"
}

source "$ZDOTDIR/completion/styles"
eval "$(zsh-patina completion)"

# Prompt
{
  local XDG_CACHE_HOME="$XDG_CACHE_HOME/p10k"
  plug romkatv/powerlevel10k && source "$ZDOTDIR/.p10k.zsh"
  export XDG_CACHE_HOME="$HOME/.cache"
}

# Color ls + eza
dircolors_bin="$(command -v dircolors || command -v gdircolors)"
eval "$("$dircolors_bin" "$XDG_CONFIG_HOME/eza/.dircolors")"

# Interactive plugins
source "$XDG_CONFIG_HOME/fzf/fzf.sh" && eval "$(fzf --zsh)"
plug hlissner/zsh-autopair
plug zsh-users/zsh-autosuggestions

# Functions
for fn in "$ZDOTDIR/funcs"/*(.N:t); do autoload -Uz "$fn"; done

# Aliases
source "$SHELL_CONFIG/aliases"

# Command history
eval "$(atuin init zsh --disable-ai)" &&
  source "$ZDOTDIR/patches/atuin-zsh-tty-capture.zsh" && {
  export ATUIN_TMUX_POPUP=false
}

# Directory jumper
eval "$(zoxide init zsh)"

# Keymaps
source "$ZDOTDIR/keymaps/main"

# Syntax highlighting
eval "$(zsh-patina activate)"
