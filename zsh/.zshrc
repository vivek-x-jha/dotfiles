# Author: Vivek Jha

p10k_inst_prompt="$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
[[ ! -r $p10k_inst_prompt ]] || source $p10k_inst_prompt

source "$XDG_CONFIG_HOME/homebrew/.brew"
[[ "$PATH" == */Library/TeX/texbin* ]] || export PATH=$PATH:/Library/TeX/texbin

HISTFILE="$XDG_CACHE_HOME/zsh/.zsh_history"
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
    "$ZDOTDIR/zsh-plugins/zsh-completions/src"
    "$ZDOTDIR/zsh-autoload"
    "$ZDOTDIR/zsh-functions"
    "${fpath[@]}"
)
autoload -Uz compinit; compinit
autoload -Uz colors && colors
autoload -Uz downloadRepos
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

source "$ZDOTDIR/.zshaliases"

export ZSH_THEME=powerlevel10k
source "$HOMEBREW_PREFIX/share/$ZSH_THEME/$ZSH_THEME.zsh-theme"
source "$ZDOTDIR/themes/$ZSH_THEME/p10k.conf"

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"

export DIRCOLORS_THEME=sourdiesel
source "$XDG_CONFIG_HOME/dircolors/dircolors.conf"

export GREP_COLOR='38;5;11'

export YSU_MESSAGE_FORMAT="${YELLOW}[ysu reminder]${NONE}: \
${BLUE}%alias_type ${PINK}%alias${WHITE}=${GREEN}'%command'${NONE}"

export SYNTAX_THEME=sourdiesel
source "$XDG_CONFIG_HOME/syntax-highlighting/syntax-highlighting.conf"

source "$ZDOTDIR/zsh-completions.zsh"

export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonstartup.py"

export VIMINIT=":set runtimepath^=~/.config/vim/.vim|:source ~/.config/vim/.vimrc"

export MYSQL_HISTFILE=~/.cache/mysql/.mysql_history
export MYCLI_HISTFILE=~/.cache/mycli/.mycli-history

source "$XDG_CONFIG_HOME/fzf/.fzf"
