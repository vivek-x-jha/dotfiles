# handoff

**Hand a fresh AI-agent session exactly what it needs to keep going — without dragging along the whole transcript.**

When a coding-agent thread gets long, you have two bad options: keep going until the context window fills up, or `/compact` and watch the agent forget *why* it was doing things. `handoff` is the third option. You name the goal for the *next* session, and it extracts only what that session needs — decisions, current state, blockers, the files to read, the approaches that already failed — into a short, disposable transfer document plus a **paste-ready first message**. You start a clean session, paste, and the new agent picks up with full intent and none of the noise.

It's a single skill folder that runs the same in **Claude Code, Codex, Pi, and Grok**, on **Windows, macOS, and Linux**, with **no dependencies** — just the agent's file-write tool.

> Think of it as a goal-directed extraction, not a lossy summary. The handoff doc is a *map* to your work, not a copy of it.

---

## Quick start

```sh
git clone git@github.com:klittle32/handoff-skill.git
cd handoff-skill

# macOS / Linux — installs into every agent it detects on your machine
sh install.sh

# Windows (PowerShell 7+)
./install.ps1
```

Then, in any installed agent, run:

```
/handoff implement phase one of the plan
```

The agent writes a handoff file and prints a **Suggested first message**. Open a new session, paste it, and keep working.

> No agent CLI yet? See [Install](#install) for the exact directory each one reads. The skill itself needs nothing installed; the optional verifier scripts need Python 3.9+.

---

## What you get

The skill produces two things: a handoff file on disk, and a copy-paste block to start the next session. The block looks like this:

```text
Continue from /tmp/agent-handoffs/2026-06-13-implement-phase-one.md.

Goal for this session: implement phase one of the auth refactor.

Read the handoff file in full first. Key artifacts: docs/plan.md, src/auth/middleware.ts.
```

<details>
<summary>Example handoff file it writes</summary>

```markdown
---
title: "Handoff — implement phase one"
created: 2026-06-13
goal: "Implement phase one of the auth refactor"
workspace: "~/src/app"
---

# Handoff — implement phase one

**Next session goal:** Implement phase one of the auth refactor.

## Suggested first message
... (the paste-ready block above) ...

## Decisions (do not re-litigate)
- Tokens move to async validation — sync path is the bottleneck.

## Current state
| Area | Status |
|------|--------|
| COMPLETED | Plan approved; interfaces sketched in docs/plan.md |
| IN PROGRESS | Middleware skeleton in src/auth/middleware.ts |
| NEXT | Wire async token validation into the middleware |
| BLOCKERS | none |

## Failed approaches (avoid repeating)
- Caching tokens in-process — broke on multi-worker deploys.

## Relevant files (read order)
1. `docs/plan.md` — the approved phase breakdown
2. `src/auth/middleware.ts` — where the work continues

## Suggested skills
- `/verify` — confirm the new path actually authenticates before moving on
```

Cold-start handoffs (no prior decisions or artifacts yet) legitimately omit the optional sections.
</details>

---

## When to use it (vs. other tools)

Described by function — exact command names vary by agent.

| Function | Use when | This skill? |
|----------|----------|-------------|
| **handoff** | Move to a **new** session with a **specific goal**; keep the current thread clean | ✅ |
| in-place compaction (often `/compact`) | Stay in the **same** thread; reclaim context-window headroom | no |
| branch / fork | Continue with a **copy** of the full conversation history | no |
| durable memory | Save **long-term lessons**, not a one-time session transfer | no |

## How to invoke

There's no separate trigger list to configure — every supported agent decides when to offer the skill from its `description`. It fires on `/handoff <goal>`, or phrasing like "hand off this session," "start a new thread for…," or "pass context to a new session." Pass the next-session goal as the argument; if you don't, the agent asks once.

## Install

A "skill" here is just this folder — `SKILL.md` plus `references/` and `scripts/`. Every supported agent loads it by reading a skills directory. Install into as many as you like:

| Agent | Personal (all projects) | Project-local |
|-------|-------------------------|---------------|
| Claude Code | `~/.claude/skills/handoff/` | `<repo>/.claude/skills/handoff/` |
| Codex CLI | `~/.codex/skills/handoff/` | `<repo>/.codex/skills/handoff/` |
| Pi | `~/.pi/agent/skills/handoff/` | `<repo>/.pi/skills/handoff/` |
| Grok | `~/.grok/skills/handoff/` | — |
| **Shared** (Codex + Pi both read it) | `~/.agents/skills/handoff/` | `<repo>/.agents/skills/handoff/` |

The installers auto-detect which agents are present and copy the folder in (creating directories as needed, no symlinks). Target specific agents instead of all:

```sh
sh install.sh --target claude --target codex   # macOS / Linux
sh install.sh --list                           # show where it *would* install, change nothing
```

```powershell
./install.ps1 -Target claude,pi                # Windows
./install.ps1 -List
```

> One copy in `~/.agents/skills/handoff/` is visible to **both** Codex and Pi. Pi can also be pointed at `~/.claude/skills` via its `settings.json` (`{ "skills": ["~/.claude/skills"] }`), so a single install can serve several agents. The installers treat `~/.agents/` as an opt-in target so you don't double-load.

## Continuing from a handoff (for the receiver)

1. Start a **new** session.
2. Paste the **Suggested first message** block.
3. Read the handoff file in full — it's the map.
4. Follow it to the referenced artifacts and pick up the work.

## How it's organized

- `SKILL.md` — the agent-facing skill: contract, workflow summary, quality bar.
- `workflows/Handoff.md` — the step-by-step procedure the agent follows.
- `references/`
  - `template.md` — the structure of a produced handoff document.
  - `destinations.md` — portable per-OS write paths + the canonical first-message format (the fallback when no agent-specific overlay applies).
  - `claude-code.md`, `codex.md`, `pi.md`, `grok.md` — optional per-agent overlays (where to write, sibling tools, first-message extras).
- `scripts/` — optional verifiers (see below).
- `install.sh` / `install.ps1` — cross-platform installers.

The core is identical everywhere; anything agent-specific lives in the `references/*.md` overlays.

## Verifying / contributing

Two scripts check the skill stays consistent — useful if you fork or edit it. They resolve paths relative to the repo and need no install:

```sh
python3 scripts/verify-handoff-skill.py                 # structural + portability checks
python3 scripts/verify-handoff-output.py <handoff.md>   # checks a produced doc matches the template
```

```powershell
uv run python scripts\verify-handoff-skill.py
uv run python scripts\verify-handoff-output.py C:\path\to\handoff.md
```

## Design principles

- **Forward-looking, not a transcript** — optimized for what the next agent will *do*.
- **Disposable** — handoff files are working documents, not permanent records.
- **Pointers over prose** — reference artifacts by path; never duplicate content recoverable from git or a named file.
- **Honest** — if the work is blocked, the handoff says why.
- **Zero lock-in** — no proprietary tooling required; agent-specific behavior is isolated in overlays.

For the full specification, read `SKILL.md`.

## License

[MIT](LICENSE) — free to use, modify, and share.
