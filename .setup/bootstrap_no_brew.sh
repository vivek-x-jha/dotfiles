#!/usr/bin/env bash

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

# Create Filesystem and Symlinks
XDG_CONFIG="$HOME/.config"
XDG_CACHE="$HOME/.cache"
XDG_DATA="$HOME/.local/share"
XDG_STATE="$HOME/.local/state"

# Create xdg & media directories
directories=(
  "$XDG_CACHE"
  "$XDG_CONFIG/atuin"
  "$XDG_CONFIG/op"
  "$XDG_DATA"
  "$XDG_STATE"
)
for dir in "$directories[@]"; do [ -d "$dir" ] || mkdir -p "$dir"; done

symlinks=(
  .dotfiles/bash/.bash_profile "$HOME"             .bash_profile
  .dotfiles/bash/.bashrc       "$HOME"             .bashrc      
  .dotfiles/zsh/.zshenv        "$HOME"             .zshenv       
  ../.dotfiles/hammerspoon     "$HOME"             .hammerspoon

  ../.dotfiles/1Password       "$XDG_CONFIG"       1Password
  ../.dotfiles/atuin           "$XDG_CONFIG"       atuin
  ../.dotfiles/bash            "$XDG_CONFIG"       bash 
  ../.dotfiles/bat             "$XDG_CONFIG"       bat 
  ../.dotfiles/brew            "$XDG_CONFIG"       brew 
  ../.dotfiles/btop            "$XDG_CONFIG"       btop
  ../.dotfiles/dust            "$XDG_CONFIG"       dust
  ../.dotfiles/eza             "$XDG_CONFIG"       eza 
  ../.dotfiles/fzf             "$XDG_CONFIG"       fzf 
  ../.dotfiles/gh              "$XDG_CONFIG"       gh 
  ../.dotfiles/git             "$XDG_CONFIG"       git 
  ../.dotfiles/glow            "$XDG_CONFIG"       glow
  ../.dotfiles/karabiner       "$XDG_CONFIG"       karabiner
  ../.dotfiles/mycli           "$XDG_CONFIG"       mycli
  ../.dotfiles/nvim            "$XDG_CONFIG"       nvim
  ../.dotfiles/ssh             "$XDG_CONFIG"       ssh
  ../.dotfiles/task            "$XDG_CONFIG"       task
  ../.dotfiles/tmux            "$XDG_CONFIG"       tmux
  ../.dotfiles/wezterm         "$XDG_CONFIG"       wezterm
  ../.dotfiles/yazi            "$XDG_CONFIG"       yazi
  ../.dotfiles/zsh             "$XDG_CONFIG"       zsh 

  ../.dotfiles/starship/config.toml "$XDG_CONFIG"  starship.toml
  ../../.dotfiles/op/plugins.sh "$XDG_CONFIG/op"   plugins.sh

  ../../.dotfiles/eza          "$HOME/Library/Application Support" eza

  zsh-autocomplete.plugin.zsh  "$(brew --prefix)/share/zsh-autocomplete"        autocomplete.zsh
  zsh-autosuggestions.zsh      "$(brew --prefix)/share/zsh-autosuggestions"     autosuggestions.zsh
  zsh-syntax-highlighting.zsh  "$(brew --prefix)/share/zsh-syntax-highlighting" syntax-highlighting.zsh
)

for ((i=0; i<${#symlinks[@]}; i+=3)); do symlink "${symlinks[i]}" "${symlinks[i+1]}" "${symlinks[i+2]}"; done

# Configure macOS options

# Screenshots
[ -d "$HOME/Pictures/screenshots" ] || mkdir "$HOME/Pictures/screenshots"
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

# 3rd Party Apps
touch "$HOME/.hushlogin"                                                    # surpress iterm2 login message

bat cache --build                                                           # load bat themes

command -v op &>/dev/null || brew install 1password-cli                     # Install 1p cli
op signin && op vault list

ls -lAh "$XDG_CONFIG"
cd
