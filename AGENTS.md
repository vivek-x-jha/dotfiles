# AGENTS.md

## Scope

Personal dotfiles/bootstrap repo. Prefer source-of-truth files over generated or live-home artifacts.

## High-Signal Entry Points

- Setup flow: `bootstrap.sh`, `bootstrap/defaults.env`, `bootstrap/lib/*.sh`
- Docs: `README.md`, `docs/ai-workflows.md`
- Agent instruction source: `ai/AGENTS.md` (linked into Codex/Pi/Claude harnesses)
- Codex source: `ai/codex/config/preferences.toml`, `ai/codex/scripts/apply_preferences.py`
- Theme source: `themes/sourdiesel/palette.toml`, `themes/sourdiesel/tool.py`
- Neovim source: `editors/nvim/`
- Shell source: `shells/env`, `shells/profile`, `shells/zsh/`

## Rules

- Preserve XDG layout and bootstrap idempotence.
- Keep secrets optional and gated by 1Password; never expose secret values.
- Route bootstrap shell actions through existing helpers when practical.
- Update docs when user-facing bootstrap behavior changes.
- Keep Linux/macOS branches explicit and guarded.
- Do not edit Codex runtime state under `$CODEX_HOME` unless the task is specifically runtime debugging.

## Checks

- Bootstrap sanity: `./bootstrap.sh --check`
- Shell syntax: `bash -n bootstrap.sh`
- Diff whitespace: `git diff --check`
- Theme work: `python3 themes/sourdiesel/tool.py render && python3 themes/sourdiesel/tool.py check`
- Major installed-state checks only when needed: `./bootstrap.sh --doctor`, `./bootstrap.sh -n`

## Special Workflows

- Handoffs: read the handoff, then verify branch/status/diff and live files before continuing.
- SourDiesel: edit palette/consumers, render, check; do not hand-edit generated inventory alone.
- Codex config: update `ai/codex/config/preferences.toml`, then apply with `ai/codex/scripts/apply_preferences.py`.
- Neovim headless commands: prefix `NVIM_LOG_FILE="$HOME/.local/state/nvim/nvim.log"`.
