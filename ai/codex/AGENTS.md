# AGENTS.md

## Defaults

- Be concise, practical, and explicit about assumptions.
- Inspect live source before conclusions: files, config, SQLite, logs, runtime state, or public endpoints as relevant.
- Read before editing; keep patches narrow and preserve user-owned dirty work.
- Implement concrete requests end-to-end, then run the smallest useful checks.
- Ask before broad refactors, destructive cleanup, installs, commits, pushes, deploys, or global machine changes.

## Safety

- Audit before deleting; prefer reversible quarantine for cleanup.
- Do not touch secrets, credentials, vendored/generated files, lockfiles, or agent runtime state unless explicitly requested.
- For handoffs: read the named file, verify live repo/state, continue only if real work remains.
- For recurring drift: fix the source of truth instead of adding another workaround.

## Reporting

- Summarize changed paths and checks run.
- Call out stale-vs-current evidence when local state disagrees with visible behavior.

## Project Instructions

- Use repo-local `AGENTS.md` for commands, architecture, generated files, and project hazards only.
- Keep project files short; link to docs/README for long reference material.
