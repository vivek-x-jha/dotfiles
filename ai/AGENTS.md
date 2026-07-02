# AGENTS.md

## Defaults

- Be concise, practical, and explicit about assumptions or uncertainty.
- Inspect live evidence before conclusions: source, config, SQLite, logs, runtime state, or public endpoints as relevant.
- Read before editing; keep patches narrow and preserve user-owned dirty work.
- Implement concrete requests end-to-end, then run the smallest useful checks.
- Ask before broad refactors, destructive cleanup, installs, commits, pushes, deploys, or global machine changes.

## Safety

- Audit before deleting; prefer reversible quarantine for cleanup.
- Do not touch secrets, credentials, vendored/generated files, lockfiles, or agent runtime state unless explicitly requested.
- For handoffs: read the named file, verify live repo/state, continue only if real work remains.
- For recurring drift: fix the source of truth instead of adding another workaround.

## Memory System

- Keep this global file limited to cross-harness behavior, safety, and memory policy; do not store project facts here.
- Prefer project-local memory in this order:
  1. `AGENTS.md` for repo-specific commands, architecture, generated/vendor hazards, and validation.
  2. `docs/known-issues.md` for recurring bugs or workarounds with status, last verified date, reproduction, workaround, and exit criteria.
  3. `docs/agent-memory.md` for durable project facts that are likely to matter in future sessions but do not belong in normal docs.
- Add or update durable memory only when the fact is likely to matter again; update existing entries before adding duplicates.
- Keep memory evidence-backed. Mark uncertainty, stale observations, and last verification dates instead of presenting guesses as facts.
- Never store secrets, credentials, private tokens, or raw logs containing sensitive values in memory files.
- Remove or archive resolved memory after validating the exit criteria.

## Git

- Before committing, inspect recent history with `git log --oneline -10` and match its message style.
- If history is mixed or unclear, fall back to Commitizen/Conventional Commit style: `type(scope): summary`.
- For releases, use `release(scope): release x.y.z`.

## Reporting

- Summarize changed paths and checks run.
- Call out stale-vs-current evidence when local state disagrees with visible behavior.

## Project Overrides

- Read repo-local `AGENTS.md` for project commands, architecture, generated files, hazards, and memory locations.
- Treat repo-local instructions as more specific than this file.
- Keep project memory files short; link to docs, issues, commits, or README sections for long reference material.
