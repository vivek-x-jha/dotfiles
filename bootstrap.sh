#!/usr/bin/env bash

init_homebrew() {
  local binary_path="$1" # /opt/homebrew/bin, /usr/local/bin
  local install_type="$2" # all, formulas, casks
  local brewfile='https://raw.githubusercontent.com/vivek-x-jha/dotfiles/main/.Brewfile'
  local brew_installer='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'

  xcode-select --install

  # Installs Homebrew and add to current session's PATH
  [[ -x $(which brew) ]] || /bin/bash -c "$(curl -fsSL "$brew_installer")"
  eval "$("$binary_path/brew" shellenv)"
  
  # Installs packages
  if [ "$install_type" == 'all' ]; then
    curl -fsSL "$brewfile" | brew bundle --file=-
  elif [ "$install_type" == 'formulas' ]; then
    curl -fsSL "$brewfile" | grep '^tap '  | awk '{print $2}' | xargs -n1 brew tap
    curl -fsSL "$brewfile" | grep '^brew ' | awk '{print $2}' | xargs brew install
  elif [ "$install_type" == 'casks' ]; then
    curl -fsSL "$brewfile" | grep '^tap '  | awk '{print $2}' | xargs -n1 brew tap
    curl -fsSL "$brewfile" | grep '^brew ' | awk '{print $2}' | xargs brew install --cask
  fi

  # Run Diagnostics
  brew update
  brew upgrade
  brew cleanup
  brew doctor
}

init_filesystem() {
  local service="$1"

  # Supress iTerm login message
  touch .hushlogin

  # Download Dotfiles repo - creates backup of any existing dotfiles
  [ -d "$HOME/.dotfiles" ] && mv -f "$HOME/.dotfiles" "$HOME/.dotfiles.bak"
  git clone https://github.com/vivek-x-jha/dotfiles.git "$HOME/.dotfiles"

  # Create XDG-Base Directories
  [ -d "$HOME/.cache"       ] || mkdir -p "$HOME/.cache"
  [ -d "$HOME/.config"      ] || mkdir -p "$HOME/.config"
  [ -d "$HOME/.local/share" ] || mkdir -p "$HOME/.local/share"
  [ -d "$HOME/.local/state" ] || mkdir -p "$HOME/.local/state"

  # Create Content Directories
  [ -d "$HOME/Movies"   ] || mkdir -p "$HOME/Movies"
  [ -d "$HOME/Pictures" ] || mkdir -p "$HOME/Pictures"

  # Link Home
  cd "$HOME"
  
  ln -sf .dotfiles/bash/.bash_profile
  ln -sf .dotfiles/bash/.bashrc
  ln -sf .dotfiles/zsh/.zshenv

  [ -d "$HOME/.thinkorswim"] && rm -rf "$HOME/.thinkorswim"
  ln -sF .dotfiles/thinkorswim/.thinkorswim

  [ -d "$HOME/.vscode"] && rm -rf "$HOME/.vscode"
  ln -sF .dotfiles/vscode/.vscode

  [ -d "$HOME/Developer"] && rm -rf "$HOME/Developer"
  ln -sF Dropbox/developer Developer

  # Link Media
  cd "$HOME/Movies"

  local movies=(content)
  for folder in "${movies[@]}"; do
    [ -d "$HOME/Movies/$folder" ] && rm -rf "$HOME/Movies/$folder"
    ln -sF ../Dropbox/$folder
  done

  cd "$HOME/Pictures"

  local pictures=(icons screenshots wallpapers)
  for folder in "${pictures[@]}"; do
    [ -d "$HOME/Pictures/$folder" ] && rm -rf "$HOME/Pictures/$folder"
    ln -sF ../Dropbox/$folder
  done

  cd "$HOME/Documents"

  local documents=(education finances)
  for folder in "${documents[@]}"; do
    [ -d "$HOME/Documents/$folder" ] && rm -rf "$HOME/Documents/$folder"
    ln -sF ../Dropbox/$folder
  done

  # Link Configurations
  cd "$HOME/.config"

  local packages=(bat btop gh nvim tmux yazi)
  for folder in "${packages[@]}"; do 
    [ -d "$HOME/.config/$folder" ] && rm -rf "$HOME/.config/$folder"
    ln -sF ../.dotfiles/$folder
  done

  # Link Starship
  ln -sf ../.dotfiles/.starship.toml starship.toml

  # Link Dust
  [ -d "$HOME/.config/dust" ] || mkdir -p "$HOME/.config/dust"
  cd "$HOME/.config/dust"
  ln -sf ../../.dotfiles/.dust.toml config.toml

  # Link Git
  [ -d "$HOME/.config/git" ] || mkdir -p "$HOME/.config/git"
  cd "$HOME/.config/git"
  ln -sf ../../.dotfiles/.gitconfig config
}

init_macos() {
  # https://github.com/mathiasbynens/dotfiles/blob/main/.macos
  
  # Build Bat Config
  bat cache --build

  # Save screenshots to ~/Pictures/screenshots
  defaults write com.apple.screencapture location -string "$HOME/Pictures/screenshots"

  # Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
  defaults write com.apple.finder QuitMenuItem -bool true

  # Finder: show hidden files by default
  defaults write com.apple.finder AppleShowAllFiles -bool true

  # Finder: Display full POSIX path as window title
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

  # Finder: Disable the warning when changing a file extension
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
}

init_ssh() {
  local email="$1"

  # Generate new SSH key
  ssh-keygen -t ed25519 -C "$email"

  eval "$(ssh-agent -s)"
}

main() {
  echo "󰓒 INSTALLATION START 󰓒"

  init_homebrew '/opt/homebrew/bin' 'all'
  echo "󰗡 [1/4] Homebrew & Packages Installed 󰗡"

  init_filesystem 
  echo "󰗡 [2/4] Filesystem & Symlinks Created 󰗡"
  
  init_macos
  echo "󰗡 [3/4] MacOS Defaults Configured 󰗡"

  init_ssh 'vivek.x.jha@gmail.com'
  echo "󰗡 [4/4] SSH Keys Generated 󰗡"

  echo "󰓒 INSTALLATION COMPLETE 󰓒"
}

main
