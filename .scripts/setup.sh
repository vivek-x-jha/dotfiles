#!/usr/bin/env bash

symlink() {

  cd $HOME

  ln -sF dotfiles/conda/.anaconda
  ln -sF dotfiles/bash/.bashrc
  ln -sF dotfiles/conda/.conda
  ln -sF dotfiles/conda/.condarc
  ln -sF dotfiles/conda/.continuum
  ln -sF dotfiles/cricut/.cricut-design-space
  ln -sF dotfiles/iterm2/.hushlogin
  ln -sF dotfiles/ipython/.ipython
  ln -sF dotfiles/keras/.keras
  ln -sF dotfiles/matplotlib/.matplotlib
  ln -sF dotfiles/npm/.npm
  ln -sF dotfiles/redhat/.redhat
  ln -sF dotfiles/thinkorswim/.thinkorswim
  ln -sF dotfiles/vscode/.vscode
  ln -sF dotfiles/zsh/.zshenv 
  ln -sF dotfiles/zsh/.zprofile

  ln -sF Library/CloudStorage/Dropbox
  ln -sF Dropbox/developer Developer

}

main() {

  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  
  symlink

  cd "$pwd"
  echo "[TUI SETUP SUCCESS - 3/3]"  
}

main
