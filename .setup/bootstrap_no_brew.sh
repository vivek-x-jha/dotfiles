#!/usr/bin/env bash

is_installed() {
  local cmd="$1"
  if ! command -v "$cmd" &>/dev/null; then
    echo "[! $cmd: NOT INSTALLED]"
    return 1
  fi
}

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

# Test: Xcode installed
if is_installed xcode-select; then
  echo "󰓒 INSTALLATION START 󰓒"
else
  echo 'Please run: xcode-select --install'
  exit 1
fi

# Create Filesystem and Symlinks
XDG_CONFIG="$HOME/.config"
XDG_CACHE="$HOME/.cache"
XDG_DATA="$HOME/.local/share"
XDG_STATE="$HOME/.local/state"

# Create xdg & media directories
directories=(

  "$XDG_CACHE"

  "$XDG_CONFIG"
  "$XDG_CONFIG/atuin"
  "$XDG_CONFIG/dust"
  "$XDG_CONFIG/gh"
  "$XDG_CONFIG/git"
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
echo '[ 1/3 Filesystem & Symlinks Created]'

# Setup Git and SSH
is_installed git || brew install git
is_installed op  || brew install 1password-cli

op signin

# Prompt for Git configuration details
echo "Let's configure your Git settings."

read -p "Enter Git user name: " name
read -p "Enter Git email: "     email
read -p "Enter 1P vault name: " vault
read -p "Enter SSH key name: "  key

signingkey="$(op read "op://$vault/$key/public key")"

# Set Global config file with options
git config --global user.name       "$name"
git config --global user.email      "$email"
git config --global user.signingkey "$signingkey"

# Set Allowed Signers
signers="$HOME/.dotfiles/ssh/allowed_signers"
echo "$email $signingkey" > "$signers"

echo Updated following:
echo '  ~/.dotfiles/.gitconfig'
echo '  ~/.dotfiles/ssh/allowed_signers'
echo '[ 2/3 Git and SSH Configured]'

# Configure macOS options

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

# 3rd Party Apps
touch "$HOME/.hushlogin"                                                    # surpress iterm2 login message
bat cache --build                                                           # load bat themes
echo '[ 3/3 macOS Settings Configured]'

echo "󰓒 INSTALLATION COMPLETE 󰓒"
cd 
