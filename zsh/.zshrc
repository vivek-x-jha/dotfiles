# Author: Vivek Jha

p10k_inst_prompt="$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
[[ ! -r $p10k_inst_prompt ]] || source $p10k_inst_prompt

source "$XDG_CONFIG_HOME/homebrew/brew.conf"
[[ "$PATH" == */Library/TeX/texbin* ]] || export PATH=$PATH:/Library/TeX/texbin

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

fpath=(
    "$HOMEBREW_PREFIX/share/zsh-completions"
    "$ZDOTDIR/functions"
    "${fpath[@]}"
)
autoload -Uz compinit; compinit
autoload -Uz colors && colors
autoload -Uz condainit
autoload -Uz take

source "$ZDOTDIR/plugins/colored-man-pages.plugin.zsh"

source "$ZDOTDIR/plugins/sudo.plugin.zsh"

source "$HOMEBREW_PREFIX/share/z.lua/z.lua.plugin.zsh"

source "$HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

export YSU_MESSAGE_FORMAT="$fg[yellow][ysu reminder]$reset_color: \
$fg[blue]%alias_type $fg[magenta]%alias$fg[white]=$fg[green]'%command'$reset_color"
source "$HOMEBREW_PREFIX/share/zsh-you-should-use/you-should-use.plugin.zsh"

export SYNTAX_THEME=sourdiesel
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$XDG_CONFIG_HOME/syntax-highlighting/syntax-highlighting.conf"

source "$XDG_CONFIG_HOME/sourdiesel/colorscheme.zsh"
source "$ZDOTDIR/.zaliases"

export ZSH_THEME=p10k
source "$ZDOTDIR/themes/$ZSH_THEME.conf"

export DIRCOLORS_THEME=sourdiesel
source "$XDG_CONFIG_HOME/dircolors/dircolors.conf"

export GREP_COLOR='38;5;10'

source "$ZDOTDIR/completions.conf"

export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonstartup.py"

export MYSQL_HISTFILE=~/.cache/mysql/.mysql_history
export MYCLI_HISTFILE=~/.cache/mycli/.mycli-history

source "$XDG_CONFIG_HOME/fzf/fzf.conf"

