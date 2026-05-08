# Dotfiles Agent Guide

This file is the operational guide for humans and coding agents working in this repo.
It follows `bootstrap.sh` as the source of truth for setup order and behavior.

## Scope

- Repository: `~/.dotfiles`
- Primary orchestrator: `bootstrap.sh`
- Supported platforms:
  - macOS (primary)
  - Linux (`apt` and `dnf` flows implemented)

## Core Principles

- Prefer idempotent operations.
- Respect XDG layout (`~/.config`, `~/.cache`, `~/.local/share`, `~/.local/state`).
- Keep user-facing actions behind helper wrappers (`run`, `logg`, `notify`, `require`).
- Keep secrets optional and gated by 1Password availability.
- Treat `bootstrap.sh` as the execution contract.

## Bootstrap Entry Points

- Run setup:
  - `~/.dotfiles/bootstrap.sh`
- Flags:
  - `-p`, `--with-1password`: force-enable 1Password integration
  - `-c`, `--check`: validate repo files and shell syntax, then exit
  - `-n`, `--dry-run`: print actions without executing
  - `-h`, `--help`: usage output

## Bootstrap Execution Order

Main flow in `bootstrap.sh`:

1. Detect platform and package manager (`detect_platform`)
2. Refresh sudo auth + detect 1Password (`authorize`, `use_op`)
3. Install package sets (`setup_package_manager`, `install_package_sets`) and fzf (`install_fzf`)
4. Collect runtime/user environment (`collect_environment`)
5. Create symlinks + state directories (`create_symlinks`)
6. Apply OS defaults (`configure_macos_defaults`)
7. Configure git + GitHub CLI (`configure_git_and_github`)
8. Clone personal development repos (`clone_developer_repos`)
9. Install project templates (`install_templates`)
10. Install shell plugin managers (Zap, ble.sh)
11. Provision Atuin sync (`setup_atuin_sync`)
12. Build bat cache
13. Configure sudo Touch ID (`configure_sudo_auth`)
14. Create `~/.hushlogin`
15. Set login shell (`change_shell_default`)
16. Configure Hammerspoon path (`configure_hammerspoon`)
17. Install Rust toolchain + cargo tools (`install_rust_tooling`)
18. Setup editor tooling (`setup_ide`)

## High-Value Features

### 1) XDG-Centric Dotfiles

Symlinks are created from this repo into XDG paths, including:

- `~/.config/{shells,nvim,tmux,wezterm,git,ssh,...}`
- `~/.config/vscode`
- `~/.config/fzf/fzf.sh`
- `~/.config/webapps`
- `~/.local/state/{zsh,bash,codex,jupyter,python,mysql,mycli,...}`
- `~/.local/share/{jupyter,vscode,zsh,...}`

Bootstrap also links `~/.vscode` back to `$XDG_DATA_HOME/vscode`.

Implementation: `create_symlinks`.

### 2) Package Management by Platform

- macOS: Homebrew + Brewfile flow + upstream fzf git install
- Debian/Ubuntu: apt manifests + upstream fzf git install + GitHub CLI repo install + Charm repo Glow install + optional GUI app installs
- Fedora/RHEL: dnf manifests + upstream fzf git install + GitHub CLI install + Charm repo Glow install + optional GUI app installs

Implementation: `setup_package_manager`, `install_package_sets`, `install_fzf`, `install_gh`, `install_glow`, `install_linux_gui_apps_*`.

### 3) 1Password-Aware Setup

When available/enabled:

- Uses `op` for secret retrieval
- Populates Git/Atuin-related credentials
- Optionally links 1Password SSH config

Implementation: `use_op`, `get_op_field`, `collect_environment`, `setup_atuin_sync`.

### 4) Touch ID Sudo (macOS)

`configure_sudo_auth` writes `/etc/pam.d/sudo_local` with:

- `pam_reattach` for tmux-friendly auth context
- `pam_tid` module with OS-aware suffix detection (`pam_tid.so.2` when present)

### 5) Rust + Editor Tooling

- Rustup/cargo installation
- Cargo-managed CLI stack
- Neovim managed via `bob` (stable + nightly)
- Python CLI tools via `uv` (`basedpyright`, `ruff`)

Implementation: `install_rust_tooling`, `setup_ide`.

## Neovim Plugin Update Hooks

Autocommands include a `PackChanged` hook that rebuilds `blink.cmp` rust fuzzy lib on install/update:

- File: `editors/nvim/lua/autocmds.lua`
- Event: `PackChanged`
- Trigger: plugin `blink.cmp` or `blink.lib`, kind `install` or `update`
- Action: `require('blink.cmp').build({ force = true }):wait(60000)`

This prevents manual rebuilds after `vim.pack.update()`.

## Neovim Session Refresh

When Neovim changes affect opened buffers, module paths, renamed files, or
session restore behavior, run the Neovim validation first and then refresh the
ignored root session file:

```sh
nvim --headless '+silent! mksession! Session.vim' '+qa'
```

