#!/usr/bin/env bash

: '
Bootstrap script to build MacOS Development Environment

System Version:   macOS 15.0
Kernel Version:   Darwin 24.0.0
Chip:             Apple M2 Max
Package Manager:  Homebrew
Cloud Service:    Dropbox
'
# TODO Create custom input for git.user, email, signing_key

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SETUP="$CURRENT_DIR/.setup"

# Load color variables and helper functions
source "$CURRENT_DIR/.colors"
source "$SETUP/utils.sh"

# Test: Xcode installed
if is_installed xcode-select; then
  echo "󰓒 INSTALLATION START 󰓒"
else
  echo 'Please run: xcode-select --install'
  exit 1
fi

# Install Homebrew and Packages 
is_installed brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
source "$SETUP/brew.sh"
echo '[ 1/4 Homebrew & Packages Installed]'

# Create Filesystem and Symlinks
source "$SETUP/links.sh"
echo '[ 2/4 Filesystem & Symlinks Created]'

# Setup Git and SSH
is_installed git || brew install git
is_installed op  || brew install 1password-cli
source "$SETUP/ssh-git.sh"
echo '[ 3/4 Git and SSH Configured]'

# Configure macOS options
source "$SETUP/macos.sh"
echo '[ 4/4 macOS Settings Configured]'

echo "󰓒 INSTALLATION COMPLETE 󰓒"
cd "$HOME"
