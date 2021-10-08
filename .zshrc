#####################################################################################
# Filename:     /Users/vivekjha/.zshrc
# Purpose:      config file for zsh (z shell)                     
# Author:       Vivek Jha
#####################################################################################

P10K_INST_PROMPT="${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
[[ ! -r $P10K_INST_PROMPT ]] || source $P10K_INST_PROMPT

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    aliases
    colored-man-pages
    colorize
    common-aliases
    extract
    git
    sudo
    vscode
    vundle
    zsh-z
)

source "$ZSH/oh-my-zsh.sh"

# Load utility functions: $HOME/dotfiles/utilities.zsh
initialize_conda
initialize_p10k
