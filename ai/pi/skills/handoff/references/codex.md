# Codex CLI overlay — handoff skill

Load when executing `handoff` in **OpenAI Codex CLI** (skills system; the older custom-prompts feature is deprecated).

## Install location

- User-global: `~/.codex/skills/handoff/`
- Project: `<repo>/.codex/skills/handoff/`
- Shared cross-harness dir (also scanned by Codex): `~/.agents/skills/handoff/`

Codex auto-invokes skills by matching the `description` field. There is **no `$ARGUMENTS` substitution** for skills — the agent receives the full task context, so read the goal from the user's request. Override the Codex home with the `CODEX_HOME` env var if set.

Initial context load is capped (~name + description only, ~8k chars across all skills); the full `SKILL.md` loads when the skill is selected. Keep the description tight so auto-invocation stays reliable.

## Write destination

Use the portable default in `references/destinations.md` (OS temp `agent-handoffs/`). Codex respects its sandbox/approval policy for writes; if a write outside the workspace is blocked, write into the workspace under a `.handoffs/` dir (git-ignore it) or deliver inline.

## Context worth capturing

When relevant to the goal:

- Repo root / cwd and branch
- The active approval mode / sandbox if it affected what you could do
- `AGENTS.md` constraints already in force (don't restate them in full — point to the file)
- Whether changes are committed

## Suggested skills for Codex receivers

Prefer skills present in `~/.codex/skills/`, `.codex/skills/`, or `~/.agents/skills/`. Name the action in plain language if you cannot confirm a skill exists. Codex skills are folders with a `SKILL.md`; reference them by their `name`.

## Optional follow-ups

Codex has no built-in project-progress CLI. Persistent cross-session rules live in `AGENTS.md` (global `~/.codex/AGENTS.md` or repo `AGENTS.md`) — if a durable rule emerged this session, suggest the user add it there rather than to the disposable handoff.

## First message

Use the canonical block in `references/destinations.md`. Paste it into a fresh `codex` session; Codex will read the named handoff file when you reference its path.
