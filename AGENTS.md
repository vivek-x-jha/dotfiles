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
  - `-d`, `--doctor`: validate installed workstation state, then exit
  - `-n`, `--dry-run`: print actions without executing
  - `-i`, `--interactive`: prompt for configurable choices instead of using defaults
  - `--config PATH`: load an additional bootstrap config override
  - `--fresh`: use the fresh-machine profile label
  - `--partial`: use the partial-machine profile label
  - `--only TARGETS`: run only selected comma/space-separated targets
  - `--skip TARGETS`: skip selected comma/space-separated targets
  - `--list-targets`: print target names for modular runs
  - `-h`, `--help`: usage output

## Bootstrap Execution Order

Main flow in `bootstrap.sh`:

1. Load XDG paths, `bootstrap/defaults.env`, optional local overrides, and sourced modules from `bootstrap/lib`
2. Detect platform and package manager (`detect_platform`)
3. Refresh sudo auth + detect 1Password (`authorize`, `use_op`)
4. Install package sets (`setup_package_manager`, `install_package_sets`) and fzf (`install_fzf`)
5. Collect runtime/user environment (`collect_environment`)
6. Create symlinks + state directories (`create_symlinks`)
7. Apply Codex SourDiesel UI preferences (`configure_codex_ui`)
8. Apply OS defaults (`configure_macos_defaults`)
9. Configure git + GitHub CLI (`configure_git_and_github`)
10. Optionally clone personal development repos (`clone_developer_repos`)
11. Optionally install project templates (`install_templates`)
12. Install shell plugin managers (Zap, ble.sh)
13. Optionally provision Atuin sync (`setup_atuin_sync`)
14. Build bat cache
15. Optionally configure sudo Touch ID (`configure_sudo_auth`)
16. Create `~/.hushlogin`
17. Optionally set login shell (`change_shell_default`)
18. Configure Hammerspoon path (`configure_hammerspoon`)
19. Install Rust toolchain + cargo tools (`install_rust_tooling`)
20. Setup editor tooling (`setup_ide`)

## High-Value Features

### 1) XDG-Centric Dotfiles

Symlinks are created from this repo into XDG paths, including:

- `~/.config/{shells,nvim,tmux,wezterm,git,ssh,...}`
- `~/.config/vscode`
- `~/.config/fzf/fzf.sh`
- `~/.config/claude/settings.json -> ~/.dotfiles/ai/claude/settings.json`
- `~/.local/state/{zsh,bash,codex,jupyter,python,mysql,mycli,...}`
- `~/.local/share/{jupyter,vscode,zsh,...}`

Bootstrap also links `~/.vscode` back to `$XDG_DATA_HOME/vscode`.
Claude runtime state such as `~/.claude.json` is left unmanaged; only `ai/claude/settings.json` is tracked and linked.
Codex runtime state and generated `config.toml` sections stay owned by Codex under `$CODEX_HOME`; bootstrap exports that path for shells and macOS GUI-launched Codex Desktop, then only merges known SourDiesel UI preference keys from `ai/codex/themes/sourdiesel.toml`.

Implementation: `create_symlinks`.

### 2) Package Management by Platform

- macOS: Homebrew + Brewfile flow with optional cask filtering + upstream fzf git install
- Debian/Ubuntu: apt manifests + upstream fzf git install + GitHub CLI repo install + Charm repo Glow install + optional GUI app installs
- Fedora/RHEL: dnf manifests + upstream fzf git install + GitHub CLI install + Charm repo Glow install + optional GUI app installs

Implementation: `setup_package_manager`, `install_package_sets`, `install_fzf`, `install_gh`, `install_glow`, `install_linux_gui_apps_*`.

### 3) 1Password-Aware Setup

When available/enabled:

- Uses `op` for secret retrieval
- Populates Git/Atuin-related credentials
- Optionally links 1Password SSH config
- Wraps `gh` through the 1Password shell plugin and provides direct `mysql`/`mycli` secret-backed aliases from `MySQL User: <user>` items

Implementation: `use_op`, `get_op_field`, `collect_environment`, `setup_atuin_sync`.

### 4) Touch ID Sudo (macOS)

`configure_sudo_auth` writes `/etc/pam.d/sudo_local` with:

- `pam_reattach` for tmux-friendly auth context
- `pam_tid` module with OS-aware suffix detection (`pam_tid.so.2` when present)

### 5) Rust + Editor Tooling

