# Handoff document template

Use this structure when writing the handoff file. The template is harness-neutral — do not embed commands or tool names that only exist in one harness unless you have confirmed the receiver runs it.

**Mandatory sections (always include):** frontmatter, the `# Handoff — …` title, `**Next session goal:**`, `## Suggested first message`, `## Current state` (with all four rows), and `## Suggested skills`.

**Optional sections (omit if they do not apply):** `## Decisions`, `## Failed approaches`, `## Artifacts`, `## Relevant files`, `## Policy / safety notes`, `## Optional follow-ups`. Keep the doc tight — a cold-start handoff with no prior decisions or artifacts may legitimately skip those.

```markdown
---
title: "Handoff — <short goal>"
created: YYYY-MM-DD
source_session: <session id or "unknown">
goal: "<next-session goal in one sentence>"
workspace: "<workspace root if relevant>"
---

# Handoff — <short goal>

**Next session goal:** <repeat goal>

## Suggested first message

\`\`\`
<paste-ready block for the new session — see references/destinations.md for the portable format, or your harness overlay for extras>
\`\`\`

## Decisions (do not re-litigate)

- <decision> — <one-line rationale>

## Current state

| Area | Status |
|------|--------|
| COMPLETED | <specific accomplishments> |
| IN PROGRESS | <what is partially done> |
| NEXT | <single concrete next action> |
| BLOCKERS | <none or specific blocker> |

## Failed approaches (avoid repeating)

- <what was tried> — <why it failed or was abandoned>

## Artifacts (read these; do not duplicate)

| Artifact | Path | Why it matters |
|----------|------|----------------|
| ... | `<absolute or repo-relative path>` | ... |

## Relevant files (read order)

1. `<path>` — <why>
2. ...

## Suggested skills

- `/<skill>` — <why for this goal>

## Policy / safety notes

- <e.g. sanitize paths for public writes; a write hook denied earlier; secrets redacted>

## Optional follow-ups

- <Only commands valid in the receiver's harness. Leave empty unless your overlay names a relevant project/session tool.>
```

Keep total length proportional to goal complexity. Prefer pointers over prose.
