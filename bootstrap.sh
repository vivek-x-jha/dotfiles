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

makedir() {
  local dir="$1"
  [ -d "$dir" ] || mkdir -p "$dir"
}

backup() {
  local file="$1"
  [ -e "$file" ] && mv -f "$file" "$file.bak"
}

symlink() {
  local parent="$1"
  local name="$2"
  local cwd="$3"
  local target="${4:-$name}"
  
  local src="$parent/$name"
  [[ "$parent" == '.' ]] && local src="$name"

  cd "$cwd"

  [ -e "$src" ] || return 1

  [ -d "$target" ] && rm -rf "$target"
  ln -sf "$src" "$target"
}

install_homebrew() {
  local install_type="${1:-'all'}" # all, formulas, casks
  local binary_path="${2:-'/opt/homebrew/bin'}" # /usr/local/bin
  local logger="${3:-"$HOME/.bootstrap.log"}"

  local brewfile='https://raw.githubusercontent.com/vivek-x-jha/dotfiles/main/.Brewfile'
  local brew_installer='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'

  # Install Xcode
  is_installed xcode-select || xcode-select --install

  # Install Homebrew and add to current session's PATH
  is_installed brew || /bin/bash -c "$(curl -fsSL "$brew_installer")"
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

  brew list &> "$logger" 
}

init_filesystem() {
  local CLOUD="$1"
  local DOT="$2"
  local XDG_CONFIG="$3"

  # Requires brew and git
  is_installed brew || install_homebrew
  is_installed git  || brew install git
  
  # Create XDG & Media Directories
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
  for dir in "$directories[@]"; do makedir "$HOME/$dir"; done

  # Create Dotfiles folder
  backup "$DOT"
  git clone https://github.com/vivek-x-jha/dotfiles.git "$DOT"
  
  # Link Dotfiles
  symlink .dotfiles/bash   .bash_profile  "$HOME"
  symlink .dotfiles/bash   .bashrc        "$HOME"
  symlink .dotfiles/vscode .vscode        "$HOME"
  symlink .dotfiles/zsh    .zshenv        "$HOME"

  symlink ../.dotfiles     bat            "$XDG_CONFIG"
  symlink ../.dotfiles     btop           "$XDG_CONFIG"
  symlink ../.dotfiles     gh             "$XDG_CONFIG"
  symlink ../.dotfiles     nvim           "$XDG_CONFIG"
  symlink ../.dotfiles     .starship.toml "$XDG_CONFIG"      starship.toml
  symlink ../.dotfiles     tmux           "$XDG_CONFIG"
  symlink ../.dotfiles     yazi           "$XDG_CONFIG"
  
  symlink ../../.dotfiles  .dust.toml     "$XDG_CONFIG/dust" config.toml
  symlink ../../.dotfiles  .gitconfig     "$XDG_CONFIG/git"  config

  # Link Cloud Services
  symlink "$CLOUD"         developer      "$HOME"            Developer

  symlink "../$CLOUD"      content        "$HOME/Movies"
  symlink "../$CLOUD"      icons          "$HOME/Pictures"
  symlink "../$CLOUD"      screenshots    "$HOME/Pictures"
  symlink "../$CLOUD"      wallpapers     "$HOME/Pictures"
  symlink "../$CLOUD"      education      "$HOME/Documents"
  symlink "../$CLOUD"      finances       "$HOME/Documents"

  # Link Zsh Plugins
  symlink . zsh-autocomplete.plugin.zsh   "$(brew --prefix)/share/zsh-autocomplete"        autocomplete.zsh
  symlink . zsh-autosuggestions.zsh       "$(brew --prefix)/share/zsh-autosuggestions"     autosuggestions.zsh
  symlink . zsh-syntax-highlighting.zsh   "$(brew --prefix)/share/zsh-syntax-highlighting" syntax-highlighting.zsh
}

init_macos() {
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

  install_homebrew
  echo "󰗡 [1/3] Homebrew & Packages Installed 󰗡"

  init_filesystem Dropbox "$HOME/.dotfiles" "$HOME/.config"
  echo "󰗡 [2/3] Filesystem & Symlinks Created 󰗡"
  
  init_macos
  echo "󰗡 [3/3] MacOS Defaults Configured 󰗡"

  echo "󰓒 INSTALLATION COMPLETE 󰓒"
}

main
