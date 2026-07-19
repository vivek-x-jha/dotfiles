# AGENTS.md

## Scope

Personal dotfiles/bootstrap repo. Prefer source-of-truth files over generated or live-home artifacts.

## High-Signal Entry Points

- Setup flow: `install.sh`, `bootstrap.sh`, `bootstrap/defaults.env`, `bootstrap/lib/*.sh`, `bootstrap/tests/*.sh`
- Homebrew profiles: `manifests/Brewfile` (core), `manifests/Brewfile.developer`, `manifests/Brewfile.personal`; opt-in additions: `manifests/Brewfile.rust`, `manifests/Brewfile.1password`
- Docs: `README.md`, `docs/ai-workflows.md`
- Global agent policy: `ai/AGENTS.md` (Codex/Pi link `AGENTS.md` to it directly; Claude Code links `CLAUDE.md` to it directly from configured harness paths)
- Agent memory/templates: `ai/templates/`, `docs/known-issues.md`, `docs/agent-memory.md`
- AI harness sources: `ai/codex/`, `ai/claude-code/`, `ai/pi/`, `ai/herdr/`, `ai/ponytail/`
- Codex source: `ai/codex/config/preferences.toml`, `ai/codex/scripts/apply_preferences.py`
- Theme source: `themes/sourdiesel/palette.toml`, `themes/sourdiesel/tool.py`
- Neovim source: `editors/nvim/`
- Shell source: `shells/env`, `shells/profile`, `shells/zsh/`

## Rules

- Preserve XDG layout and bootstrap idempotence across clean, conflicting, and partial homes; keep `install.sh` POSIX-compatible.
- Keep secrets optional and gated by 1Password; never expose secret values.
- Route bootstrap shell actions through existing helpers when practical.
- Update docs when user-facing bootstrap behavior changes.
- Keep Linux/macOS branches explicit and guarded.
- Do not edit Codex runtime state under `$CODEX_HOME` unless the task is specifically runtime debugging.
- Keep AI memory layered: global behavior in `ai/AGENTS.md`; project instructions in `AGENTS.md`; recurring issues in `docs/known-issues.md`; durable facts in `docs/agent-memory.md`.

## Checks

- Bootstrap sanity: `./bootstrap.sh --check` (includes isolated installer, profile, dependency/checkpoint, and idempotence fixtures)
- Disposable Apple Silicon VM only: `BOOTSTRAP_ALLOW_VM_INSTALL=1 bootstrap/tests/macos-vm.sh`
- Shell syntax: `bash -n bootstrap.sh`
- Diff whitespace: `git diff --check`
- Theme work: `python3 themes/sourdiesel/tool.py render && python3 themes/sourdiesel/tool.py check`
- Major installed-state checks only when needed: `./bootstrap.sh --doctor`, `./bootstrap.sh -n`

## Special Workflows

- Handoffs: read the handoff, then verify branch/status/diff and live files before continuing.
- SourDiesel: edit palette/consumers, render, check; do not hand-edit generated inventory alone.
- Codex config: update `ai/codex/config/preferences.toml`, then apply with `ai/codex/scripts/apply_preferences.py`.
- Neovim headless commands: prefix `NVIM_LOG_FILE="$HOME/.local/state/nvim/nvim.log"`.
