# Personal Development Environment

Checkout a fast, functional, & fun Terminal environent full of beuatiful and modern IDE features

## Requiements

- [x] macOS (Intel or Apple Silicon)
- [ ] Linux Distros

## Installation

Run the following:

```sh
cd "$HOME"
git clone https://github.com/vivek-x-jha/dotfiles.git .dotfiles
./bootstrap.sh
```

*Optional:* after installation, run ```rm -rf "$HOME/.dotfiles/.git"``` and begin your own version control!

## Features

### Zsh

1. [Auto-Complete](https://github.com/marlonrichert/zsh-autocomplete)
1. [Auto-Pair](https://github.com/hlissner/zsh-autopair)
1. [Auto-Suggestions](https://github.com/zsh-users/zsh-autosuggestions)
1. [Syntax-Highlighting](https://github.com/zsh-users/zsh-autosuggestions)

### Bash

1. [Completion + Syntax-Highlighting](https://github.com/akinomyoga/ble.sh)

### Neovim

1. [NvChad](https://github.com/NvChad/NvChad)
1. [Lazy](https://www.github.com/folke/lazy.nvim)
1. [Harpoon](https://github.com/ThePrimeagen/harpoon/tree/harpoon2)

### Tmux

1. [Tpm](https://www.github.com/tmux-plugins/tpm)
1. [Floax](https://github.com/vivek-x-jha/tmux-floax)
1. [Sessionx](https://github.com/vivek-x-jha/tmux-sessionx)
1. [Vim-Navigator](https://github.com/vivek-x-jha/tmux-vim-navigator)
1. [Yank](https://github.com/tmux-plugins/tmux-yank)
1. [Sensible](https://github.com/tmux-plugins/tmux-sensible)
1. [Resurrect](https://github.com/tmux-plugins/tmux-resurrect)
1. [Continuum](https://github.com/tmux-plugins/tmux-continuum)

### Sudo

Enable authentication using touchid - works in multiplexers like tmux and screen

```sh
sudo cp -f "$HOME/.dotfiles/.sudo_local" /etc/pam.d/sudo_local
```

### SSH

Configure 1Password as SSH Manager

1. [1Password for SSH & Git](https://developer.1password.com/docs/ssh/get-started)
1. [Connecting to GitHub with SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)

## Fonts

Using [Nerd Fonts](https://www.nerdfonts.com/)
