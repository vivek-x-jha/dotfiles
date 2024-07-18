#!/usr/bin/env bash

symlink() {

  # Home Symlinks
  cd $HOME

  [ -d $HOME/Dropbox   ] || ln -sF Library/CloudStorage/Dropbox
  [ -d $HOME/Developer ] || ln -sF Dropbox/developer Developer

  ln -sF dotfiles/conda/.anaconda
  ln -sF dotfiles/bash/.bashrc
  ln -sF dotfiles/conda/.conda
  ln -sF dotfiles/conda/.condarc
  ln -sF dotfiles/conda/.continuum
  ln -sF dotfiles/cricut/.cricut-design-space
  ln -sF dotfiles/ipython/.ipython
  ln -sF dotfiles/keras/.keras
  ln -sF dotfiles/matplotlib/.matplotlib
  ln -sF dotfiles/npm/.npm
  ln -sF dotfiles/redhat/.redhat
  ln -sF dotfiles/thinkorswim/.thinkorswim
  ln -sF dotfiles/vscode/.vscode
  ln -sF dotfiles/zsh/.zshenv 
  ln -sF dotfiles/zsh/.zprofile

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