- Rustup/cargo installation
- Cargo-managed CLI stack
- `zsh-patina` for Zsh syntax highlighting, configured under `shells/zsh/patina`
- `zsh-autocomplete` FD cleanup patch in `shells/zsh/patches`, maintained by `patch-zsh-autocomplete` and reapplied by `update-tools` around `zap update all`
- Atuin Zsh non-popup search uses `shells/zsh/patches/atuin-zsh-tty-capture.zsh` to avoid Atuin's generated fd-swapping capture path; debug with `ATUIN_ZSH_TTY_CAPTURE_DEBUG=1` and bypass with `ATUIN_ZSH_TTY_CAPTURE=0`
- `update-tools` supports per-step flags in Bash and Zsh; no flags or `--all` run the complete maintenance workflow
- Neovim managed via `bob` (stable + nightly)
- Python CLI tools via `uv` (`basedpyright`, `ruff`)

Implementation: `install_rust_tooling`, `setup_ide`.

### 6) Codex SourDiesel UI Preferences

- Source fragment: `ai/codex/themes/sourdiesel.toml`
- Merge helper: `ai/codex/scripts/apply_preferences.py`
- Runtime target: `$CODEX_HOME/config.toml`
- Behavior: `configure_codex_environment` publishes `$CODEX_HOME` and XDG base directories through macOS `launchctl setenv`, then `configure_codex_ui` updates only managed UI preference keys and preserves Codex-owned sections such as `marketplaces`, `plugins`, `projects`, and `mcp_servers`.
- Managed preferences include Desktop chrome theme keys plus TUI `status_line` order and `status_line_use_colors`.
- TUI colors use Codex and the terminal ANSI palette with `status_line_use_colors = true`; do not add unsupported TUI color keys.
- Codex Desktop integrated terminal colors come from the selected built-in code theme's VS Code terminal variables. Do not add unsupported Desktop terminal ANSI keys unless Codex exposes them in the settings schema.
- Keep `ai/codex/` for repo-managed themes, merge scripts, safe docs, and templates only. Do not track Codex runtime files such as `config.toml`, `auth.json`, SQLite databases, sessions, logs, plugin caches, marketplace state, project trust, or generated skill/plugin/runtime folders.

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
  - Bootstrap defaults to this local Brewfile and can generate a temporary install Brewfile with selected `cask` entries omitted.
- Bootstrap defaults and implementation:
  - `bootstrap/defaults.env`
  - `bootstrap/lib/*.sh`
- Shared theme palette: `shells/sourdiesel`
- Shared shell env: `shells/env`
- Shared shell profile/PATH setup: `shells/profile`
- Shared fzf config: `cli/fzf/fzf.sh`
- Auth config roots:
  - `auth/git`
  - `auth/ssh`
  - `auth/1Password`
- File-backed SSH private keys live under `~/.config/ssh/keys/`.
- AI config roots:
  - `ai/claude`
  - `ai/codex`
- CLI config roots:
  - `cli/atuin`
  - `cli/bat`
  - `cli/btop`
  - `cli/dust`
  - `cli/eza`
  - `cli/fzf`
  - `cli/gh`
  - `cli/glow`
  - `cli/matplotlib`
  - `cli/mycli`
  - `cli/npm`
  - `cli/ripgrep`
- App config roots:
  - `apps/hammerspoon`
  - `apps/karabiner`
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
- Claude config:
  - `~/.config/claude/settings.json -> ~/.dotfiles/ai/claude/settings.json`

## Maintenance Rules for Agents

- Prefer editing source-of-truth files over generated artifacts.
- If behavior changes in setup flow, update both:
  - `bootstrap.sh`
  - `README.md` and this `AGENTS.md` when user-facing behavior changes
- Keep Linux and macOS branches explicit and guarded.
- Preserve dry-run compatibility by routing shell actions through `run` where practical.
- Use `require <bin>` guard clauses for optional integrations.
- Use [`docs/ai-workflows.md`](./docs/ai-workflows.md) for repeatable slash-command style workflows such as `/sanity`, `/review`, `/update-branches`, `/bootstrap-change`, `/nvim-update`, `/package-sync`, and `/xdg-audit`.

## AI Workflow Rules

- Treat workflow names as prompt labels, not shell commands, unless the active client supports custom slash commands.
- For `/sanity`, run `./bootstrap.sh --check`, `bash -n bootstrap.sh`, and `git diff --check`.
- For `/update-branches`, inspect status and diff first, validate before committing, use commitizen-style messages, fast-forward `dev` from `main`, push `dev`, return to `main`, push `main`, and confirm refs match.
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
- Atuin Tab/Enter selection failing in Zsh non-popup search:
  - check `shells/zsh/patches/atuin-zsh-tty-capture.zsh`; enable `ATUIN_ZSH_TTY_CAPTURE_DEBUG=1` and inspect `$XDG_STATE_HOME/atuin/zsh-tty-capture.log`

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
2. `bootstrap.sh --doctor` (installed state sanity)
3. `bootstrap.sh -n` (dry-run sanity)
4. Launch a new shell and verify XDG exports/symlinks
5. Run `work`/tmux flow sanity
6. Open Neovim and run `:checkhealth`
7. Run `vim.pack.update()` and confirm blink rebuild hook behavior
