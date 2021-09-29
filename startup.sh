#!/bin/zsh

# Create dotfiles directory in $HOME
DOT="${HOME:-$(pwd)}/dotfiles"
[[ -d $DOT ]] || mkdir "$DOT"

# Create symbolic links in $HOME
local links=(
    .zshrc
    utilities.zsh
    .gitignore_global
    .gitconfig
    .hushlogin
    .p10k.zsh
    .ssh
    .thinkorswim
)

for file in "${links[@]}"
do
    [[ ! -f $DOT/$file ]] || ln -s "$DOT/$file" "$HOME/$file"
done
