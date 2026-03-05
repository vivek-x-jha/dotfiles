# Personal Development Environment

A fast, functional, & fun command line based development experience!

Features a modern terminal-first workflow across shell, editor, and tmux.

## Documentation

- **Agent + architecture guide**: [AGENTS.md](./AGENTS.md)
- **Primary setup orchestrator**: [`bootstrap.sh`](./bootstrap.sh)

## Requirements

- [x] macOS (Intel or Apple Silicon)
- [x] Linux (`apt` and `dnf` flows in `bootstrap.sh`)

## Installation

```sh
git clone --depth 1 https://github.com/vivek-x-jha/dotfiles.git "$HOME/.dotfiles" && "$HOME/.dotfiles/bootstrap.sh"
```

Optional bootstrap flags:

```sh
~/.dotfiles/bootstrap.sh --dry-run
~/.dotfiles/bootstrap.sh --with-1password
```

Open a new terminal emulator window for changes to take effect!

## 💡 TIP: Test GitHub Signing & Auth Key

To verify that your **GitHub Signing Key** and **GitHub Auth Key** are working correctly, run the following command:

```sh
cd "$HOME/.dotfiles" && git commit --allow-empty -m "$USER fork begins!" && git push && glg -5
```

## Neovim Setup Notes

This config uses native `vim.pack` (not `lazy.nvim`/Mason) and installs core tools via bootstrap:

- `bob` for Neovim versions
- `uv` for Python tools (`basedpyright`, `ruff`)
- `cargo` toolchain for Rust-based CLI tools

## Features

### Zsh

1. [Auto-Complete](https://github.com/marlonrichert/zsh-autocomplete)
1. [Auto-Pair](https://github.com/hlissner/zsh-autopair)
1. [Auto-Suggestions](https://github.com/zsh-users/zsh-autosuggestions)
1. [Syntax-Highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
1. [Plugin Manager: Zap](https://github.com/zap-zsh/zap)

### Bash

1. [Completion + Syntax-Highlighting](https://github.com/akinomyoga/ble.sh)

### Neovim

1. [Native vim.pack](https://neovim.io/doc/user/pack.html#vim.pack)
1. [blink.cmp](https://github.com/Saghen/blink.cmp)
1. [fzf-lua](https://github.com/ibhagwan/fzf-lua)
1. [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua)
1. [conform.nvim](https://github.com/stevearc/conform.nvim)

### Tmux

1. [TPM](https://github.com/tmux-plugins/tpm)
1. [Vim Navigator](https://github.com/christoomey/vim-tmux-navigator)
1. [tmux-fzf](https://github.com/sainnhe/tmux-fzf)
1. [tmux-fzf-url](https://github.com/junegunn/tmux-fzf-url)
1. [Yank](https://github.com/tmux-plugins/tmux-yank)
1. [Sensible](https://github.com/tmux-plugins/tmux-sensible)
1. [Resurrect](https://github.com/tmux-plugins/tmux-resurrect)
1. [Continuum](https://github.com/tmux-plugins/tmux-continuum)

### Sudo

Touch ID auth for `sudo` is configured by `bootstrap.sh` and supports tmux contexts via `pam_reattach`.

### SSH

Configure 1Password as SSH Manager

1. [1Password for SSH & Git](https://developer.1password.com/docs/ssh/get-started)
1. [Connecting to GitHub with SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
1. [Use 1Password to securely authenticate the GitHub CLI](https://developer.1password.com/docs/cli/shell-plugins/github/)

## Fonts

Using [Nerd Fonts](https://www.nerdfonts.com/)
