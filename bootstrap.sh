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

  link_dir() {
    local root="$1"
    local service="$2"
    local folder="$3"

    cd "$root"

    [ -d "$root/$folder" ] && rm -rf "$root/$folder"
    ln -sF ../$service/$folder
  }

  # Download Dotfiles repo - creates backup of any existing dotfiles
  [ -d "$HOME/.dotfiles" ] && mv "$HOME/.dotfiles" "$HOME/.dotfiles.bak"
  git clone https://github.com/vivek-x-jha/dotfiles.git "$HOME/.dotfiles"

  # Create XDG-Base Directories
  [ -d "$HOME/.cache"       ] || mkdir -p "$HOME/.cache"
  [ -d "$HOME/.config"      ] || mkdir -p "$HOME/.config"
  [ -d "$HOME/.local/share" ] || mkdir -p "$HOME/.local/share"
  [ -d "$HOME/.local/state" ] || mkdir -p "$HOME/.local/state"

  # Create Content Directories
  [ -d "$HOME/Movies"   ] || mkdir -p "$HOME/Movies"
  [ -d "$HOME/Pictures" ] || mkdir -p "$HOME/Pictures"

  # Link Developer Folder
  ln -sf $service/developer Developer
  
  # Link Media Diretories
  link_dir "$HOME/Movies" "$service" content

  local content=(icons screenshots wallpapers)
  for folder in "${content[@]}"; do link_dir "$HOME/Pictures" "$service" "$folder"; done

  # Link XDG-CONFIG programs
  local packages=(bat btop gh nvim tmux yazi)
  for pkg in "${packages[@]}"; do link_dir "$HOME/.config" .dotfiles "$pkg"; done

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

  # Link Bash, Zsh, VS Code, & Think or Swim
  cd "$HOME"
  ln -sf .dotfiles/bash/.bash_profile
  ln -sf .dotfiles/bash/.bashrc
  ln -sf .dotfiles/thinkorswim/.thinkorswim
  ln -sf .dotfiles/vscode/.vscode
  ln -sf .dotfiles/zsh/.zshenv

  # Link Developer Folder
  ln -sf $service/developer Developer
  
  # Supress iTerm login message
  touch .hushlogin

  # Build Bat Config
  bat cache --build
}

init_macos() {
  # https://github.com/mathiasbynens/dotfiles/blob/main/.macos
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
