# Agent Memory

Durable facts for future coding-agent sessions in this dotfiles repo.

## Facts

- Source of truth is the tracked `~/.dotfiles` checkout; prefer editing repo files over live-home symlink targets or generated/runtime artifacts.
- `bootstrap.sh` is the setup contract and should remain idempotent with `--dry-run`, `--check`, and targeted `--only/--skip` flows.
- Global cross-harness agent policy lives in `ai/AGENTS.md`, is exposed at `~/AGENTS.md` by bootstrap, and Codex/Pi/Claude Code global config links to that home-level alias.
- Project scaffolding templates for `work` live in `ai/templates/`; keep Bash and Zsh `work` implementations in parity.
- Long-lived bugs and workarounds belong in `docs/known-issues.md` with status, last verified date, workaround, reproduction, and exit criteria.
