#!/usr/bin/env bash

# Reccommended Install way - probably won't use this in script
bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)

# Initialization commands
# TODO add conditional that checks if atuin sync data in 1password
# TODO 
atuin register -u <USERNAME> -e <EMAIL>
atuin import auto
atuin sync

atuin login -u <USERNAME>
