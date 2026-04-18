# Dotfiles

Personal macOS and Linux workstation configuration centered on a fast terminal workflow, XDG-aware paths, Neovim, tmux, WezTerm, Rust-based CLI tools, and 1Password-backed secrets.

[`bootstrap.sh`](./bootstrap.sh) is the setup contract. [`AGENTS.md`](./AGENTS.md) is the operational guide for coding agents and maintainers.

## ✨ Highlights

- 🚀 One bootstrap entry point for packages, symlinks, shell setup, editor tooling, and OS defaults
- 🗂️ XDG-first layout for config, cache, data, and state
- 🐚 Zsh-first interactive shell with Bash parity where practical
- 🔎 fzf, ripgrep, fd, bat, eza, zoxide, and Atuin wired into daily navigation
- 🧠 Neovim managed with native `vim.pack`, `bob`, LSPs, formatters, and custom SourDiesel theming
- 🖥️ WezTerm, tmux, Hammerspoon, and macOS Terminal profiles for terminal workflows
- 🔐 Optional 1Password CLI, shell plugin, Git signing, SSH agent, and Atuin sync setup
- 🧪 Dry-run support before setup changes touch the machine

## 📚 Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Bootstrap Flow](#bootstrap-flow)
- [Repository Layout](#repository-layout)
- [XDG Config Model](#xdg-config-model)
- [Tooling Stack](#tooling-stack)
- [Validation](#validation)
- [Troubleshooting](#troubleshooting)

## ⚠️ Read First

This repository is personal infrastructure. It is written to be repeatable, but it still changes shell startup files, package sets, symlinks, OS defaults, Git configuration, and optional privileged macOS settings.

- Run `bootstrap.sh --dry-run` before applying changes.
- Review [`manifests/Brewfile`](./manifests/Brewfile), [`manifests/apt-packages.txt`](./manifests/apt-packages.txt), and [`manifests/dnf-packages.txt`](./manifests/dnf-packages.txt) before installing packages.
- macOS setup may request `sudo` for Homebrew setup, Touch ID sudo, and OS defaults.
- 1Password integrations are optional, but secret-backed aliases and Git signing expect `op` and the 1Password desktop app to be configured.
- Linux GUI app installation is implemented for `apt` and `dnf`, but desktop environments vary. Treat those steps as best effort.
- Shell startup depends on `$HOME/.zshenv`, `$HOME/.bashrc`, and `$HOME/.bash_profile` symlinks created by bootstrap.

## ⚡ Requirements

### All Platforms

- [`git`](https://git-scm.com/docs)
- `bash`
- `zsh`
- `curl` for package installers, remote manifests, and vendor downloads
- `sudo` for privileged setup steps
- A [Nerd Font](https://www.nerdfonts.com/) if you want icons and glyphs to render correctly. Recommended: [JetBrains Mono Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono), based on [JetBrains Mono](https://github.com/JetBrains/JetBrainsMono).

### macOS

- macOS is the primary platform.
- [`xcode-select`](https://keith.github.io/xcode-man-pages/xcode-select.1.html) command line tools are required.
- [`Homebrew`](https://brew.sh/) is installed or bootstrapped automatically.
- Bootstrap can install or configure:
  - [Hammerspoon](https://www.hammerspoon.org/go)
  - [Karabiner-Elements](https://karabiner-elements.pqrs.org/)
  - [WezTerm](https://wezterm.org/)
  - [1Password](https://developer.1password.com/docs/cli/)

Install Apple Command Line Tools from Terminal:

```sh
[[ $(uname) == Darwin ]] && xcode-select --install
```

Finish the Apple installer before cloning this repo. If `git` is still unavailable afterward, close and reopen Terminal.

Optional: install [1Password for Mac](https://1password.com/downloads/mac/) from Safari before running bootstrap. Open it, sign in, unlock it, and leave it running if you want bootstrap to configure Git signing, SSH, Atuin sync, GitHub CLI wrapping, and secret-backed aliases.

### Linux

- Debian/Ubuntu use `apt`.
- Fedora/RHEL use `dnf` or `dnf5`.
- Optional GUI app installation uses distro package repositories, vendor repositories, `.deb`/`.rpm` downloads, and Flatpak where available.

## 🚀 Installation

Use Safari for the optional 1Password install. Run the command blocks below in Terminal.

Clone the repository:

```sh
git clone https://github.com/vivek-x-jha/dotfiles.git ~/.dotfiles
```

Use `git clone` rather than `curl | sh` because bootstrap symlinks files from the local `~/.dotfiles` checkout.

Preview setup:

```sh
~/.dotfiles/bootstrap.sh --dry-run
```

Run one setup command.

Without 1Password integration:

```sh
~/.dotfiles/bootstrap.sh
```

With 1Password integration prompts:

```sh
~/.dotfiles/bootstrap.sh --with-1password
```

Open a new terminal window after setup completes so login and interactive shell startup are reloaded.

## 🧭 Bootstrap Flow

`bootstrap.sh` executes in this order:

1. 🧬 Detect platform and package manager
2. 🔑 Refresh sudo credentials and detect 1Password
3. 📦 Install platform package sets
4. 🧾 Collect user/runtime environment
5. 🔗 Create symlinks and XDG state directories
6. 🍎 Apply macOS defaults
7. 🔐 Configure Git and GitHub CLI
8. 🧑‍💻 Clone curated repos into `~/Developer`
9. 🧱 Install templates
10. 🐚 Install shell plugin managers
11. 🕰️ Provision Atuin sync
12. 🎨 Build the bat cache
13. 👆 Configure Touch ID sudo on macOS
14. 🤫 Create `~/.hushlogin`
15. 🐚 Set login shell
16. 🔨 Point Hammerspoon at XDG config
17. 🦀 Install Rust toolchain and cargo tools
18. 🧠 Install editor tooling

## 📁 Repository Layout

| Path | Purpose |
|---|---|
| [`bootstrap.sh`](./bootstrap.sh) | Setup orchestrator and source of truth |
| [`shells`](./shells) | Shared shell env, aliases, Bash, Zsh, Starship, ble.sh, and SourDiesel shell colors |
| [`cli`](./cli) | CLI tool configs for Atuin, bat, btop, dust, eza, fzf, gh, glow, mycli, and ripgrep |
| [`editors`](./editors) | Neovim and VS Code configuration |
| [`terminals`](./terminals) | tmux, WezTerm, Terminal.app, and iTerm-related assets |
| [`auth`](./auth) | Git, SSH, 1Password SSH agent config, and signing config |
| [`apps`](./apps) | Hammerspoon, Karabiner, and web extension config exports |
| [`manifests`](./manifests) | Homebrew, apt, and dnf package manifests |
| [`docs`](./docs) | Additional platform notes such as WSL setup |
| [`AGENTS.md`](./AGENTS.md) | Agent workflow and repo maintenance rules |

## 🗂️ XDG Config Model

This repo follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/0.8/) where practical:

| Variable | Default in this repo | Purpose |
|---|---|---|
| `XDG_CONFIG_HOME` | `~/.config` | User config |
| `XDG_CACHE_HOME` | `~/.cache` | Cache files |
| `XDG_DATA_HOME` | `~/.local/share` | User data and installed tool data |
| `XDG_STATE_HOME` | `~/.local/state` | Logs, histories, state, and runtime history |

Bootstrap links repo-managed config into XDG paths where the tool supports it directly, and uses env vars, flags, symlinks, or platform overrides where it does not.

### ✅ Native or Standard XDG Configs

| Tool | Config path | Reference |
|---|---|---|
| [Atuin](https://docs.atuin.sh/cli/configuration/config/) | `~/.config/atuin/config.toml` | Atuin documents config in `~/.config/atuin` and data in `~/.local/share/atuin`. |
| [bat](https://github.com/sharkdp/bat#configuration-file) | `~/.config/bat/config` | `bat --config-file`, `BAT_CONFIG_PATH`, and `BAT_CONFIG_DIR` are supported. |
| [btop](https://github.com/aristocratos/btop) | `~/.config/btop/btop.conf` | btop uses XDG-style config and theme directories. |
| [dust](https://github.com/bootandy/dust) | `~/.config/dust/config.toml` | Repo-managed TOML config. |
| [eza](https://man.archlinux.org/man/extra/eza/eza.1.en) | `~/.config/eza` | `EZA_CONFIG_DIR` defaults to `$XDG_CONFIG_HOME/eza` or `~/.config/eza`. |
| [GitHub CLI](https://cli.github.com/manual/) | `~/.config/gh/config.yml` | gh stores CLI config under XDG config. |
| [Git](https://git-scm.com/docs/git-config) | `~/.config/git/config` | Git supports an XDG global config path. |
| [Glow](https://github.com/charmbracelet/glow) | `~/.config/glow/glow.yml` | Used with `GLAMOUR_STYLE` for the SourDiesel style. |
| [Karabiner-Elements](https://karabiner-elements.pqrs.org/docs/manual/) | `~/.config/karabiner/karabiner.json` | Native user config path. |
| [Neovim](https://neovim.io/doc/user/starting/#standard-path) | `~/.config/nvim` | Neovim uses `stdpath()` and XDG base dirs. |
| [1Password SSH agent](https://developer.1password.com/docs/ssh/agent/config) | `~/.config/1Password/ssh/agent.toml` | 1Password documents this config and supports `XDG_CONFIG_HOME`. |
| [Starship](https://starship.rs/config/) | `~/.config/starship.toml` | Default config path; can be overridden with `STARSHIP_CONFIG`. |
| [tmux](https://man7.org/linux/man-pages/man1/tmux.1.html) | `~/.config/tmux/tmux.conf` | Modern tmux can load XDG config. |
| [WezTerm](https://wezterm.org/config/files.html) | `~/.config/wezterm/wezterm.lua` | WezTerm searches `$XDG_CONFIG_HOME/wezterm/wezterm.lua`. |

### 🔁 Explicitly Redirected Configs

| Tool | Mechanism | Local choice |
|---|---|---|
| [Zsh](https://zsh.sourceforge.io/Intro/intro_3.html) | `ZDOTDIR` | `ZDOTDIR="$XDG_CONFIG_HOME/shells/zsh"` |
| Bash | home startup symlinks | `~/.bashrc` and `~/.bash_profile` source `~/.config/shells/bash` |
| [ble.sh](https://github.com/akinomyoga/ble.sh) | `--rcfile` | `source "$XDG_DATA_HOME/blesh/ble.sh" --rcfile "$SHELL_CONFIG/bash/.blerc"` |
| [ripgrep](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file) | `RIPGREP_CONFIG_PATH` | `~/.config/ripgrep/config` |
| [mycli](https://www.mycli.net/connect) | `--myclirc` | aliases pass `--myclirc "$XDG_CONFIG_HOME/mycli/config"` |
| [Hammerspoon](https://www.hammerspoon.org/docs/hs.html#configdir) | macOS defaults override | `MJConfigFile="$XDG_CONFIG_HOME/hammerspoon/init.lua"` |
| [OpenSSH](https://man.openbsd.org/ssh_config) | explicit config in Git | Git uses `ssh -F ~/.config/ssh/config` |
| [fzf](https://junegunn.github.io/fzf/shell-integration/) | shell integration source | `eval "$(fzf --zsh)"` or `eval "$(fzf --bash)"`, then source `~/.config/fzf/fzf.sh` |
| [eza colors](https://www.mankier.com/5/eza_colors) | `LS_COLORS`/`EZA_COLORS` | shell startup evaluates `~/.config/eza/.dircolors` |

### 📦 XDG Data and State Moves

| Tool | Variable/path | Purpose |
|---|---|---|
| [rustup](https://rust-lang.github.io/rustup/installation/index.html) | `RUSTUP_HOME="$XDG_DATA_HOME/rustup"` | Rust toolchains and rustup settings |
| [Cargo](https://doc.rust-lang.org/cargo/) | `CARGO_HOME="$XDG_DATA_HOME/cargo"` | Cargo bin, registry, and cache-like data |
| [zoxide](https://github.com/ajeetdsouza/zoxide#environment-variables) | `_ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"` | Jump database |
| tmux plugins | `TMUX_PLUGIN_MANAGER_PATH="$XDG_DATA_HOME/tmux/plugins"` | TPM plugin installs |
| Codex | `CODEX_HOME="$XDG_STATE_HOME/codex"` | Codex state |
| Neovim | `NVIM_LOG_FILE="$XDG_STATE_HOME/nvim/.nvimlog"` | Neovim log |
| Python | `PYTHON_HISTORY="$XDG_STATE_HOME/python/.python_history"` | Python REPL history |
| MySQL | `MYSQL_HISTFILE="$XDG_STATE_HOME/mysql/.mysql_history"` | MySQL history |
| MyCLI | `MYCLI_HISTFILE="$XDG_STATE_HOME/mycli/.mycli_history"` | MyCLI history |

## 🧰 Tooling Stack

### 🐚 Shell

- [Zsh](https://zsh.sourceforge.io/) is the primary interactive shell.
- [Zap](https://www.zapzsh.com/) manages Zsh plugins.
- [ble.sh](https://github.com/akinomyoga/ble.sh) provides Bash line editing and completion.
- [Starship](https://starship.rs/) renders the prompt.
- [Atuin](https://atuin.sh/) replaces shell history with searchable SQLite-backed history and optional encrypted sync.
- Shared aliases and functions live under [`shells`](./shells).
- Bash functions mirror Zsh functions where practical so Bash does not rely on Zsh wrappers.

### 🔎 Search and Navigation

- [fzf](https://junegunn.github.io/fzf/) powers fuzzy file, directory, history, and tmux flows.
- [ripgrep](https://github.com/BurntSushi/ripgrep) handles fast text search through `RIPGREP_CONFIG_PATH`.
- [fd](https://github.com/sharkdp/fd) is used when available for file discovery.
- [bat](https://github.com/sharkdp/bat) provides syntax-highlighted previews and manpage rendering.
- [eza](https://github.com/eza-community/eza) replaces `ls` and tree-style directory display.
- [zoxide](https://github.com/ajeetdsouza/zoxide) provides smarter `cd`.

### 🧠 Editors

- [Neovim](https://neovim.io/) config lives in [`editors/nvim`](./editors/nvim).
- Neovim plugins are managed with native [`vim.pack`](https://neovim.io/doc/user/pack.html).
- [bob](https://github.com/MordechaiHadad/bob) manages Neovim stable/nightly installs.
- [uv](https://docs.astral.sh/uv/) installs Python tools such as `basedpyright` and `ruff`.
- VS Code settings live in [`editors/vscode`](./editors/vscode).

### 🖥️ Terminals and tmux

- [WezTerm](https://wezterm.org/) config lives in [`terminals/wezterm`](./terminals/wezterm).
- [tmux](https://github.com/tmux/tmux/wiki) config lives in [`terminals/tmux`](./terminals/tmux).
- tmux plugins are managed by [TPM](https://github.com/tmux-plugins/tpm).
- macOS Terminal and iTerm-related profile assets live under [`terminals`](./terminals).
- Hammerspoon automates floating terminal behavior, window management, and app hotkeys.

### 🔐 Auth and Secrets

- Git config and signing live under [`auth/git`](./auth/git).
- SSH client config, known hosts, and allowed signers live under [`auth/ssh`](./auth/ssh).
- [1Password CLI](https://developer.1password.com/docs/cli/) is optional but enables secret-backed aliases.
- [1Password Shell Plugins](https://developer.1password.com/docs/cli/shell-plugins) wrap supported CLIs such as `gh`.
- [1Password SSH Agent](https://developer.1password.com/docs/ssh/agent/) signs SSH requests without private keys leaving 1Password.

## 🧩 VS Code

This repository tracks VS Code settings in [`editors/vscode/settings.json`](./editors/vscode/settings.json).

Bootstrap configures:

- `~/.config/vscode -> ~/.dotfiles/editors/vscode`
- macOS settings symlink at `~/Library/Application Support/Code/User/settings.json`
- Linux settings symlink at `$XDG_CONFIG_HOME/Code/User/settings.json`
- extension and CLI data under `~/.vscode -> $XDG_DATA_HOME/vscode`

Notes:

- macOS VS Code does not use `~/.config/Code/User/settings.json`; it uses `~/Library/Application Support/Code/User`.
- Linux VS Code uses `$XDG_CONFIG_HOME/Code/User/settings.json`.
- `~/.config/vscode` is the repo source grouping, not VS Code's native app config target.

## 🔐 1Password Integration

1Password is optional. When enabled, bootstrap can:

- sign in to `op`
- fetch Git identity and signing material
- configure Git signing through 1Password
- create or update Atuin sync credentials
- link 1Password SSH agent configuration
- wrap supported CLI aliases through `op plugin run`

Requirements:

- 1Password desktop app installed and unlocked
- `op` CLI installed and authenticated
- SSH keys imported into 1Password if using SSH agent
- GitHub CLI authenticated or wrapped through 1Password shell plugins

Security notes:

- The 1Password SSH agent config is not a secret, but it can reveal item/vault/account names.
- Prefer item IDs in `agent.toml` if you do not want those names in plaintext.
- `mycli` and `mysql` aliases fetch passwords dynamically from 1Password rather than writing them to disk.

## 🦀 Rust and CLI Tools

Bootstrap sets:

```sh
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export PATH="$CARGO_HOME/bin:$PATH"
```

The Rust install flow:

1. Installs rustup if missing.
2. Updates the stable toolchain.
3. Installs `cargo-update`.
4. Installs cargo-managed CLI tools from the Brewfile cargo section.

`update-all` asks before running `cargo install-update -a --git`. The default answer is **No** when pressing Enter.

## 📦 Package Management

### macOS

Homebrew setup uses [`brew bundle`](https://docs.brew.sh/Brew-Bundle-and-Brewfile) and [`manifests/Brewfile`](./manifests/Brewfile).

The Brewfile includes:

- Homebrew formulae
- casks
- VS Code extensions
- cargo-installed tools
- uv-installed Python tools

Useful checks:

```sh
brew bundle check --file "$HOME/.dotfiles/manifests/Brewfile"
brew bundle install --file "$HOME/.dotfiles/manifests/Brewfile"
brew doctor
```

### Linux

Linux packages are split by package manager:

- [`manifests/apt-packages.txt`](./manifests/apt-packages.txt)
- [`manifests/dnf-packages.txt`](./manifests/dnf-packages.txt)

GUI apps are installed through distro repos, vendor repos, direct packages, or Flatpak where available.

## 🧪 Validation

After significant changes:

```sh
~/.dotfiles/bootstrap.sh --dry-run
bash -n ~/.dotfiles/bootstrap.sh
```

Then verify:

- 🐚 Open a new Zsh shell and confirm prompt, aliases, functions, Atuin, fzf, and Starship load.
- 🐚 Open Bash and confirm ble.sh, aliases, functions, Atuin, fzf, and Starship load.
- 🧭 Run `work` and confirm tmux session layout and pane titles behave correctly.
- 🧠 Open Neovim and run `:checkhealth`.
- 📦 Run `vim.pack.update()` and confirm the `blink.cmp` Rust build hook runs when needed.
- 🎨 Run `bat cache --build` after changing bat themes or syntaxes.
- 🔐 Run `ssh -T git@github.com` and `git log --show-signature -1` when changing auth config.

## 🔄 Updates

Interactive update helper:

```sh
update-all
```

Typical manual update checks:

```sh
brew update
brew upgrade
brew bundle check --file "$HOME/.dotfiles/manifests/Brewfile"
rustup update stable
cargo install-update -a --git
uv tool upgrade --all
bat cache --build
```

Use `cargo install --list` to inspect cargo-managed tools. Use `cargo uninstall <tool>` for tools that should no longer be managed by cargo.

## 🛠️ Common Tasks

### Rebuild bat Cache

```sh
bat cache --build
```

### Reload tmux Config

Inside tmux:

```tmux
prefix r
```

Or:

```sh
tmux source-file "$XDG_CONFIG_HOME/tmux/tmux.conf"
```

### Check Atuin Paths

```sh
atuin info
```

### Inspect Neovim Paths

```vim
:echo stdpath("config")
:echo stdpath("data")
:echo stdpath("state")
:echo $NVIM_LOG_FILE
```

### Verify VS Code Symlinks

```sh
ls -l "$HOME/.config/vscode"
ls -l "$HOME/.vscode"
```

On macOS:

```sh
ls -l "$HOME/Library/Application Support/Code/User/settings.json"
```

On Linux:

```sh
ls -l "$XDG_CONFIG_HOME/Code/User/settings.json"
```

## 🧯 Troubleshooting

### Shell Does Not Load

- Start with `zsh -dfi` to bypass startup files.
- Check `~/.zshenv` points at `~/.config/shells/env`.
- Check `ZDOTDIR="$XDG_CONFIG_HOME/shells/zsh"`.
- Check `$PATH` includes Homebrew, Cargo, uv tools, and bob nvim bin paths.

### Bash Loads but ble.sh Fails

- Confirm `"$XDG_DATA_HOME/blesh/ble.sh"` exists.
- Confirm `.bashrc` sources ble.sh with `--rcfile "$SHELL_CONFIG/bash/.blerc"`.
- Open a plain shell with `bash --noprofile --norc` if startup is broken.

### Neovim Plugin or Highlighting Issues

- Run `:checkhealth`.
- Run `vim.pack.update()`.
- Clear stale parser/plugin state only after confirming the failing plugin path.
- Confirm `NVIM_LOG_FILE` points at `$XDG_STATE_HOME/nvim/.nvimlog`.

### Atuin Migration Errors

- Back up `~/.local/share/atuin/history.db` before editing migrations.
- Use `atuin info` to confirm paths.
- Check `~/.config/atuin/config.toml` for log directory and sync settings.

### Touch ID sudo Does Not Work

- Confirm `/etc/pam.d/sudo_local` exists.
- Confirm `pam_reattach` is installed through Homebrew.
- Newer macOS versions may require `pam_tid.so.2`; bootstrap detects that when present.

### Git Signing or SSH Fails

- Confirm 1Password is unlocked.
- Confirm `SSH_AUTH_SOCK` points at the 1Password agent socket if using SSH agent.
- Check [`auth/git/config`](./auth/git/config) and [`auth/ssh/config`](./auth/ssh/config).
- Run `ssh-add -l` to see keys visible to the active agent.

## 🧑‍💻 Maintainer Notes

- Keep setup behavior in `bootstrap.sh`.
- Keep source files in this repo; avoid editing generated files directly.
- Update `README.md` and `AGENTS.md` when user-facing setup behavior changes.
- Keep macOS, apt, and dnf branches explicit.
- Preserve `--dry-run` support by routing mutating commands through `run` where practical.
- Prefer `require <bin>` guards for optional integrations.
- Never commit local machine secrets.

## 🔗 References

- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/0.8/)
- [Homebrew Bundle and Brewfile](https://docs.brew.sh/Brew-Bundle-and-Brewfile)
- [1Password CLI](https://developer.1password.com/docs/cli/)
- [1Password Shell Plugins](https://developer.1password.com/docs/cli/shell-plugins)
- [1Password SSH Agent](https://developer.1password.com/docs/ssh/agent/)
