# Pi overlay — handoff skill

Load when executing `handoff` in the **Pi Coding Agent** (`@earendil-works/pi-coding-agent`).

## Install location

- User-global: `~/.pi/agent/skills/handoff/`
- Project: `<repo>/.pi/skills/handoff/`
- Shared cross-harness dir (also scanned by Pi): `~/.agents/skills/handoff/`
- Pi can also be pointed at other harnesses' dirs via `settings.json`, e.g. `{ "skills": ["~/.claude/skills", "~/.codex/skills"] }`, so a single install can serve multiple agents.

Relocate all Pi state with the `PI_CODING_AGENT_DIR` env var if set (skills then live under `<that dir>/skills/`).

Pi auto-invokes skills by `description` match, and `/skill:handoff <goal>` invokes explicitly. Arguments after the skill name are appended as a `User:` message — so read the goal from that message; there is **no positional/`$ARGUMENTS` substitution**.

Frontmatter note: Pi's SKILL.md schema recognizes `name` and `description` (both required) plus `license`, `compatibility`, `metadata`, `allowed-tools`, `disable-model-invocation`. The shared `SKILL.md` uses only `name` + `description`, which is valid everywhere — do not add Claude-Code-only fields here.

## Write destination

Use the portable default in `references/destinations.md` (OS temp `agent-handoffs/`). Pi has only four built-in tools (read, write, edit, bash); the `write` tool handles the file. No special handoff destination policy by default.

## Context worth capturing

When relevant to the goal:

- Repo root / cwd and branch
- Which provider/model the session ran on, if it mattered to results
- `AGENTS.md` / `CLAUDE.md` instructions in force (Pi reads both) — point to them, don't restate
- Whether changes are committed

## Suggested skills for Pi receivers

Prefer skills discoverable by Pi: `~/.pi/agent/skills/`, `.pi/skills/`, `~/.agents/skills/`, plus any dirs listed in `settings.json`. Reference skills by their kebab-case `name`. Describe the action in plain language if you cannot confirm a skill exists.

## Optional follow-ups

Pi has no built-in project-progress CLI. Durable cross-session rules go in `AGENTS.md` (global `~/.pi/agent/AGENTS.md` or repo-level) or `APPEND_SYSTEM.md` — suggest those for lasting rules, not the disposable handoff. `/reload` re-reads skills without restarting.

## First message

Use the canonical block in `references/destinations.md`. Paste it into a fresh `pi` session and reference the handoff file path; Pi will read it with its `read` tool.
