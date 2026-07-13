# Agent Memory

Durable facts for future coding-agent sessions in this dotfiles repo.

## Facts

- Source of truth is the tracked `~/.dotfiles` checkout; prefer editing repo files over live-home symlink targets or generated/runtime artifacts.
- `install.sh` is the POSIX one-shot entrypoint: it shallow-clones the latest 10 commits into `~/.dotfiles`, safely reuses an existing checkout, then runs `bootstrap.sh`.
- `bootstrap.sh` is the setup contract and must converge across clean, conflicting, and partial homes. Managed conflicts are preserved under `$XDG_STATE_HOME/dotfiles/backups/`; target checkpoints/timings live under `$XDG_STATE_HOME/dotfiles/runs/`, and `--resume` accepts only the last incomplete matching plan.
- Homebrew profiles are cumulative: `manifests/Brewfile` is core, then `.developer`, then `.personal`; `.rust` and `.1password` are independently opt-in additions. Rust, IDE setup, and Neovim nightly are disabled by default, while IDE target selection resolves package/Rust/symlink prerequisites automatically.
- `--check` runs isolated installer, Homebrew profile, dependency/checkpoint, and idempotence fixtures. The guarded destructive Apple Silicon VM harness is `bootstrap/tests/macos-vm.sh`.
- Global cross-harness agent policy lives in `ai/AGENTS.md`; bootstrap links each harness directly to it with relative symlinks (`AGENTS.md` for Codex/Pi, `CLAUDE.md` for Claude Code).
- `ai/templates/` holds reusable project-memory starter templates that can be copied into new repos or scratch workspaces when needed.
- Long-lived bugs and workarounds belong in `docs/known-issues.md` with status, last verified date, workaround, reproduction, and exit criteria.
