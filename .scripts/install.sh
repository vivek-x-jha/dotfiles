#!/usr/bin/env bash

disp_install_status () {
  local cmd="$1"

  if [ $? -eq 0 ]; then
    echo "[TUI INSTALL SUCCESS] installed $cmd ..."
  else
    echo "[TUI INSTALL FAIL] could not install $cmd ..."
  fi
}

load() {
  local cmd="$1"
  local installer="$2"

  if [ ! -x "$(command -v "$cmd")" ]; then
      echo "[TUI WARNING] $cmd not installed! Installing now..."
      eval "$installer"
      disp_install_status "$cmd"
  fi

}

homebrew_init() {
  # Installs xcode if not installed
  load xcode-select 'xcode-select --install'
  load brew         '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

  eval "$(/opt/homebrew/bin/brew shellenv)"
}

homebrew_config() {
  # TODO fix location 
  brew bundle --file=~/dofiles/brew/.Brewfile
}

iterm2_init() {
  [ -f "$HOME/.hushlogin" ] || touch "$HOME/.hushlogin"
}

main() {
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  homebrew_init
  homebrew_config
  iterm2_init

  echo "[TUI INSTALL SUCCESS - 2/3]"
}

main
