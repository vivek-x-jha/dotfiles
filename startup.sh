#!/bin/zsh

DOT="{$HOME:-$(pwd)}/dotfiles"
[[ -d $DOT ]] || mkdir $DOT

[[ ! -f "$DOT/.zshrc" ]] ln -s "$DOT/.zshrc"
[[ ! -f "$DOT/utilities.zsh" ]] ln -s "$DOT/utilities.zsh"
