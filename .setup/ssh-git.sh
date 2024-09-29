#!/usr/bin/env bash

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
