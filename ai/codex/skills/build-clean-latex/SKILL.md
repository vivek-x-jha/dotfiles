---
name: "build-clean-latex"
description: "Build a LaTeX worksheet or cheatsheet in the practice-sheets repo, clean non-PDF artifacts after a successful latexmk build, and verify the PDF remains. Use when the user asks to build, rebuild, clean, compile, or verify a .tex file in this repo."
metadata:
  short-description: "Build and clean LaTeX"
---

# Build Clean LaTeX

Use this skill for LaTeX build requests in `/Users/mubuntu/Developer/practice-sheets`.

## Workflow

1. Identify the `.tex` file. If the user gives only a topic or basename, locate it with `fd`.
2. Derive the subject from the path: `<subject>/src/<file>.tex`.
3. Build sequentially:
   ```sh
   latexmk -pdf -f -output-directory=<subject>/build <subject>/src/<file>.tex
   ```
4. If the build succeeds, clean immediately:
   ```sh
   latexmk -c -output-directory=<subject>/build <subject>/src/<file>.tex
   ```
5. Verify the PDF remains:
   ```sh
   fd '<file-basename>' <subject>/build
   ```
6. If `latexmk -c` leaves non-PDF artifacts for that file, remove only that file's generated artifacts:
   `*.aux`, `*.log`, `*.fls`, `*.fdb_latexmk`, `*.synctex.gz`, `*.out`, `*.toc`.

## Constraints

- Never run build and clean in parallel.
- Do not ask whether to clean after a successful build; cleanup is part of the hook.
- Do not delete PDFs.
- Prefer `fd` over `find` when available.
- Report the source path, PDF path, and whether cleanup left only the PDF.

## Helper Script

For deterministic execution, use `scripts/build-clean-latex.sh <path-to-tex>` when convenient.
