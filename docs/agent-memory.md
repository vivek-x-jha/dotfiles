# Agent Memory

Durable facts for future coding-agent sessions in this dotfiles repo.

## Facts

- Source of truth is the tracked `~/.dotfiles` checkout; prefer editing repo files over live-home symlink targets or generated/runtime artifacts.
- `bootstrap.sh` is the setup contract and should remain idempotent with `--dry-run`, `--check`, and targeted `--only/--skip` flows.
- Global cross-harness agent policy lives in `ai/AGENTS.md`; bootstrap links each harness directly to it with relative symlinks (`AGENTS.md` for Codex/Pi, `CLAUDE.md` for Claude Code).
- Project scaffolding templates for `work` live in `ai/templates/`; keep Bash and Zsh `work` implementations in parity.
- Long-lived bugs and workarounds belong in `docs/known-issues.md` with status, last verified date, workaround, reproduction, and exit criteria.
