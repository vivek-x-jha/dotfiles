#!/usr/bin/env bash

symlink() {

  # Home Symlinks
  cd $HOME

  [ -d $HOME/Dropbox   ] || ln -sF Library/CloudStorage/Dropbox
  [ -d $HOME/Developer ] || ln -sF Dropbox/developer Developer

  ln -sf dotfiles/conda/.anaconda
  ln -sf dotfiles/bash/.bashrc
  ln -sf dotfiles/conda/.conda
  ln -sf dotfiles/conda/.condarc
  ln -sf dotfiles/conda/.continuum
  ln -sf dotfiles/cricut/.cricut-design-space
  ln -sf dotfiles/git/.gitconfig
  ln -sf dotfiles/ipython/.ipython
  ln -sf dotfiles/keras/.keras
  ln -sf dotfiles/matplotlib/.matplotlib
  ln -sf dotfiles/npm/.npm
  ln -sf dotfiles/redhat/.redhat
  ln -sf dotfiles/thinkorswim/.thinkorswim
  ln -sf dotfiles/vscode/.vscode
  ln -sf dotfiles/zsh/.zshenv 
  ln -sf dotfiles/zsh/.zprofile

  # Configuation Symlinks
  cd ${XDG_CONFIG_HOME:-$HOME/.config}
  
  config_pkgs=(
    bat
    bpython
    btop
    dust
    gh
    git
    jupyter
    lazygit
    nvim
    op
    ssh
    tmux
    yazi
  )

  for pkg in "${config_pkgs[@]}"; do
    rm -rf "$pkg"
    ln -sF "../dotfiles/$pkg"
  done

}

main() {

  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  
  symlink

  cd "$SCRIPT_DIR"
  echo "[TUI SETUP SUCCESS - 3/3]"  
}

main
