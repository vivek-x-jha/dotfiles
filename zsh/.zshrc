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
    "$ZDOTDIR/plugins/zsh-completions/src"
    "$ZDOTDIR/functions"
    "${fpath[@]}"
)
autoload -Uz compinit; compinit
autoload -Uz colors && colors
autoload -Uz condainit
autoload -Uz plug
autoload -Uz take

plug z.lua
plug zsh-autocomplete
plug zsh-autosuggestions
plug zsh-colored-man-pages
plug zsh-sudo
plug zsh-vscode
plug zsh-you-should-use
plug zsh-syntax-highlighting

# Initialize SOURDIESEL_COLORSCHEME assoc array: attribute -> hex code
source "$XDG_CONFIG_HOME/sourdiesel/colorscheme.zsh"
source "$ZDOTDIR/.zaliases"

export ZSH_THEME=p10k
source "$ZDOTDIR/themes/$ZSH_THEME.conf"

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"

export DIRCOLORS_THEME=sourdiesel
source "$XDG_CONFIG_HOME/dircolors/dircolors.conf"

export GREP_COLOR='38;5;11'

export YSU_MESSAGE_FORMAT="$fg[yellow][ysu reminder]$reset_color: \
$fg[blue]%alias_type $fg[magenta]%alias$fg[white]=$fg[green]'%command'$reset_color"

export SYNTAX_THEME=sourdiesel
source "$XDG_CONFIG_HOME/syntax-highlighting/syntax-highlighting.conf"

source "$ZDOTDIR/completions.conf"

export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonstartup.py"

export VIMINIT=":set runtimepath^=~/.config/vim/.vim|:source ~/.config/vim/.vimrc"

export MYSQL_HISTFILE=~/.cache/mysql/.mysql_history
export MYCLI_HISTFILE=~/.cache/mycli/.mycli-history

source "$XDG_CONFIG_HOME/fzf/fzf.conf"
