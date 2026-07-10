# Grok overlay — handoff skill

Load when executing `handoff` on the **Grok** CLI.

> This overlay is optional. The skill works on Grok with no overlay (it falls back to `references/destinations.md`). Everything `soma`-related below is **optional sugar** — run it only if `soma` happens to be installed; never block a handoff on it.

## Install location

- `~/.grok/skills/handoff/`

Grok loads skills from its skills directory. If you manage skills with an external projector (e.g. soma), that is one way to populate this directory, but it is **not required** — copying the skill folder in directly works.

## Write destinations (policy-safe)

Some Grok setups run a `PreToolUse` hook that denies writes of private context into public workspace files. If your setup does, sanitize before any public-repo write. If it does not, just use the portable default.

| Destination | When | Notes |
|-------------|------|-------|
| OS temp `agent-handoffs/` (see `references/destinations.md`) | **Default** | Disposable; preferred for cross-session transfer |
| A private scratch dir (e.g. a `SCRATCHPAD/handoffs/`) | Full detail with private path context allowed | Use only if your policy allows private destinations |
| Current workspace (e.g. `grok-temp/`) | Only if **sanitized** | No literal private-root path strings; no pasted private text |
| Chat inline only | Quick handoff | Session-private; no file |

Filename: `YYYY-MM-DD-<slug>.md` (kebab-case hint from the goal, max ~40 chars). Create the directory if missing.

## Optional pre-handoff persist (only if soma is installed)

If — and only if — `soma` is available and an active run/ISA is in play, you may mirror its lifecycle note:

```sh
# optional; skip entirely if soma is not installed
bun run soma lifecycle algorithm-observed
```

Failure is non-fatal — note it in the handoff doc and continue. Handoff does not depend on this.

## Grok-specific context to capture

When relevant to the stated goal, include:

- Session id (if known from environment or session metadata)
- Workspace root / cwd
- Open todos (ids + text)
- Any active run/ISA slug (pointer only — do not paste full bodies)
- Hook incidents (e.g. a denied Write) with what was blocked and the safe alternative used

## Suggested skills for Grok receivers

List only skills you can confirm exist under the receiver's skills directory. Describe the action in plain language otherwise.

## Optional follow-ups (only if soma is installed)

If `soma` is present and the work maps to a named project, you may suggest its session/progress commands in the handoff's "Optional follow-ups" section. If `soma` is absent, leave that section empty.

## First message

Use the canonical block in `references/destinations.md`. Paste it into a **new** Grok session.

## What not to do on Grok

- Do not use in-place compaction as a substitute when the user wants a **new** focused thread.
- Do not write private markers into public workspace paths (see policy above).
- Do not duplicate content already in repo artifacts — reference paths only.
- Do not invoke `soma` (or any other external tool) if it is not installed.
