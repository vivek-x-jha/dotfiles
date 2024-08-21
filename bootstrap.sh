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
  backup() {
    local file="$1"
    [ -d "$file" ] && mv -f "$file" "$file.bak"
  }

  symlink() {
    local source_parent="$1"

    if [[ "$source_parent" == '.' ]]; then 
      local source_name="$2"
    else
      local source_name="$source_parent/$2"
    fi

    local target_parent="$3"
    local target_name="${4:-$source_name}"

    cd "$target_parent"

    [ -d "$target_parent/$target_name" ] && rm -rf "$target_parent/$target_name"
    ln -sf "$source_name" "$target_name"
  }

  # Supress iTerm login message
  touch .hushlogin

  # Download Dotfiles repo
  backup "$HOME/.dotfiles"
  git clone https://github.com/vivek-x-jha/dotfiles.git "$HOME/.dotfiles"

  # TODO Create custom input for git.user, email, signing_key
  
  # Create Directories
  local home_dirs=(
    .cache
    .config
    .local/share
    .local/state
    Movies
    Pictures
  )
  for dir in "$home_dirs[@]"; do [ -d "$HOME/$dir" ] || mkdir -p "$HOME/$dir"; done

  # Link Directories
  symlink Dropbox               developer      "$HOME" Developer
  symlink .dotfiles/bash        .bash_profile  "$HOME"
  symlink .dotfiles/bash        .bashrc        "$HOME"
  symlink .dotfiles/thinkorswim .thinkorswim   "$HOME"
  symlink .dotfiles/vscode      .vscode        "$HOME"
  symlink .dotfiles/zsh         .zshenv        "$HOME"

  symlink ../Dropbox            content        "$HOME/Movies"
  symlink ../Dropbox            icons          "$HOME/Pictures"
  symlink ../Dropbox            screenshots    "$HOME/Pictures"
  symlink ../Dropbox            wallpapers     "$HOME/Pictures"
  symlink ../Dropbox            education      "$HOME/Documents"
  symlink ../Dropbox            finances       "$HOME/Documents"

  symlink ../.dotfiles          bat            "$HOME/.config"
  symlink ../.dotfiles          btop           "$HOME/.config"
  symlink ../.dotfiles          gh             "$HOME/.config"
  symlink ../.dotfiles          nvim           "$HOME/.config"
  symlink ../.dotfiles          .starship.toml "$HOME/.config" starship.toml
  symlink ../.dotfiles          tmux           "$HOME/.config"
  symlink ../.dotfiles          yazi           "$HOME/.config"

  symlink ../../.dotfiles       dust           "$HOME/.config" config.toml
  symlink ../../.dotfiles       git            "$HOME/.config" config

  symlink . zsh-autocomplete.plugin.zsh "$(brew --prefix)/share/zsh-autocomplete" autocomplete.zsh
  symlink . zsh-autosuggestions.zsh "$(brew --prefix)/share/zsh-autosuggestions" autosuggestions.zsh
  symlink . zsh-syntax-highlighting.zsh "$(brew --prefix)/share/zsh-syntax-highlighting" syntax-highlighting.zsh
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
