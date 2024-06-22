#!/usr/bin/env sh

# Specify the preferences directory
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$XDG_CONFIG_HOME/iterm2"

# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

# Surpress Shell Last Login Message
ln -sF .hushlogin ~/.hushlogin

# After downloading homebrew versions of bash and zsh, use those
# Need to add them to /etc/shells
echo "$HOMEBREW_PREFIX/bin/bash" | sudo tee -a /etc/shells
echo "$HOMEBREW_PREFIX/bin/zsh" | sudo tee -a /etc/shells
