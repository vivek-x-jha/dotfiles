#!/usr/bin/env bash

# Boostrap script to build MacOS Development Environment
#
# System Version:   macOS 14.6.1 (23G93)
# Kernel Version:   Darwin 23.6.0
# Chip:             Apple M2 Max
# Padckage Manager: Homebrew
# Cloud Service:    Dropbox

is_installed() {
  local cmd="$1"
  if ! command -v "$cmd" &> /dev/null; then
    echo "[? $cmd: NOT INSTALLED]"
    return 1
  fi
}

install_homebrew() {
  local install_type="$1" # all, formulas, casks

  local arch=$(uname -m)
  local brewfile='https://raw.githubusercontent.com/vivek-x-jha/dotfiles/main/.Brewfile'

  # Test: Xcode installed
  if ! is_installed xcode-select; then
    echo 'Homebrew requires Xcode to run: xcode-select --install'
    exit 1
  fi

  # Test: Architecture arm64 or x86_64
  if [[ "$arch" == "arm64" ]]; then
    binary_path='/opt/homebrew/bin'
  elif [[ "$arch" == "x86_64" ]]; then
    binary_path='/usr/local/bin'
  else
    echo "Unknown architecture: $arch"
    echo 'Requires arm64 or x86_64'
    exit 1
  fi

  echo "[+ brew: Binary Path @ $binary_path]"

  # Test: Homebrew installed and in PATH
  if ! is_installed brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$("$binary_path/brew" shellenv)"
  fi
  
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

  brew list
}

create_filesystem() {
  local CLOUD="$1"
  local XDG_CONFIG="${2:-$HOME/.config}"

  # Test: Brew and Git installed
  is_installed brew || install_homebrew
  is_installed git  || brew install git
  
  # Create XDG & Media directories
  local directories=(
    .cache
    .config
    .config/dust
    .config/git
    .local/share
    .local/state
    Documents
    Movies
    Pictures
  )
  for dir in "$directories[@]"; do [ -d "$HOME/$dir" ] || mkdir -p "$HOME/$dir"; done

  # Create Dotfiles directory
  cd "$HOME"
  [ -d .dotfiles ] && mv -f .dotfiles .dotfiles.bak
  git clone https://github.com/vivek-x-jha/dotfiles.git .dotfiles
  
  # Link Dotfiles
  symlink() {
    local src="$1"
    local cwd="$2"
    local tgt="$3"
    
    # Test: Valid Current Working Dir
    [ -d "$cwd" ] || return 1
    cd "$cwd"

    # Test: Valid Source File/Folder
    [ -e "$src" ] || return 1

    # Link Source to Target - remove original if directory
    [ -d "$tgt" ] && rm -rf "$tgt"
    ln -sf "$src" "$tgt"

    echo "[+ Link: $src -> $cwd/$tgt]"
  }

  local symlinks=(
    .dotfiles/bash/.bash_profile "$HOME"            .bash_profile
    .dotfiles/bash/.bashrc       "$HOME"            .bashrc      
    .dotfiles/vscode/.vscode     "$HOME"            .vscode    
    .dotfiles/zsh/.zshenv        "$HOME"            .zshenv       

    ../.dotfiles/bat             "$XDG_CONFIG"      bat 
    ../.dotfiles/btop            "$XDG_CONFIG"      btop
    ../.dotfiles/gh              "$XDG_CONFIG"      gh  
    ../.dotfiles/nvim            "$XDG_CONFIG"      nvim
    ../.dotfiles/.starship.toml  "$XDG_CONFIG"      starship.toml
    ../.dotfiles/tmux            "$XDG_CONFIG"      tmux
    ../.dotfiles/yazi            "$XDG_CONFIG"      yazi
    
    ../../.dotfiles/.dust.toml   "$XDG_CONFIG/dust" config.toml
    ../../.dotfiles/.gitconfig   "$XDG_CONFIG/git"  config

    "$CLOUD/developer"           "$HOME"            Developer

    "../$CLOUD/content"          "$HOME/Movies"     content
    "../$CLOUD/icons"            "$HOME/Pictures"   icons
    "../$CLOUD/screenshots"      "$HOME/Pictures"   screenshots
    "../$CLOUD/wallpapers"       "$HOME/Pictures"   wallpapers
    "../$CLOUD/education"        "$HOME/Documents"  education
    "../$CLOUD/finances"         "$HOME/Documents"  finances

    zsh-autocomplete.plugin.zsh  "$(brew --prefix)/share/zsh-autocomplete"        autocomplete.zsh
    zsh-autosuggestions.zsh      "$(brew --prefix)/share/zsh-autosuggestions"     autosuggestions.zsh
    zsh-syntax-highlighting.zsh  "$(brew --prefix)/share/zsh-syntax-highlighting" syntax-highlighting.zsh
  )
  for ((i=0; i<${#symlinks[@]}; i+=3)); do symlink "${symlinks[i]}" "${symlinks[i+1]}" "${symlinks[i+2]}"; done
}

configure_macos() {
  # https://github.com/mathiasbynens/dotfiles/blob/main/.macos

  # Supress iTerm login message
  touch .hushlogin

  # Build Bat Config
  bat cache --build

  # Enable touchid for sudo
  sudo cp -f "$HOME/.dotfiles/.sudo_local" /etc/pam.d/sudo_local

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

main() {
  # TODO Create custom input for git.user, email, signing_key
  echo "󰓒 INSTALLATION START 󰓒"

  install_homebrew all
  echo "󰗡 [1/3] Homebrew & Packages Installed 󰗡"

  create_filesystem Dropbox
  echo "󰗡 [2/3] Filesystem & Symlinks Created 󰗡"
  
  configure_macos
  echo "󰗡 [3/3] MacOS Defaults Configured 󰗡"

  echo "󰓒 INSTALLATION COMPLETE 󰓒"
}

main
