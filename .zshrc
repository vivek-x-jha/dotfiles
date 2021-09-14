#####################################################################################
# Filename:     /Users/vivekjha/.zshrc
# Purpose:      config file for zsh (z shell)                     
# Author:       Vivek Jha
#####################################################################################

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
P10K_INST_PROMPT="${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
[[ -r $P10K_INST_PROMPT ]] || . $P10K_INST_PROMPT

export PATH=$HOME/bin:$PATH
export ZSH=~/.oh-my-zsh
export CONDA=/usr/local/anaconda3

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    aliases
    colorize
    common-aliases
    extract
    git
    sudo
    vscode
    vundle
    z
    zsh_reload
)

. $ZSH/oh-my-zsh.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$CONDA/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$CONDA/etc/profile.d/conda.sh" ]; then
        . "$CONDA/etc/profile.d/conda.sh"
    else
        export PATH="$CONDA/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || . ~/.p10k.zsh
