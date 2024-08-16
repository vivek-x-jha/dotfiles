#!/usr/bin/env bash

init_homebrew() {
  local brew_binary="$1"

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

init_filesystem() {
  local cloud_service="$1"

  # Download dotfiles repo
  git clone https://github.com/vivek-x-jha/dotfiles.git "$HOME/.dotfiles"

  # Create XDG-Base Directories
  [ -d "$HOME/.cache"       ] || mkdir "$HOME/.cache"
  [ -d "$HOME/.config"      ] || mkdir "$HOME/.config"
  [ -d "$HOME/.local"       ] || mkdir "$HOME/.local"
  [ -d "$HOME/.local/share" ] || mkdir "$HOME/.local/share"
  [ -d "$HOME/.local/state" ] || mkdir "$HOME/.local/state"

  # Link video content
  cd "$HOME/Movies"
  rm -r "$HOME/Movies/content" 2> /dev/null
  ln -sF ../$cloud_service/content

  # Link image content
  cd "$HOME/Pictures"
  local img_content=(icons screenshots wallpapers)
  for dir in "${img_content[@]}"; do
    rm -r "$HOME/Movies/$dir" 2> /dev/null
    ln -sF ../$cloud_service/icons
  done
 
  # Link CLI packages
  cd "$HOME/.config"

  local packages=(bat btop gh nvim ssh tmux yazi)
  for pkg in "${packages[@]}"; do
    rm -r "$HOME/.config/$pkg" 2> /dev/null 
    ln -s ../.dotfiles/$pkg
  done

  ln -sf ../.dotfiles/.starship.toml starship.toml

  # Link Dust
  rm -r "$HOME/.config/dust" 2> /dev/null
  mkdir "$HOME/.config/dust" && cd "$HOME/.config/dust"
  ln -sf ../../.dotfiles/.dust.toml config.toml

  # Link Git
  rm -r "$HOME/.config/git" 2> /dev/null
  mkdir "$HOME/.config/git" && cd "$HOME/.config/git"
  ln -sf ../../.dotfiles/.gitconfig config

  # Link Shells, VS Code, & Think or Swim
  cd "$HOME"
  ln -sf .dotfiles/bash/.bash_profile
  ln -sf .dotfiles/bash/.bashrc
  ln -sf .dotfiles/thinkorswim/.thinkorswim
  ln -sf .dotfiles/vscode/.vscode
  ln -sf .dotfiles/zsh/.zshenv
  ln -sf $cloud_service/developer
  
  # Supress iTerm login message
  touch .hushlogin

  # Build Bat Config
  bat cache --build
}

init_macos() {
  #TODO https://github.com/mathiasbynens/dotfiles/blob/main/.macos
}

init_ssh() {
  local email="$1"

  # Generate new SSH key
  ssh-keygen -t ed25519 -C "$email"

  eval "$(ssh-agent -s)"
}

main() {
  echo "󰓒 INSTALLATION START 󰓒"

  init_homebrew '/opt/homebrew/bin/brew'
  echo "󰗡 [1/4] Homebrew & Packages Installed 󰗡"

  init_filesystem 'Dropbox'
  echo "󰗡 [2/4] Filesystem & Symlinks Created 󰗡"
  
  init_macos
  echo "󰗡 [3/4] MacOS Defaults Configured 󰗡"

  init_ssh 'vivek.x.jha@gmail.com'
  echo "󰗡 [4/4] SSH Keys Generated 󰗡"

  echo "󰓒 INSTALLATION COMPLETE 󰓒"
}

main
