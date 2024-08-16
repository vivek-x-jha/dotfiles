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

main() {
  echo "󰓒 INSTALLATION START 󰓒"

  configure_homebrew 
  echo "󰗡 Homebrew setup 󰗡"


  echo "󰓒 INSTALLATION COMPLETE 󰓒"
}

main
