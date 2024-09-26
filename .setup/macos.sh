#!/usr/bin/env bash

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
