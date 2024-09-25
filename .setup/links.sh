#!/usr/bin/env bash

CLOUD='Dropbox'
XDG_CONFIG="$HOME/.config"

# Create xdg & media directories
directories=(
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

# Backup dotfiles directory
[ -d "$HOME/.dotfiles" ] && mv -f "$HOME/.dotfiles" "$HOME/.dotfiles.bak"

# Link dotfiles and cloud folders
symlinks=(

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
