#!/bin/zsh

# Create dotfiles directory in $HOME
DOT="${HOME:-$(pwd)}/dotfiles"
[[ -d $DOT ]] || mkdir "$DOT"

create_symlinks () {
    local symlink_array=$1
    local destination="$2"

    for file in "${symlink_array[@]}"
    do
        # [[ ! -f $DOT/$file ]] || ln -s "$DOT/$file" "$destination/$file"
        echo "$destination/$file"
    done
}

# Create symbolic links in $HOME
local home_symlinks=(
    .bash_history
    .bash_profile
    .cache
    .conda
    .config
    .dropbox
    .gitconfig
    .gitignore_global
    .hushlogin
    .ipython
    .jupyter
    .matplotlib
    .npm
    .p10k.zsh
    .pylint.d
    .python_history
    .pythonhist
    .ssh
    .thinkorswim
    .vim
    .viminfo
    .vimrc
    .vimrc_og
    .vscode
    .z
    .zsh_history
    .zsh_sessions
    .zshrc
)

create_symlinks $home_symlinks $HOME
# for file in "${home_symlinks[@]}"
# do
#     [[ ! -f $DOT/$file ]] || ln -s "$DOT/$file" "$HOME/$file"
# done

# local omz_symlinks=(
#     omz_functions.zsh
#     omz_aliases
# )

# for file in "${omz_symlinks[@]}"
# do
#     [[ ! -f $DOT/$file ]] || ln -s "$DOT/$file" "$ZSH_CUSTOM/$file"
# done

