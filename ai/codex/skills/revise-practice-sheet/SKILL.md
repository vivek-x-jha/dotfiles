---
name: "revise-practice-sheet"
description: "Revise an existing worksheet or cheatsheet in the practice-sheets repo, preserving local style while applying requested changes such as difficulty, wording, formulas, problem count, titles, instructions, or answer keys; then rebuild, clean, and verify."
metadata:
  short-description: "Revise worksheet"
---

# Revise Practice Sheet

Use this skill when the user asks to modify, revise, update, make harder/easier, add/remove problems, change instructions, add solutions, or otherwise edit an existing sheet in `/Users/mubuntu/Developer/practice-sheets`.

## Workflow

1. Locate the existing `.tex` file. Use `fd` when the user gives a basename or topic.
2. Read the current file before editing.
3. Apply only the requested change while preserving the sheet's style, title pattern, and structure unless asked otherwise.
4. If the user asks for answer keys or solutions, append them cleanly at the end and double-check symbolic work.
5. Rebuild and clean using the `build-clean-latex` workflow.
6. Report the source path, PDF path, and a short change summary.

## Common Revisions

- Increase or decrease difficulty.
- Change problem count.
- Remove duplicate questions or instructions.
- Add formulas/reference facts.
- Move formulas to the top.
- Add answer keys or convert answers to multiple choice.
- Update titles and rebuild.

## Constraints

- Never rewrite unrelated sheets.
- Do not revert user changes unless explicitly asked.
- Do not remove PDFs during cleanup.
- Prefer `fd` over `find` when available.
- Build and clean after edits; do not ask for cleanup permission.
