# Portable destinations & first-message format

The harness-neutral defaults. Use these when no harness overlay applies, or as the base that overlays extend.

## Write destination (per OS)

Write the handoff file into the OS temp directory, under an `agent-handoffs/` subfolder. Resolve the temp root from the environment — do not hardcode a path:

| OS | Temp root | Resolve via |
|----|-----------|-------------|
| Windows | `%TEMP%` (e.g. `C:\Users\<you>\AppData\Local\Temp`) | `$env:TEMP` (PowerShell) / `%TEMP%` (cmd) |
| macOS | `$TMPDIR` (e.g. `/var/folders/...`), fallback `/tmp` | `${TMPDIR:-/tmp}` |
| Linux | `$TMPDIR` if set, else `/tmp` | `${TMPDIR:-/tmp}` |

Full path pattern: `<temp-root>/agent-handoffs/YYYY-MM-DD-<slug>.md`

- Create the `agent-handoffs/` directory if missing.
- `<slug>` is a kebab-case hint derived from the goal, max ~40 chars.
- Use forward slashes in the doc when referring to the path on Unix; on Windows either separator works, but print the path exactly as the OS reports it so the user can click/copy it.

Fallbacks if the temp write is denied (rare; usually a policy hook):
1. A policy-allowed location named in your harness overlay.
2. A private scratch directory the user controls.
3. Inline in chat — tell the user no file was written.

## First-message format (canonical)

End every handoff with a fenced block the user can paste into a **new** session of the same (or any) harness:

```markdown
Continue from <absolute-path-to-handoff.md>.

Goal for this session: <one sentence>

Read the handoff file in full first. Key artifacts: <comma-separated paths>.
```

This format is intentionally harness-independent: it names a file path and a goal, both of which mean the same thing in every agent CLI. Overlays may add harness-specific lines (e.g. a skill to invoke first) but must preserve these four elements:

1. `Continue from <path>` — the absolute path to the handoff file
2. `Goal for this session:` — one sentence
3. `Read the handoff file in full first` — the receiver contract
4. `Key artifacts:` — comma-separated pointers (use "none" if there are none)
