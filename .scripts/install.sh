#!/usr/bin/env bash

disp_install_status () {

  if [ $? -eq 0 ]; then
    echo "[TUI INSTALL SUCCESS] installed $1 ..."
  else
    echo "[TUI INSTALL FAIL] could not install $1 ..."
  fi
}

homebrew_init() {

  # Installs xcode if not installed
  if [ ! -x "$(command -v xcode-select)" ]; then
      echo "[TUI WARNING] xcode-select not installed! Installing now..."
      xcode-select --install
      disp_install_status 'xcode-select'
  fi

  # Install Homebrew and add to PATH
  if [ ! -x "$(command -v brew)" ]; then
    echo "[TUI WARNING] brew not installed! Installing now..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    disp_install_status 'brew'

    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi 
  
  brew_casks=(
    1password
    1password-cli
    alfred
    alt-tab
    anaconda
    arc
    chatgpt
    chatmate-for-whatsapp
    cleanshot
    discord
    dropbox
    firefox
    font-comic-shanns-mono-nerd-font
    font-sf-mono-nerd-font-ligaturized
    font-symbols-only-nerd-font
    google-chrome
    image2icon
    iterm2
    mactex
    mimestream
    notion-calendar
    skim
    slack
    spotify
    tex-live-utility
    thinkorswim
    tradingview
    visual-studio-code 
    vlc  
    zoom
  )

  brew_formulae=(
    coreutils
    bat
    btop
    dust
    eza
    fzf
    gh
    git
    gitmux
    img2pdf
    lazygit
    lua
    mycli
    mysql
    neovim
    ocrmypdf
    powerlevel10k
    ripgrep
    switchaudio-osx
    tree
    tmux
    z.lua
    zsh-autocomplete
    zsh-autopair
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
  )

  brew tap homebrew/cask-fonts

  for cask in ${brew_casks[@]}; do 
    echo "[TUI INSTALL] Installing $cask ..."
    brew install --cask $cask
    disp_install_status $cask
  done

  for formula in ${brew_formulae[@]}; do
    echo "[TUI INSTALL] Installing $formulae ..."
    brew install $formula
    disp_install_status $formula
  done
}

iterm2_init() {

  [ -f "$HOME/.hushlogin" ] || touch "$HOME/.hushlogin"
}

main() {

  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  homebrew_init
  iterm2_init

  echo "[TUI INSTALL SUCCESS - 2/3]"
}

main
