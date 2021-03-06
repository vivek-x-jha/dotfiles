#!/bin/zsh

initialize_conda () {
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/usr/local/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/usr/local/anaconda3/etc/profile.d/conda.sh" ]; then
            source "/usr/local/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="/usr/local/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
}

initialize_p10k () {
    [[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh
}

list () {
    local array=("$@")
    for f in "${array[@]}"
    do
        echo $f
    done
}

lnk () {
    local file="$1"
    mv $file ~/dotfiles/
    ln -s ~/dotfiles/$file ~
}