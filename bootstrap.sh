#!/usr/bin/env bash

configure_homebrew() {
  local brew_binary="${1:-'/opt/homebrew/bin/brew'}"

  xcode-select --install

  # Installs Homebrew and add to current session's PATH
  [[ -x $(which brew) ]] || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$("$brew_binary" shellenv)"
  
  # Installs packages & guis
  curl -fsSL https://raw.githubusercontent.com/vivek-x-jha/dotfiles/main/.Brewfile | brew bundle --file=-
  
  # Run Diagnostics
  brew update
  brew upgrade
  brew cleanup
  brew doctor
}

configure_filesystem() {
  [ -d "$HOME/.cache" ]       || mkdir "$HOME/.cache"
  [ -d "$HOME/.config" ]      || mkdir "$HOME/.config"
  [ -d "$HOME/.local" ]       || mkdir "$HOME/.local"
  [ -d "$HOME/.local/share" ] || mkdir "$HOME/.local/share"
  [ -d "$HOME/.local/state" ] || mkdir "$HOME/.local/state"

  cd "$HOME/Movies"
  rm -r "$HOME/Movies/content" 2> /dev/null; ln -s ../Dropbox/content

  cd "$HOME/Pictures"
  rm -r "$HOME/Movies/icons" 2> /dev/null; ln -s ../Dropbox/icons
  rm -r "$HOME/Movies/screenshots" 2> /dev/null; ln -s ../Dropbox/screenshots
  rm -r "$HOME/Movies/wallpapers" 2> /dev/null; ln -s ../Dropbox/wallpapers

  cd "$HOME/.config"
  ln -sf ../.dotfiles/.starship.toml starship.toml

  rm -r "$HOME/.config/bat" 2> /dev/null; ln -s ../.dotfiles/bat
  rm -r "$HOME/.config/btop" 2> /dev/null; ln -s ../.dotfiles/btop
  rm -r "$HOME/.config/gh" 2> /dev/null; ln -s ../.dotfiles/gh
  rm -r "$HOME/.config/nvim" 2> /dev/null; ln -s ../.dotfiles/nvim
  rm -r "$HOME/.config/ssh" 2> /dev/null; ln -s ../.dotfiles/ssh
  rm -r "$HOME/.config/tmux" 2> /dev/null; ln -s ../.dotfiles/tmux
  rm -r "$HOME/.config/yazi" 2> /dev/null; ln -s ../.dotfiles/yazi

  rm -r "$HOME/.config/dust" 2> /dev/null
  cd "$HOME/.config/dust"
  ln -sf ../../.dotfiles/.dust.toml config.toml

  rm -r "$HOME/.config/git" 2> /dev/null
  cd "$HOME/.config/git"
  ln -sf ../../.dotfiles/.gitconfig config

  cd "$HOME"
  
  ln -sf .dotfiles/bash/.bash_profile
  ln -sf .dotfiles/bash/.bashrc
  ln -sf .dotfiles/thinkorswim/.thinkorswim
  ln -sf .dotfiles/vscode/.vscode
  ln -sf .dotfiles/zsh/.zshenv
  ln -sf Dropbox/developer
  
  touch .hushlogin
}

configure_bat

main() {
  echo "󰓒 INSTALLATION START 󰓒"

  configure_homebrew 
  echo "󰗡 Homebrew Setup 󰗡"

  configure_filesystem
  echo "󰗡 Symlinks and Directories Setup 󰗡"

  echo "󰓒 INSTALLATION COMPLETE 󰓒"
}

main
