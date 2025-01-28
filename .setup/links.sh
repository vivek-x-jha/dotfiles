#!/usr/bin/env bash

CLOUD='Dropbox'
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

  "$HOME/Documents"
  "$HOME/Movies"
  "$HOME/Pictures"

)
for dir in "${directories[@]}"; do [ -d "$dir" ] || mkdir -p "$dir"; done

# Backup dotfiles directory
cp -Rf "$HOME/.dotfiles" "$XDG_CACHE/.dotfiles.bak"

# Link dotfiles and cloud folders
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

  ../../.dotfiles/git/.gitconfig "$XDG_CONFIG/git" config
  ../../.dotfiles/op/plugins.sh  "$XDG_CONFIG/op"  plugins.sh

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
