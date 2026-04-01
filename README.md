# Dotfiles

Personal development environment for macOS and Linux, centered on a fast terminal workflow with Zsh, Neovim, tmux, and XDG-first configuration.

## ✨ Overview

This repository manages:

- shell configuration for Zsh and Bash
- terminal and multiplexer setup (`wezterm`, `tmux`)
- editor configuration (`nvim`, VS Code settings)
- Git, SSH, and CLI tooling
- bootstrap automation for packages, symlinks, editor tooling, and OS defaults

The primary entry point is [`bootstrap.sh`](./bootstrap.sh).

Additional implementation details live in [AGENTS.md](./AGENTS.md).

## ⚡ Requirements

- macOS
- Linux
  - Debian/Ubuntu via `apt`
  - Fedora/RHEL via `dnf`

## 🚀 Installation

Clone the repository and run bootstrap:

```sh
git clone --depth 1 https://github.com/vivek-x-jha/dotfiles.git "$HOME/.dotfiles"
"$HOME/.dotfiles/bootstrap.sh"
```

Bootstrap flags:

```sh
~/.dotfiles/bootstrap.sh --dry-run
~/.dotfiles/bootstrap.sh --with-1password
```

Open a new terminal window after setup completes.

## 🛠️ What Bootstrap Configures

`bootstrap.sh` is the source of truth for workstation setup. It handles:

- platform and package-manager detection
- package installation
- XDG symlink creation
- curated repository clones under `~/Developer`
- Git and GitHub CLI setup
- shell plugin manager installation
- Atuin provisioning
- Touch ID `sudo` configuration on macOS
- Neovim, Rust, and Python CLI tooling

## 📁 Repository Layout

- [`shells`](./shells): shell configuration for Bash, Zsh, ble.sh, and Starship
- [`fzf`](./fzf): shared fzf and zoxide preview configuration
- [`nvim`](./nvim): Neovim configuration
- [`terminals`](./terminals): terminal emulator configuration, including WezTerm and Terminal profiles
- [`tmux`](./tmux): tmux configuration
- [`git`](./git): Git configuration
- [`ssh`](./ssh): SSH configuration
- [`vscode`](./vscode): tracked VS Code settings and theme files
- [`manifests`](./manifests): package manifests such as Brewfile and Linux package lists

## 🔧 Tooling

### Shell

- Zsh with Zap, autosuggestions, syntax highlighting, autopairing, and autocomplete
- Bash with `ble.sh`
- Atuin history integration

### Editor

- Neovim using native `vim.pack`
- `bob` for Neovim version management
- `uv` for Python tooling (`basedpyright`, `ruff`)
- cargo-managed Rust CLI tooling

### Terminal Workflow

- WezTerm
- tmux with TPM, resurrect, continuum, yank, and fzf integrations

## 🧩 VS Code

This repository tracks VS Code settings in [`vscode/settings.json`](./vscode/settings.json).

Bootstrap configures:

- macOS settings symlink at `~/Library/Application Support/Code/User/settings.json`
- Linux settings symlink at `$XDG_CONFIG_HOME/Code/User/settings.json`
- extension and CLI data under `~/.vscode -> $XDG_DATA_HOME/vscode`

## ✅ Validation

After significant changes, a minimal validation pass is:

```sh
~/.dotfiles/bootstrap.sh --dry-run
```

Then verify:

- a new shell loads correctly
- `work` and tmux startup behave as expected
- Neovim passes `:checkhealth`
- `vim.pack.update()` completes cleanly

## 🔗 References

- [Homebrew](https://brew.sh/)
- [Zap](https://github.com/zap-zsh/zap)
- [ble.sh](https://github.com/akinomyoga/ble.sh)
- [Atuin](https://atuin.sh/)
- [WezTerm](https://wezterm.org/)
- [1Password Shell Plugins](https://developer.1password.com/docs/cli/shell-plugins)
