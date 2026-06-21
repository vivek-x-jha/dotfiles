---
name: "generate-practice-sheet"
description: "Create a new worksheet in the practice-sheets repo for algebra, algebra2, arithmetic, calculus, geometry, or teasers; follow AGENTS.md subject guidance, match existing LaTeX style, build the PDF, clean artifacts, and report source/PDF paths."
metadata:
  short-description: "Create worksheet"
---

# Generate Practice Sheet

Use this skill when the user asks to generate, create, or make a new practice sheet or worksheet in `/Users/mubuntu/Developer/practice-sheets`.

## Workflow

1. Read `AGENTS.md` and use the relevant subject section.
2. Inspect nearby files in `<subject>/src` with `fd` and sample one or two representative sheets.
3. Choose a concise filename in `<subject>/src/<topic>.tex`.
4. Create the worksheet using the repo's existing LaTeX style.
5. Include formulas/reference facts when useful for the requested topic.
6. Build and clean using the `build-clean-latex` workflow.
7. Report the source and PDF paths.

## Subject Paths

- Algebra: `algebra/src` -> `algebra/build`
- Algebra II: `algebra2/src` -> `algebra2/build`
- Arithmetic: `arithmetic/src` -> `arithmetic/build`
- Calculus: `calculus/src` -> `calculus/build`
- Geometry: `geometry/src` -> `geometry/build`
- Teasers: `teasers/src` -> `teasers/build`

## Constraints

- Do not stop at a proposal unless the user explicitly asks for planning only.
- Keep edits scoped to the new sheet unless docs updates are explicitly requested.
- Prefer exact forms unless the worksheet asks for rounding.
- Avoid answer keys unless requested.
- Build and clean after creation; do not ask for cleanup permission.
