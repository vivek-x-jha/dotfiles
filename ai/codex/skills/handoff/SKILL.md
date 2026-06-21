---
name: handoff
description: Compact the current conversation into a temporary Markdown handoff for a fresh Codex conversation or another coding agent. Use when the user asks to hand off, resume elsewhere, continue in a new conversation, preserve session context, or prepare work before clearing or switching context.
---

# Handoff

Produce a concise, transfer-ready snapshot of the current work. Treat it as an ephemeral bridge between conversations, not permanent project documentation.

## Workflow

1. Determine the next conversation's goal from the user's arguments. If none are supplied, infer it from the latest unresolved request and state that inference.
2. Inspect current state when relevant and inexpensive. Prefer live evidence such as `pwd`, `git status --short --branch`, recent commits, changed files, test results, running services, and deployment URLs over stale conversation claims.
3. Create a temporary Markdown path outside the repository. Use `mktemp -t handoff-XXXXXX.md`; if that form is unsupported, use `mktemp "${TMPDIR:-/tmp}/handoff-XXXXXX.md"`.
4. Write the handoff using the structure below.
5. Redact credentials, tokens, cookies, private keys, personal data, and sensitive command output. Never place secret values in the handoff.
6. Read the completed file back and confirm that paths, commands, branch names, status, and next actions are internally consistent.
7. Return the absolute path and this ready-to-use prompt for the receiving conversation:

   `Read the handoff at <absolute-path>. Verify live repository state, then continue from its Next Actions section.`

Do not commit the handoff or write it into the active workspace unless the user explicitly requests a persistent project artifact.

## Document Structure

```markdown
# Handoff: <short task name>

Generated: <ISO-8601 timestamp>
Working directory: <absolute path or "not applicable">

## Next Session Goal
<What the fresh conversation should accomplish.>

## State of Play
- <Completed work and confirmed current behavior.>
- <Current branch, worktree state, running process, or deployment state when relevant.>

## Decisions and Constraints
- <Important user decisions, requirements, and rejected approaches.>

## Open Issues
- <Known blockers, uncertainties, regressions, or "None known".>

## Next Actions
1. <First concrete action.>
2. <Subsequent actions in execution order.>

## Verification
- <Checks already run and their outcomes.>
- <Checks still required.>

## Suggested Skills
- `$<skill-name>`: <why the next conversation should use it>.

## Artifacts
- `<path-or-url>`: <why it matters>.
```

## Compression Rules

- Include only context needed to continue correctly.
- Reference existing PRDs, plans, ADRs, issues, commits, diffs, documentation, and source files by path or URL instead of copying their contents.
- Preserve exact error messages only when they remain diagnostically important.
- Distinguish verified live state from remembered or inferred state.
- List user-authored changes that must not be reverted.
- Omit conversational history, brainstorming, and completed dead ends unless they constrain the next action.
- Suggest only skills that are available or clearly required; omit the section entry when no skill is useful.
