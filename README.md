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
- [AI Workflows](#ai-workflows)
- [Validation](#validation)
- [Troubleshooting](#troubleshooting)
- [Known Issues](./docs/known-issues.md)

## ⚠️ Read First

This repository is personal infrastructure. It is written to be repeatable, but it still changes shell startup files, package sets, symlinks, OS defaults, Git configuration, and optional privileged macOS settings.

- Run `bootstrap.sh --dry-run` before applying changes.
- Review [`manifests/Brewfile`](./manifests/Brewfile), [`manifests/apt-packages.txt`](./manifests/apt-packages.txt), and [`manifests/dnf-packages.txt`](./manifests/dnf-packages.txt) before installing packages.
- macOS setup may request `sudo` for Homebrew setup, Touch ID sudo, and OS defaults.
- 1Password integrations are optional, but secret-backed aliases and Git signing expect `op` and the 1Password desktop app to be configured.
- Linux GUI app installation is implemented for `apt` and `dnf`, but desktop environments vary. Treat those steps as best effort.
- Shell startup depends on `$HOME/.zshenv`, `$HOME/.bashrc`, and `$HOME/.bash_profile` symlinks created by bootstrap. `$HOME/.zshenv -> ~/.config/shells/env` is the always-on environment entry point for Zsh and carries shared PATH/tool exports for login, interactive, non-interactive, and agent-launched shells. Zsh loads the shared login setup through `$ZDOTDIR/.zprofile -> ../profile`; login-only secret loading lives in `shells/profile`. Bootstrap check and doctor modes validate both Zsh symlink targets.

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

For a fresh Ubuntu or WSL environment, install the minimum prerequisites first:

```sh
sudo apt update
sudo apt install -y git curl sudo bash zsh
```

Then clone this repo and run bootstrap from the local checkout:

```sh
git clone --depth 1 https://github.com/vivek-x-jha/dotfiles.git ~/.dotfiles
~/.dotfiles/bootstrap.sh --check
~/.dotfiles/bootstrap.sh --doctor
~/.dotfiles/bootstrap.sh --dry-run
~/.dotfiles/bootstrap.sh
```

On WSL, GUI application installs are best-effort and can be skipped. The shell, tmux, Neovim, CLI, Git, fzf, and XDG symlink setup are the useful paths there.

## 🚀 Installation

On macOS, use Safari for the optional 1Password install. Run the command blocks below in Terminal.

Clone the repository:

```sh
git clone --depth 1 https://github.com/vivek-x-jha/dotfiles.git ~/.dotfiles
```

Use `git clone` rather than `curl | sh` because bootstrap symlinks files from the local `~/.dotfiles` checkout. `--depth 1` is fastest for a fresh machine; run `git fetch --unshallow` later if full history is needed.

Preview setup:

```sh
~/.dotfiles/bootstrap.sh --dry-run
```

Run one setup command.

Without 1Password integration:

```sh
~/.dotfiles/bootstrap.sh
```

By default, bootstrap uses the tracked defaults in [`bootstrap/defaults.env`](./bootstrap/defaults.env) and runs without setup questions. User overrides can be placed in `$XDG_CONFIG_HOME/dotfiles/bootstrap.env`.

With explicit prompts:

```sh
~/.dotfiles/bootstrap.sh --interactive
```

With 1Password integration:

```sh
~/.dotfiles/bootstrap.sh --with-1password
```

Fresh and partial setup are both first-class:

```sh
~/.dotfiles/bootstrap.sh --fresh --dry-run
~/.dotfiles/bootstrap.sh --partial --only codex,symlinks,ide --dry-run
~/.dotfiles/bootstrap.sh --skip rust,ide
~/.dotfiles/bootstrap.sh --list-targets
```

For Homebrew app selection, keep the Brewfile as the source of truth and choose casks by config:

```sh
BOOTSTRAP_BREW_CASK_MODE=only
BOOTSTRAP_BREW_CASKS="1password 1password-cli wezterm visual-studio-code"
```

Open a new terminal window after setup completes so login and interactive shell startup are reloaded.

Open the optional SourDiesel orbital installer UI:

```sh
~/.dotfiles/bootstrap.sh --tui
```

`--tui` launches the Rust `sourdiesel-bootstrap` frontend when `cargo` or an installed binary is available, and falls back to a plain numbered Bash menu on fresh machines.

Validate the installed workstation state any time after setup:

```sh
~/.dotfiles/bootstrap.sh --doctor
```

`--doctor` is read-only and does not request elevated privileges.

## 🧭 Bootstrap Flow

`bootstrap.sh` is now a thin orchestrator. It loads defaults and local overrides, sources implementation modules from [`bootstrap/lib`](./bootstrap/lib), then executes a fixed phase list:

1. 🧬 Detect platform and package manager
2. 🔑 Refresh sudo credentials and detect 1Password
3. 📦 Install platform package sets
4. 🧾 Collect user/runtime environment
5. 🔗 Create symlinks and XDG state directories
6. 🎨 Apply Codex SourDiesel UI preferences
7. 🍎 Apply macOS defaults
8. 🔐 Configure Git and GitHub CLI
9. 🧑‍💻 Optionally clone curated repos into `~/Developer`
10. 🧱 Optionally install templates
11. 🐚 Install shell plugin managers
12. 🕰️ Optionally provision Atuin sync
13. 🎨 Build the bat cache
14. 👆 Optionally configure Touch ID sudo on macOS
15. 🤫 Create `~/.hushlogin`
16. 🐚 Optionally set login shell
17. 🔨 Point Hammerspoon at XDG config
18. 🦀 Install Rust toolchain and cargo tools
19. 🕵️ Optionally install CIA from upstream GitHub via Cargo
20. 🧠 Install editor tooling

## 📁 Repository Layout

| Path | Purpose |
|---|---|
| [`bootstrap.sh`](./bootstrap.sh) | Thin setup entrypoint and phase orchestrator |
| [`bootstrap`](./bootstrap) | Bootstrap defaults and sourced implementation modules |
| [`tools/sourdiesel-bootstrap`](./tools/sourdiesel-bootstrap) | Optional Rust orbital installer TUI frontend for bootstrap tasks |
| [`ai`](./ai) | AI assistant global policy, project memory templates, and managed harness configs for Claude Code, Codex, Pi, and CIA |
| [`shells`](./shells) | Shared shell env/profile, aliases, Bash, Zsh, Starship, ble.sh, and SourDiesel shell colors |
| [`cli`](./cli) | CLI tool configs for Atuin, bat, btop, dust, eza, fzf, gh, glow, Matplotlib, mycli, npm, and ripgrep |
| [`editors`](./editors) | Neovim and VS Code configuration |
| [`terminals`](./terminals) | tmux, WezTerm, Terminal.app, and iTerm-related assets |
| [`auth`](./auth) | Git, SSH, 1Password SSH agent config, and signing config |
| [`apps`](./apps) | Hammerspoon, Karabiner, and web extension config exports |
| [`manifests`](./manifests) | Homebrew, apt, and dnf package manifests |
| [`docs`](./docs) | Additional platform notes, AI workflows, agent memory, and known issues |
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
| [Git](https://git-scm.com/docs/git-config) | `~/.config/git/config` | Git supports an XDG global config path. Main Git settings live in `auth/git/config`; SourDiesel styling is included from `auth/git/themes/sourdiesel`. |
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
| [Zsh](https://zsh.sourceforge.io/Intro/intro_3.html) | home `.zshenv` + `ZDOTDIR` | `~/.zshenv -> ~/.config/shells/env` is the always-on env/PATH entry point; `ZDOTDIR="$XDG_CONFIG_HOME/shells/zsh"`; `.zprofile -> ../profile` loads the shared Bash/Zsh profile for login shells, while `.zshrc` sources the same idempotent profile for non-login interactive shells |
| [zsh-patina](https://github.com/michel-kraemer/zsh-patina) | default config path | `~/.config/zsh-patina/config.toml` |
| Bash | home startup symlinks | `~/.bashrc` and `~/.bash_profile` source `~/.config/shells/bash`; shared PATH setup comes from `~/.config/shells/env` and guarded login/interactive setup comes from `~/.config/shells/profile` |
| [ble.sh](https://github.com/akinomyoga/ble.sh) | `--rcfile` | `source "$XDG_DATA_HOME/blesh/ble.sh" --rcfile "$SHELL_CONFIG/bash/.blerc"` |
| [ripgrep](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file) | `RIPGREP_CONFIG_PATH` | `~/.config/ripgrep/config` |
| [mycli](https://www.mycli.net/connect) | `--myclirc` | 1Password-backed aliases pass `--myclirc "$XDG_CONFIG_HOME/mycli/config"` |
| [Hammerspoon](https://www.hammerspoon.org/docs/hs.html#configdir) | macOS defaults override | `MJConfigFile="$XDG_CONFIG_HOME/hammerspoon/init.lua"` |
| [OpenSSH](https://man.openbsd.org/ssh_config) | explicit config in Git | Git uses `ssh -F ~/.config/ssh/config` |
| [fzf](https://junegunn.github.io/fzf/shell-integration/) | shell integration source | Bootstrap installs upstream fzf to `$XDG_DATA_HOME/fzf`; shell startup prepends `$XDG_DATA_HOME/fzf/bin` when present, then uses `fzf --zsh`/`fzf --bash` and `~/.config/fzf/config` |
| [eza colors](https://www.mankier.com/5/eza_colors) | `LS_COLORS`/`EZA_COLORS` | shell startup exports the colors directly from `shells/colors/sourdiesel` |

### 📦 XDG Data and State Moves

| Tool | Variable/path | Purpose |
|---|---|---|
| [rustup](https://rust-lang.github.io/rustup/installation/index.html) | `RUSTUP_HOME="$XDG_DATA_HOME/rustup"` | Rust toolchains and rustup settings |
| [Cargo](https://doc.rust-lang.org/cargo/) | `CARGO_HOME="$XDG_DATA_HOME/cargo"` | Cargo bin, registry, and cache-like data |
| [zoxide](https://github.com/ajeetdsouza/zoxide#environment-variables) | `_ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"` | Jump database |
| tmux plugins | `TMUX_PLUGIN_MANAGER_PATH="$XDG_DATA_HOME/tmux/plugins"` | TPM plugin installs |
| Codex | `CODEX_HOME="$XDG_STATE_HOME/codex"` | Codex CLI state and runtime-owned `config.toml`; bootstrap exports this for shells, links `$CODEX_HOME/AGENTS.md -> ../../../.dotfiles/ai/AGENTS.md` for global instructions, and only merges known SourDiesel UI preference keys from `ai/codex`. |
| Pi coding agent | `PI_CODING_AGENT_DIR="$XDG_STATE_HOME/pi/agent"` | Pi auth, sessions, settings, and runtime state stay in XDG state; bootstrap links `AGENTS.md -> ../../../../.dotfiles/ai/AGENTS.md`, plus repo-managed `ai/pi/models.json` and `ai/pi/themes/sourdiesel.json`, into that agent dir for global instructions, local Ollama models, and the SourDiesel TUI theme. |
| [Ollama](https://github.com/ollama/ollama) | `OLLAMA_HOST="127.0.0.1:11434"`, `OLLAMA_FLASH_ATTENTION=1`, `OLLAMA_KV_CACHE_TYPE=q8_0` | Local model runner endpoint and Apple Silicon-friendly runtime defaults used by Pi's OpenAI-compatible `ollama` provider. |
| [Claude Code](https://code.claude.com/docs/en/env-vars) | `CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"` | Bootstrap links repo-managed `ai/claude-code/settings.json` plus `CLAUDE.md -> ../../.dotfiles/ai/AGENTS.md` into Claude's config dir; Claude-owned runtime state such as `~/.claude.json` is left unmanaged. |
| Neovim | `NVIM_LOG_FILE="$XDG_STATE_HOME/nvim/nvim.log"` | Neovim log |
| Python | `PYTHON_HISTORY="$XDG_STATE_HOME/python/.python_history"` | Python REPL history |
| [IPython](https://ipython.readthedocs.io/en/stable/development/config.html) | `IPYTHONDIR="$XDG_STATE_HOME/ipython"` | IPython profiles mix config with runtime DB/history files |
| [Matplotlib](https://matplotlib.org/stable/install/environment_variables_faq.html) | `MPLCONFIGDIR="$XDG_CONFIG_HOME/matplotlib"` | `~/.config/matplotlib` links to `cli/matplotlib`; only `matplotlibrc` is tracked because Matplotlib also writes generated cache there. |
| [Jupyter](https://docs.jupyter.org/en/latest/use/jupyter-directories.html#environment-variables) | `JUPYTER_CONFIG_DIR`, `JUPYTER_DATA_DIR`, `JUPYTER_RUNTIME_DIR` | Jupyter config, kernels/data, and runtime files |
| MySQL | `MYSQL_HISTFILE="$XDG_STATE_HOME/mysql/.mysql_history"` | MySQL history |
| MyCLI | `MYCLI_HISTFILE="$XDG_STATE_HOME/mycli/.mycli_history"` | MyCLI history |
| [npm](https://docs.npmjs.com/cli/v11/using-npm/config#environment-variables) | `NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"` | Repo-managed npm config points cache and logs at `$XDG_CACHE_HOME/npm`. |

## 🧰 Tooling Stack

### 🐚 Shell

- [Zsh](https://zsh.sourceforge.io/) is the primary interactive shell.
- [Zap](https://www.zapzsh.com/) manages source-only Zsh plugins.
- [zsh-patina](https://github.com/michel-kraemer/zsh-patina) provides Zsh syntax highlighting from a Cargo-installed executable and repo-managed SourDiesel config under [`cli/zsh-patina`](./cli/zsh-patina). Its Zsh completion script is generated with `zsh-patina completion`, and it reads `~/.config/zsh-patina/config.toml` by default.
- `zsh-autocomplete` carries a repo-managed FD cleanup patch under [`shells/zsh/patches`](./shells/zsh/patches); `update-tools` reverses it before `zap update all` and reapplies it afterward.
- Zsh Atuin non-popup search carries a repo-managed tty/temp-file capture patch under [`shells/zsh/patches`](./shells/zsh/patches) so Tab/Enter selections work without relying on Atuin's generated fd-swapping path.
- [ble.sh](https://github.com/akinomyoga/ble.sh) provides Bash line editing and completion.
- [Starship](https://starship.rs/) renders the prompt.
- [Atuin](https://atuin.sh/) replaces shell history with searchable SQLite-backed history and optional encrypted sync.
- Shared aliases and functions live under [`shells`](./shells).
- `work <name>` creates tmux project sessions under `~/Developer`; when it creates a new named project, it also copies `AGENTS.md`, `docs/known-issues.md`, and `docs/agent-memory.md` from [`ai/templates`](./ai/templates), then creates `CLAUDE.md -> AGENTS.md` for Claude Code.
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
- CIA is a standalone Codex/Pi chat/project TUI from [`vivek-x-jha/cia`](https://github.com/vivek-x-jha/cia). Its SourDiesel config lives in [`ai/cia`](./ai/cia), defaults to the Pi harness, uses transparent popup backgrounds, v1.4 status-pane colors, and Codex/Pi harness icons; tmux prefix + `g` opens it in a 75% popup.
- Install it explicitly with `~/.dotfiles/bootstrap.sh --only cia`; the target is disabled by default and runs `cargo install --locked --git https://github.com/vivek-x-jha/cia`.
- Pi's repo-managed config lives under [`ai/pi`](./ai/pi): bootstrap links `$PI_CODING_AGENT_DIR/AGENTS.md -> ../../../../.dotfiles/ai/AGENTS.md` for global instructions; `models.json` is symlinked to `$PI_CODING_AGENT_DIR/models.json` and points Pi at Ollama's OpenAI-compatible endpoint for free local models such as `qwen2.5-coder:7b`; `themes/sourdiesel.json` is symlinked into `$PI_CODING_AGENT_DIR/themes/` and keeps Markdown/code blocks on `BLACK_HEX` text with straight `color237` section separators matching unfocused tmux panes.
- [tmux](https://github.com/tmux/tmux/wiki) config lives in [`terminals/tmux`](./terminals/tmux).
- tmux status uses one local `scripts/sys.sh` segment for CPU, GPU when measurable, RAM, and battery to avoid flicker from staggered plugin shell commands. GPU and battery segments auto-hide when unsupported; icons are configurable with `@sys_cpu_icon`, `@sys_gpu_icon`, and `@sys_ram_icon`.
- tmux plugins are managed by [TPM](https://github.com/tmux-plugins/tpm).
- macOS Terminal and iTerm-related profile assets live under [`terminals`](./terminals).
- Hammerspoon automates floating terminal behavior, window management, and app hotkeys.

### 🎨 SourDiesel palette

[`themes/sourdiesel/palette.toml`](./themes/sourdiesel/palette.toml) is the source of truth for the shared 16-color ANSI palette, common extras, consumer inventory, and approved legacy outliers. The generated [`themes/sourdiesel/README.md`](./themes/sourdiesel/README.md) groups actual color use across terminal, shell, icon, syntax, editor, and application consumers.

Native application theme files remain hand-authored. After changing the palette or a consumer, run `python3 themes/sourdiesel/tool.py render`; `python3 themes/sourdiesel/tool.py check` validates palette mirrors, reports new or stale outliers, compares overlapping eza and web-devicons mappings, and detects a stale generated report. The Terminal.app profile is inventoried but remains a manual check because its NSColor values are archived in the profile plist.

### 🔐 Auth and Secrets

- Git config, identity, and signing live in [`auth/git/config`](./auth/git/config), and theme settings are included from [`auth/git/themes/sourdiesel`](./auth/git/themes/sourdiesel).
- SSH client config, known hosts, and allowed signers live under [`auth/ssh`](./auth/ssh). File-backed private keys live under `~/.config/ssh/keys/`, and the base SSH config includes the selected backend file directly from `~/.config/ssh/identities/`, such as `1password` or `ssh-agent`.
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
- configure Git signing through 1Password or OpenSSH
- create or update Atuin sync credentials
- link 1Password SSH agent configuration
- wrap supported CLI aliases such as `gh` through `op plugin run`
- provide 1Password-backed `mysql`, `mysql-root`, `mycli`, and `mycli-root` aliases

Requirements:

- 1Password desktop app installed and unlocked
- `op` CLI installed and authenticated
- SSH keys imported into 1Password if using SSH agent
- GitHub CLI authenticated or wrapped through 1Password shell plugins

Security notes:

- The 1Password SSH agent config is not a secret, but it can reveal item/vault/account names.
- Prefer item IDs in `agent.toml` if you do not want those names in plaintext.
- `mysql` and `mycli` aliases expect 1Password items named `MySQL User: <user>` in the `Private` vault with a `password` field.
- `mysql` and `mycli` aliases write credentials only to `chmod 600` temporary files for client startup, then remove them.

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
4. Installs cargo-managed CLI tools from the Brewfile cargo section, including `zsh-patina` for Zsh syntax highlighting and completion generation.

`update-tools` runs the standard maintenance set without TeX Live. `update-tools --all` also updates TeX Live, while individual flags select only the requested steps, such as `--nvim`, `--pi`, `--rust`, `--brew`, `--zsh`, `--tmux`, or `--tex`. Zsh plugin updates reverse and reapply the repo-managed `zsh-autocomplete` FD cleanup patch so Zap can still pull upstream changes.
The macOS cask upgrade uses `--no-quit` so running apps cannot relaunch nested helpers before the recursive quarantine pass completes. Restart upgraded apps manually to use their new versions. The quarantine pass only targets apps that are actually installed under `/Applications`, so missing apps are skipped with a warning instead of failing the whole run.

## 📦 Package Management

### macOS

Homebrew setup uses [`brew bundle`](https://docs.brew.sh/Brew-Bundle-and-Brewfile) and [`manifests/Brewfile`](./manifests/Brewfile). Cask selection supports `BOOTSTRAP_BREW_CASK_MODE=all`, `skip`, or `only` with `BOOTSTRAP_BREW_CASKS`; formulae, VS Code extensions, cargo tools, and uv tools remain installed from the selected Brewfile.

fzf is installed from upstream git into `$XDG_DATA_HOME/fzf` with `install --bin --no-update-rc` instead of through Homebrew, apt, or dnf.

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

GitHub CLI and Glow are installed from their official Linux repositories because Debian/Ubuntu and Fedora need vendor repos before those packages can be installed reliably.

GUI apps are installed through distro repos, vendor repos, direct packages, or Flatpak where available.

## 🧪 Validation

After significant changes:

```sh
~/.dotfiles/bootstrap.sh --check
~/.dotfiles/bootstrap.sh --doctor
~/.dotfiles/bootstrap.sh --dry-run
bash -n ~/.dotfiles/bootstrap.sh
```

Then verify:

- 🐚 Open a new Zsh shell and confirm prompt, aliases, functions, Atuin, fzf, and Starship load.
- 🐚 Open Bash and confirm ble.sh, aliases, functions, Atuin, fzf, and Starship load.
- 🧭 Run `work` and confirm tmux session layout, pane titles, and new-project AI memory scaffolding behave correctly.
- 🧠 Open Neovim and run `:checkhealth`.
- 📦 Run `vim.pack.update()` and confirm the `blink.cmp` Rust build hook runs when needed.
- 🎨 Run `bat cache --build` after changing bat themes or syntaxes.
- 🔐 Run `ssh -T git@github.com` and `git log --show-signature -1` when changing auth config.

## 🤖 AI Workflows

Reusable prompt workflows live in [`docs/ai-workflows.md`](./docs/ai-workflows.md).

Use them as slash-command style prompts in Codex, Claude, or another coding agent:

```text
/sanity
/review
/update-branches
/bootstrap-change
/nvim-update
/package-sync
/xdg-audit
/memory-refresh
```

These labels are not shell commands by default. Paste the prompt text from the workflow doc into the AI client, or register them as custom slash commands if the client supports that.

## 🤖 AI Memory Model

Agent memory is layered so global policy stays portable and project facts stay close to the repo they describe:

- [`ai/AGENTS.md`](./ai/AGENTS.md): version-controlled global cross-harness behavior, safety, git/reporting preferences, and memory policy. Bootstrap links each harness directly to this file with a relative symlink (`AGENTS.md` for Codex/Pi, `CLAUDE.md` for Claude Code).
- Project `AGENTS.md`: repo-specific commands, architecture, generated/vendor hazards, validation, and project-specific rules.
- Project `docs/known-issues.md`: recurring bugs, active workarounds, reproduction/retest steps, and exit criteria.
- Project `docs/agent-memory.md`: durable facts likely to matter in future agent sessions when they do not belong in normal docs.
- [`ai/templates`](./ai/templates): starter templates used by `work` when it creates a new named project under `~/Developer`; `work` also creates project-level `CLAUDE.md -> AGENTS.md` so Claude Code shares the same instructions.

Agents should update existing memory before adding duplicates, include verification dates for drift-prone facts, and never store secrets, credentials, private tokens, or sensitive raw logs.

## 🤖 Codex Preferences

Codex runtime configuration stays in `$CODEX_HOME/config.toml` because Codex writes local state there, including marketplaces, plugins, MCP servers, and project trust.

Bootstrap merges portable defaults from [`ai/codex/config/preferences.toml`](./ai/codex/config/preferences.toml) and SourDiesel UI preferences from [`ai/codex/themes/sourdiesel.toml`](./ai/codex/themes/sourdiesel.toml) with [`ai/codex/scripts/apply_preferences.py`](./ai/codex/scripts/apply_preferences.py). The helper rewrites only managed keys and preserves unrelated Codex-owned sections. Bootstrap links Codex, Pi, and Claude Code global instructions directly to the tracked [`ai/AGENTS.md`](./ai/AGENTS.md) (`CLAUDE.md` for Claude Code).

The SourDiesel fragment manages Codex UI and TUI status-line preferences. TUI segment order is managed through `status_line`; TUI colors still come from Codex and the configured terminal ANSI palette, with `status_line_use_colors = true` enabling colored status-line segments.

Shared color values are defined by [`themes/sourdiesel/palette.toml`](./themes/sourdiesel/palette.toml); the Codex fragment is a validated consumer of that palette.

On macOS, bootstrap also publishes `CODEX_HOME`, `NVIM_LOG_FILE`, and the XDG base directories through `launchctl setenv` for subprocesses that inherit launchd environment. The Homebrew `codex` CLI remains the supported Codex harness.

Keep `ai/codex/` limited to repo-managed Codex inputs:

- `themes/`: TOML fragments for managed UI preferences.
- `config/`: portable, non-secret Codex defaults.
- `scripts/`: idempotent helpers that merge or validate those fragments.
- `skills/`: personal skill sources. Bootstrap discovers each child directory containing `SKILL.md` and links it into `$CODEX_HOME/skills`; adding another skill does not require bootstrap edits.
- `AGENTS.md`: tracked symlink/reference to shared global guidance; bootstrap links `$CODEX_HOME/AGENTS.md -> ../../../.dotfiles/ai/AGENTS.md`.
- Optional docs or templates that are safe to share.

Do not put Codex runtime state in `ai/codex/`: `config.toml`, `auth.json`, SQLite databases, sessions, logs, plugin caches, marketplace state, project trust, and generated skill/plugin/runtime folders belong under `$CODEX_HOME`.

## 🔄 Updates

Run the standard update set without TeX Live:

```sh
update-tools
```

Run every update, including TeX Live:

```sh
update-tools --all
```

Run selected updates only:

```sh
update-tools --brew --rust --nvim
```

Update only Pi:

```sh
update-tools --pi
```

Update only TeX Live:

```sh
update-tools --tex
```

Use `update-tools --help` for all step flags and the `--icons-dir PATH` override.

Typical manual update checks:

```sh
brew update
brew upgrade --formula -y
brew upgrade --cask --greedy --no-quit -y
brew bundle check --file "$HOME/.dotfiles/manifests/Brewfile"
tldr --update
git -C "$XDG_DATA_HOME/fzf" pull --ff-only
nvim --headless '+lua vim.pack.update(nil, { force = true })' '+qa'
pi update --all
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

### Debug Atuin Zsh Search Capture

Zsh sources [`shells/zsh/patches/atuin-zsh-tty-capture.zsh`](./shells/zsh/patches/atuin-zsh-tty-capture.zsh) after `atuin init zsh --disable-ai`.

```sh
ATUIN_ZSH_TTY_CAPTURE_DEBUG=1 exec zsh
tail -f "$XDG_STATE_HOME/atuin/zsh-tty-capture.log"
```

To temporarily bypass the patch and test Atuin's generated fd-swapping path:

```sh
ATUIN_ZSH_TTY_CAPTURE=0 exec zsh
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

See [`docs/known-issues.md`](./docs/known-issues.md) for pinned tool versions and active upstream workarounds, including the tmux 3.7/3.7a WezTerm rendering issue.

### Shell Does Not Load

- Start with `zsh -dfi` to bypass startup files.
- Check `~/.zshenv` points at `~/.config/shells/env`.
- Check `$ZDOTDIR/.zshenv` points at `../env`; re-execed or nested zsh processes use this path once `ZDOTDIR` is exported.
- Check `ZDOTDIR="$XDG_CONFIG_HOME/shells/zsh"`.
- Check `$PATH` includes Homebrew, Cargo, uv tools, and bob nvim bin paths.
- Check interactive shells set `DOTFILES_PROFILE_LOADED=1`; `shells/profile` is idempotent because login zsh can source it through both `.zprofile` and `.zshrc`.

### Bash Loads but ble.sh Fails

- Confirm `"$XDG_DATA_HOME/blesh/ble.sh"` exists.
- Confirm `.bashrc` sources ble.sh with `--rcfile "$SHELL_CONFIG/bash/.blerc"`.
- Open a plain shell with `bash --noprofile --norc` if startup is broken.

### Neovim Plugin or Highlighting Issues

- Run `:checkhealth`.
- Run `vim.pack.update()`.
- Clear stale parser/plugin state only after confirming the failing plugin path.
- Confirm `NVIM_LOG_FILE` points at `$XDG_STATE_HOME/nvim/nvim.log`.

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

- Keep orchestration in `bootstrap.sh`, defaults in `bootstrap/defaults.env`, and setup behavior in focused modules under `bootstrap/lib`.
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
