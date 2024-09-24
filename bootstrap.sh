#!/usr/bin/env bash
: '
Bootstrap script to build MacOS Development Environment

System Version:   macOS 15.0
Kernel Version:   Darwin 24.0.0
Chip:             Apple M2 Max
Package Manager:  Homebrew
Cloud Service:    Dropbox
'

declare repo='https://raw.githubusercontent.com/vivek-x-jha/dotfiles/main'

# Load ANSI color variables
eval "$(curl -fsSL $repo/.colors)"

# Util condiional func 
is_installed() {
  local cmd="$1"
  if ! command -v "$cmd" &>/dev/null; then
    echo "${red}[! $cmd: NOT INSTALLED]"${reset}
    return 1
  fi
}

install_homebrew() {
  local install_type="$1" # all, formulas, casks
  local brewinstaller='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'

  # Test: Xcode installed
  is_installed xcode-select || { echo 'Please run: xcode-select --install'; exit 1; }

  # Test: architecture arm64 or x86_64
  case "$(uname -m)" in
    'arm64' ) local homebrew_bin='/opt/homebrew/bin' ;;
    'x86_64') local homebrew_bin='/usr/local/bin' ;;
           *) echo "${red}[! Unknown architecture - requires arm64 or x86_64]${reset}"; exit 1 ;;
  esac

  # Test: Homebrew installed and in PATH
  is_installed brew || /bin/bash -c "$(curl -fsSL "$brewinstaller")"
  eval "$("$homebrew_bin/brew" shellenv)"

  echo "${green}[+ brew: $homebrew_bin]{$reset}"

  # Install packages
  brew_install () {
    local filter="$1"
    local cmd="$2"
    local pkgs="curl -fsSL $repo/.Brewfile"

    if [[ "$install_type" == 'all' ]]; then
      "$pkgs" | brew bundle --file=-
    else
      "$pkgs" | grep "$filter" | awk '{print $2}' | xargs "$cmd"
    fi
  } 

  case "$install_type" in
    'all'     ) brew_install ;;
    'formulas') brew_install '^tap '  '-n1 brew tap'
                brew_install '^brew ' 'brew install' ;;
    'casks'   ) brew_install '^tap '  '-n1 brew tap'
                brew_install '^brew ' 'brew install --cask' ;;
  esac

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
  [ -d "$HOME/.dotfiles" ] && mv -f "$HOME/.dotfiles" "$HOME/.dotfiles.bak"
  cd "$HOME" && git clone https://github.com/vivek-x-jha/dotfiles.git .dotfiles
  
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

    .dotfiles/bash/.bash_profile "$HOME"             .bash_profile
    .dotfiles/bash/.bashrc       "$HOME"             .bashrc      
    .dotfiles/vscode/.vscode     "$HOME"             .vscode    
    .dotfiles/zsh/.zshenv        "$HOME"             .zshenv       

    ../.dotfiles/bat             "$XDG_CONFIG"       bat 
    ../.dotfiles/btop            "$XDG_CONFIG"       btop
    ../.dotfiles/gh              "$XDG_CONFIG"       gh  
    ../.dotfiles/glow            "$XDG_CONFIG"       glow
    ../.dotfiles/nvim            "$XDG_CONFIG"       nvim
    ../.dotfiles/.starship.toml  "$XDG_CONFIG"       starship.toml
    ../.dotfiles/tmux            "$XDG_CONFIG"       tmux
    ../.dotfiles/yazi            "$XDG_CONFIG"       yazi

    ../../.dotfiles/.atuin.toml  "$XDG_CONFIG/atuin" config.toml
    ../../.dotfiles/.dust.toml   "$XDG_CONFIG/dust"  config.toml
    ../../.dotfiles/.gitconfig   "$XDG_CONFIG/git"   config

    "$CLOUD/developer"           "$HOME"             Developer

    "../$CLOUD/content"          "$HOME/Movies"      content
    "../$CLOUD/icons"            "$HOME/Pictures"    icons
    "../$CLOUD/screenshots"      "$HOME/Pictures"    screenshots
    "../$CLOUD/wallpapers"       "$HOME/Pictures"    wallpapers
    "../$CLOUD/education"        "$HOME/Documents"   education
    "../$CLOUD/finances"         "$HOME/Documents"   finances

    zsh-autocomplete.plugin.zsh  "$(brew --prefix)/share/zsh-autocomplete"        autocomplete.zsh
    zsh-autosuggestions.zsh      "$(brew --prefix)/share/zsh-autosuggestions"     autosuggestions.zsh
    zsh-syntax-highlighting.zsh  "$(brew --prefix)/share/zsh-syntax-highlighting" syntax-highlighting.zsh
  )

  for ((i=0; i<${#symlinks[@]}; i+=3)); do symlink "${symlinks[i]}" "${symlinks[i+1]}" "${symlinks[i+2]}"; done
}

configure_macos() {

  # Screenshots
  defaults write com.apple.screencapture location -string "$HOME/Pictures/screenshots"

  # Dock 
  defaults write com.apple.dock autohide-delay -float 0.1                     # speed up dock animation
  defaults write com.apple.dock autohide-time-modifier -int 0
  defaults write com.apple.dock appswitcher-all-displays -bool true           # show app switcher on all screens
  defaults write com.apple.dock expose-animation-duration -float 0.1          # shorten mission conrol animation

  # Finder
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"         # use list view
  defaults write com.apple.finder QuitMenuItem -bool true                     # quit via ⌘ + Q
  defaults write com.apple.finder AppleShowAllFiles -bool true                # show hidden files
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false  # disable file ext change warning
  
  # Authentication
  sudo cp -f "$HOME/.dotfiles/.sudo_local" /etc/pam.d/sudo_local              # enable touchid for sudo

  # 3rd Party Apps
  touch "$HOME/.hushlogin"                                                    # surpress iterm2 login message
  bat cache --build                                                           # load bat themes

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
