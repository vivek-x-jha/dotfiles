# Author: Vivek Jha

# Powerlevel10k Instant Prompt
p10k_inst_prompt="$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
[[ ! -r $p10k_inst_prompt ]] || source $p10k_inst_prompt

# Zsh History Management
HISTFILE="$XDG_CACHE_HOME/zsh/.zhistory"
HISTSIZE=12000
SAVEHIST=10000

# Zsh Options
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

# Configure PATH
source "$XDG_CONFIG_HOME/homebrew/brew.conf"
[[ "$PATH" == */Library/TeX/texbin* ]] || export PATH=$PATH:/Library/TeX/texbin

# Configure FPATH
fpath=(
  "$HOMEBREW_PREFIX/share/zsh-completions"
  "$ZDOTDIR/functions"
  "${fpath[@]}"
)

# Autoload Completions, Color, & Custom functions
autoload -Uz compinit; compinit
autoload -Uz colors && colors
autoload -Uz condainit
autoload -Uz take

# Configure plugin/tool environment variables
export MYSQL_HISTFILE=~/.cache/mysql/.mysql_history
export MYCLI_HISTFILE=~/.cache/mycli/.mycli-history
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonstartup.py"
export SYNTAX_THEME=sourdiesel
export DIRCOLORS_THEME=sourdiesel
export GREP_COLOR='38;5;10'
export YSU_MESSAGE_FORMAT="$fg[yellow][ysu reminder]$reset_color: \
$fg[magenta]%alias_type $fg[green]%alias$fg[white]=$fg[red]'%command'$reset_color"

# Load plugins
source "$ZDOTDIR/.zaliases"
source "$ZDOTDIR/completions.conf"
source "$ZDOTDIR/plugins/colored-man-pages.plugin.zsh"
source "$ZDOTDIR/plugins/sudo.plugin.zsh"
source "$ZDOTDIR/themes/p10k.conf"
source "$HOMEBREW_PREFIX/share/z.lua/z.lua.plugin.zsh"
source "$HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-you-should-use/you-should-use.plugin.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$XDG_CONFIG_HOME/syntax-highlighting/syntax-highlighting.conf"
source "$XDG_CONFIG_HOME/sourdiesel/colorscheme.zsh"
source "$XDG_CONFIG_HOME/dircolors/dircolors.conf"
source "$XDG_CONFIG_HOME/fzf/fzf.conf"

