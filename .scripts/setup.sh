#!/usr/bin/env bash

symlink() {
  # Dropbox links
  cd $HOME/Movies
  
  ln -sF ../Dropbox/content

  cd $HOME/Pictures
  
  ln -sF ../Dropbox/icons
  ln -sF ../Dropbox/screenshots
  ln -sF ../Dropbox/wallpapers

  cd $HOME

  ln -sF Dropbox/developer Developer

  # Home Dotfiles links
  ln -sf .dotfiles/conda/.anaconda
  ln -sf .dotfiles/bash/.bashrc
  ln -sf .dotfiles/conda/.conda
  ln -sf .dotfiles/conda/.condarc
  ln -sf .dotfiles/conda/.continuum
  ln -sf .dotfiles/cricut/.cricut-design-space
  ln -sf .dotfiles/dropbox/.dropbox
  ln -sf .dotfiles/ipython/.ipython
  ln -sf .dotfiles/keras/.keras
  ln -sf .dotfiles/matplotlib/.matplotlib
  ln -sf .dotfiles/npm/.npm
  ln -sf .dotfiles/redhat/.redhat
  ln -sf .dotfiles/thinkorswim/.thinkorswim
  ln -sf .dotfiles/vscode/.vscode
  ln -sf .dotfiles/zsh/.zshenv 
  ln -sf .dotfiles/zsh/.zprofile

  # Configuation links
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
    ln -sF "../.dotfiles/$pkg"
  done

}

main() {
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  
  symlink

  cd "$SCRIPT_DIR"
  echo "[TUI SETUP SUCCESS - 3/3]"  
}

main
