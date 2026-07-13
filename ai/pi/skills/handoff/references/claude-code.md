# Claude Code overlay — handoff skill

Load when executing `handoff` in **Claude Code**.

## Install location

- Personal (all projects): `~/.claude/skills/handoff/`
- Project (this repo only): `<repo>/.claude/skills/handoff/`

Claude Code auto-invokes by matching the `description` field (no `triggers:` needed), and `/handoff <goal>` works directly. Arguments after `/handoff` arrive as `$ARGUMENTS` / `$1`, but you should read the goal from the user's request rather than depending on substitution — that keeps the skill identical across harnesses.

## Write destination

Use the portable default in `references/destinations.md` (OS temp `agent-handoffs/`). Claude Code imposes no special handoff destination policy by default. If a project has a `PreToolUse` hook that blocks writes to certain paths, fall back per the destinations doc.

On Windows, Claude Code may run the Bash tool (Git Bash) and a PowerShell tool; either can write the file. Print the path as the OS reports it.

## Context worth capturing

When relevant to the goal:

- Working directory / repo root and current branch
- Open todos (from the task list, if any were seeded)
- Any hook denials encountered this session and the safe alternative used
- Whether changes are committed or still in the working tree

## Suggested skills for Claude Code receivers

Prefer skills present in the receiver's environment (check `~/.claude/skills/` and any project `.claude/skills/`). Common pairings:

| Next-session goal | Often invoke |
|-------------------|--------------|
| Verify a change actually works | `/verify`, `verified-task` |
| Review a diff before PR | `/code-review`, `/security-review` |
| Simplify recently changed code | `/simplify` |
| Plan a multi-step feature | `compound-engineering:ce-plan` |
| Commit / open a PR | `compound-engineering:ce-commit-push-pr` |

List only skills you can confirm exist for the receiver — otherwise describe the action in plain language.

## Optional follow-ups

Claude Code has no built-in project-progress CLI. Leave the handoff doc's "Optional follow-ups" empty unless the project defines its own command.

## First message

Use the canonical block in `references/destinations.md`. You may add one line naming a skill to invoke first, e.g.:

```markdown
Continue from <absolute-path-to-handoff.md>.

Goal for this session: <one sentence>

Read the handoff file in full first. Key artifacts: <comma-separated paths>.
Suggested first skill: /<skill> — <why>.
```
