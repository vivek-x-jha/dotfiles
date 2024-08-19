#!/usr/bin/env bash

is_installed() {
  local cmd="$1"
  if command -v "$cmd" &> /dev/null; then
    echo "+ $cmd INSTALLED"
  else
    echo "? $cmd NOT INSTALLED - ATTEMPTING TO NOW..."
    return 1
  fi
}

init_homebrew() {
  local binary_path="$1" # /opt/homebrew/bin, /usr/local/bin
  local install_type="$2" # all, formulas, casks
  local brewfile='https://raw.githubusercontent.com/vivek-x-jha/dotfiles/main/.Brewfile'
  local brew_installer_url='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
  local log="$HOME/.bootstrap.log"

  # Install Xcode
  is_installed xcode-select || xcode-select --install

  # Install Homebrew and add to current session's PATH
  is_installed brew || /bin/bash -c "$(curl -fsSL "$brew_installer_url")"
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
  link_dir() {
    local parent_dir="$1"
    local folder="$2"
    local target_dir="$3"

    cd "$target_dir"

    [ -d "$target_dir/$folder" ] && rm -rf "$target_dir/$folder"
    ln -sf $parent_dir/$folder
  }

  # Supress iTerm login message
  touch .hushlogin

  # Download Dotfiles repo - creates backup of any existing dotfiles
  [ -d "$HOME/.dotfiles" ] && mv -f "$HOME/.dotfiles" "$HOME/.dotfiles.bak"
  git clone https://github.com/vivek-x-jha/dotfiles.git "$HOME/.dotfiles"

  # TODO Create custom input for git.user, email, signing_key
  
  # Create Directories
  [ -d "$HOME/.cache"       ] || mkdir -p "$HOME/.cache"
  [ -d "$HOME/.config"      ] || mkdir -p "$HOME/.config"
  [ -d "$HOME/.local/share" ] || mkdir -p "$HOME/.local/share"
  [ -d "$HOME/.local/state" ] || mkdir -p "$HOME/.local/state"

  [ -d "$HOME/Movies"       ] || mkdir -p "$HOME/Movies"
  [ -d "$HOME/Pictures"     ] || mkdir -p "$HOME/Pictures"

  # Link Directories
  link_dir 'Dropbox'               Developer     "$HOME" 
  link_dir '.dotfiles/bash'        .bash_profile "$HOME"
  link_dir '.dotfiles/bash'        .bashrc       "$HOME"
  link_dir '.dotfiles/thinkorswim' .thinkorswim  "$HOME"
  link_dir '.dotfiles/vscode'      .vscode       "$HOME"
  link_dir '.dotfiles/zsh'         .zshenv       "$HOME"

  link_dir '../Dropbox'   content     "$HOME/Movies"
  link_dir '../Dropbox'   icons       "$HOME/Pictures"
  link_dir '../Dropbox'   screenshots "$HOME/Pictures"
  link_dir '../Dropbox'   wallpapers  "$HOME/Pictures"
  link_dir '../Dropbox'   education   "$HOME/Documents"
  link_dir '../Dropbox'   finances    "$HOME/Documents"

  link_dir '../.dotfiles' bat         "$HOME/.config"
  link_dir '../.dotfiles' btop        "$HOME/.config"
  link_dir '../.dotfiles' gh          "$HOME/.config"
  link_dir '../.dotfiles' nvim        "$HOME/.config"
  link_dir '../.dotfiles' tmux        "$HOME/.config"
  link_dir '../.dotfiles' yazi        "$HOME/.config"
    
  ln -sf ../.dotfiles/.starship.toml starship.toml

  [ -d "$HOME/.config/dust" ] || mkdir -p "$HOME/.config/dust"
  cd "$HOME/.config/dust"
  ln -sf ../../.dotfiles/.dust.toml config.toml

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

main() {
  echo "󰓒 INSTALLATION START 󰓒"

  init_homebrew '/opt/homebrew/bin' 'all'
  echo "󰗡 [1/3] Homebrew & Packages Installed 󰗡"

  init_filesystem 
  echo "󰗡 [2/3] Filesystem & Symlinks Created 󰗡"
  
  init_macos
  echo "󰗡 [3/3] MacOS Defaults Configured 󰗡"

  echo "󰓒 INSTALLATION COMPLETE 󰓒"
}

main
