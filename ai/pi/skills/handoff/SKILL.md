---
name: handoff
description: |
  Goal-directed session handoff for a fresh agent thread (Amp-style extraction, not lossy compaction). Use when the user runs /handoff, asks to hand off context, start a new session with a focused goal, split work to another thread, or preserve continuity before ending a session. Argument is the goal for the next session — e.g. "/handoff implement phase one of the plan" or "/handoff debug the checkout 400 error".
---

# handoff

Extract what matters for a **new, focused session** — do not summarize the whole thread for in-place compaction. The user names the next-session goal; you produce a disposable transfer document plus a copy-paste first message.

This skill is **harness-agnostic**: it runs the same in Claude Code, Codex, Pi, Grok, or any agent CLI that loads a `SKILL.md`. It has **no external dependencies** — no `soma`, no projection system, nothing beyond file writes and the host agent. Harness-specific details (where to write, sibling tools, policy) live in optional overlay files under `references/`.

## When to use (vs other tools)

Described by function — exact command names vary by harness (see your overlay).

| Function | Use when | This skill? |
|----------|----------|-------------|
| **handoff** | Split to a **new** session with a **specific goal**; keep current thread clean | ✅ yes |
| in-place compaction (often `/compact`) | Stay in the **same** thread; recover context-window headroom | no |
| branch/fork the thread | Continue with a **copy** of full conversation history | no |
| durable memory write | Save **long-term lessons**, not session transfer | no |

If the user wants a *new focused thread*, this is the right tool. If they want to keep working in place, point them at their harness's compaction command instead.

## Harness overlays

Before choosing a write destination or naming sibling tools, read your harness's overlay if it exists. If you cannot tell which harness you are in, use the portable default in `references/destinations.md`.

| If you are running in | Read overlay | Detect via |
|-----------------------|--------------|------------|
| Claude Code | `references/claude-code.md` | you are Claude Code; `~/.claude/` exists |
| Codex CLI | `references/codex.md` | `CODEX_HOME` env or `~/.codex/` exists |
| Pi | `references/pi.md` | `PI_CODING_AGENT_DIR` env or `~/.pi/` exists |
| Grok | `references/grok.md` | `~/.grok/` exists |
| anything else | none — use `references/destinations.md` | portable default |

Overlays are **additive and optional**. The skill is fully functional with none of them: it falls back to the OS temp directory and emits a generic first message.

## Workflow

Start with `workflows/Handoff.md` for the full step list. Summary:

1. **Parse the goal** — User arguments (or a short clarifying question) define what the *next* session will do. Everything else is out of scope for the handoff doc. (Argument passing varies by harness — see `references/destinations.md`; never rely on `$ARGUMENTS`-style substitution, which only some harnesses support.)
2. **Gather** — Decisions, blockers, COMPLETED / IN PROGRESS / NEXT, artifact paths (plans, reports, open PRs), relevant files to read (with order), failed approaches worth avoiding.
3. **Do not duplicate** — Point at existing artifacts by path or URL. Never paste large plan bodies or other content recoverable from a named artifact.
4. **Redact** — No API keys, passwords, or PII.
5. **Suggested skills** — List skills the receiver should invoke first, with one line each on why. Prefer skills you can confirm exist in the receiving harness (see your overlay).
6. **Write** — Use `references/template.md` structure. Pick destination per your harness overlay, or the OS temp default in `references/destinations.md`.
7. **Clipboard** — Copy the complete **Suggested first message** block to the user's clipboard when a supported clipboard command is available (`pbcopy` on macOS, `xclip`/`xsel` on Linux, or `clip.exe` on Windows). Do not put the handoff document itself on the clipboard. If no clipboard command is available, continue without failing and say so.
8. **Deliver** — Print the absolute path to the handoff file and the **Suggested first message** block (copy-paste ready). Tell the user to start a new session and paste it.

## Receiver contract

When continuing from a handoff file: **read the FULL file** before acting. Do not skim. Artifacts referenced in the doc are authoritative; the handoff is the map, not the source of truth for their contents.

## Quality bar

- Forward-looking: optimized for what the *next* agent will **do**, not a transcript of what happened.
- Specific next step: concrete action, not "continue working."
- Honest blockers: if stuck, say why.
- Disposable: handoff files are working documents, not permanent repo docs (unless the user explicitly asks to keep one in the workspace).
- Portable: no harness-specific command names in the body of the handoff doc unless you confirmed the receiver runs that harness.

## Verification (optional)

Regression scripts live in `scripts/`. They resolve paths relative to this skill directory and require no external install:

- `scripts/verify-handoff-skill.py` — structural checks (skill files present, frontmatter contract, template/workflow contract)
- `scripts/verify-handoff-output.py <handoff.md>` — behavioral check that a produced handoff matches `references/template.md`

Run after editing this skill or validating `/handoff` output. Use whichever Python launcher you have:

```sh
python3 scripts/verify-handoff-skill.py      # or: uv run python scripts/verify-handoff-skill.py
```