`Session.vim` is intentionally ignored, but keeping it fresh lets `:restart`
resume against current paths. A native Neovim hook may replace this later; for
now this is an agent-layer maintenance step.

## Important Paths and Manifests

- Editor config roots:
  - `editors/nvim`
  - `editors/vscode`
- Homebrew bundle file: `manifests/Brewfile`
- Shared theme palette: `shells/sourdiesel`
- Shared shell entrypoint: `shells/env`
- Shared fzf config: `cli/fzf/fzf.sh`
- Auth config roots:
  - `auth/git`
  - `auth/ssh`
  - `auth/1Password`
- CLI config roots:
  - `cli/atuin`
  - `cli/bat`
  - `cli/btop`
  - `cli/dust`
  - `cli/eza`
  - `cli/fzf`
  - `cli/gh`
  - `cli/glow`
  - `cli/mycli`
  - `cli/ripgrep`
- App config roots:
  - `apps/hammerspoon`
  - `apps/karabiner`
  - `apps/webapps`
- WezTerm config: `terminals/wezterm/wezterm.lua`
- Linux package manifests:
  - `manifests/apt-packages.txt`
  - `manifests/dnf-packages.txt`
- Curated developer repos:
  - cloned to `~/Developer` from `DEVELOPER_REPOS` in `bootstrap.sh`
- Templates repo destination: `$XDG_DATA_HOME/templates`
- VS Code settings symlink target:
  - macOS: `~/Library/Application Support/Code/User/settings.json`
  - Linux: `$XDG_CONFIG_HOME/Code/User/settings.json`
- VS Code config root:
  - `~/.config/vscode -> ~/.dotfiles/editors/vscode`
- VS Code extension/CLI data directory:
  - `~/.vscode -> $XDG_DATA_HOME/vscode`

## Maintenance Rules for Agents

- Prefer editing source-of-truth files over generated artifacts.
- If behavior changes in setup flow, update both:
  - `bootstrap.sh`
  - `README.md` and this `AGENTS.md` when user-facing behavior changes
- Keep Linux and macOS branches explicit and guarded.
- Preserve dry-run compatibility by routing shell actions through `run` where practical.
- Use `require <bin>` guard clauses for optional integrations.
- Use [`docs/ai-workflows.md`](./docs/ai-workflows.md) for repeatable slash-command style workflows such as `/sanity`, `/review`, `/git-flow`, `/bootstrap-change`, `/nvim-update`, `/package-sync`, and `/xdg-audit`.

## AI Workflow Rules

- Treat workflow names as prompt labels, not shell commands, unless the active client supports custom slash commands.
- For `/sanity`, run `./bootstrap.sh --check`, `bash -n bootstrap.sh`, and `git diff --check`.
- For `/git-flow`, inspect status and diff first, validate before committing, use commitizen-style messages, fast-forward `dev` from `main`, push `dev`, return to `main`, push `main`, and confirm refs match.
- For bootstrap changes, preserve idempotence, dry-run behavior, XDG layout, and platform guards.
- For package changes, update the relevant manifest and docs together.

## Git Workflow Permissions

When the user asks to validate, stage, commit, merge to `main`, and push, prefer requesting reusable approval prefixes instead of one-off command approvals:

- `git add -A`
- `git commit -m`
- `git switch`
- `git switch main`
- `git merge --ff-only`
- `git push`
- `git branch --set-upstream-to`

Still ask before destructive operations such as `git reset --hard`, branch deletion, or force-push unless the user explicitly requested that operation.

Codex may still need an escalation prompt when the sandbox blocks writes to Git internals such as `.git/index.lock`, `.git/config`, or ref lock files. Treat those as filesystem permission prompts, and request the reusable prefix from the list above instead of changing the Git workflow.

## Common Failure Modes

- Touch ID sudo not prompting:
  - verify `sudo_local` module path (`pam_tid.so.2` on newer macOS)
- blink.cmp rust warning:
  - ensure `PackChanged` build hook exists and `cargo` is available
- completion dump written in wrong location:
  - ensure `compinit -d "$XDG_CACHE_HOME/zsh/.zcompdump"` in zsh init path

## External Links (From Existing Config)

- Homebrew: https://brew.sh/
- Zap: https://github.com/zap-zsh/zap
- ble.sh: https://github.com/akinomyoga/ble.sh
- 1Password CLI + Shell Plugins: https://developer.1password.com/docs/cli/shell-plugins
- Atuin: https://atuin.sh/
- WezTerm: https://wezterm.org/
- Neovim `vim.pack` docs: `:h vim.pack`

## Quick Validation Checklist

After major changes:

1. `bootstrap.sh --check` (repo and shell syntax sanity)
2. `bootstrap.sh -n` (dry-run sanity)
3. Launch a new shell and verify XDG exports/symlinks
4. Run `work`/tmux flow sanity
5. Open Neovim and run `:checkhealth`
6. Run `vim.pack.update()` and confirm blink rebuild hook behavior
