# Personal Development Environment

A fast, functional, & fun command line based development experience!

Features full of beuatiful and modern IDE tools.

## Requirements

- [x] macOS (Intel or Apple Silicon)
- [ ] Linux Distros

## Installation

```sh
git clone https://github.com/vivek-x-jha/dotfiles.git ~/.dotfiles && ~/.dotfiles/bootstrap.sh
```

Open a new terminal emulator window for changes to take effect!

## 💡 TIP: Test GitHub Signing & Auth Key

To verify that your **GitHub Signing Key** and **GitHub Auth Key** are working correctly, run the following command:

```sh
cd "$HOME/.dotfiles.git" && git commit -m "$USER fork begins!" && git push && glg -5
```

## Install Neovim Language Servers

```vim
:MasonInstall basedpyright bash-language-server lua-language-server shellcheck stylua
```

## Features

### Zsh

1. [Auto-Complete](https://github.com/marlonrichert/zsh-autocomplete)
1. [Auto-Pair](https://github.com/hlissner/zsh-autopair)
1. [Auto-Suggestions](https://github.com/zsh-users/zsh-autosuggestions)
1. [Syntax-Highlighting](https://github.com/zsh-users/zsh-autosuggestions)

### Bash

1. [Completion + Syntax-Highlighting](https://github.com/akinomyoga/ble.sh)

### Neovim

1. [Lazy](https://www.github.com/folke/lazy.nvim)
1. [Harpoon](https://github.com/ThePrimeagen/harpoon/tree/harpoon2)

### Tmux

1. [Tpm](https://www.github.com/tmux-plugins/tpm)
1. [Floax](https://github.com/vivek-x-jha/tmux-floax)
1. [Vim-Navigator](https://github.com/vivek-x-jha/tmux-vim-navigator)
1. [Yank](https://github.com/tmux-plugins/tmux-yank)
1. [Sensible](https://github.com/tmux-plugins/tmux-sensible)
1. [Resurrect](https://github.com/tmux-plugins/tmux-resurrect)
1. [Continuum](https://github.com/tmux-plugins/tmux-continuum)

### Sudo

Enable authentication using touchid - works in multiplexers like tmux and screen

```sh
brew list | grep -q pam-reattach || brew install pam-reattach
sudo cp -f ~/.dotfiles/sudo/sudo_local /etc/pam.d/sudo_local
```

### SSH

Configure 1Password as SSH Manager

1. [1Password for SSH & Git](https://developer.1password.com/docs/ssh/get-started)
1. [Connecting to GitHub with SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
1. [Use 1Password to securely authenticate the GitHub CLI](https://developer.1password.com/docs/cli/shell-plugins/github/)

## Fonts

Using [Nerd Fonts](https://www.nerdfonts.com/)
