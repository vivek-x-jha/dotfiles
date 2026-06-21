---
name: manage-2fa
description: Manage the personal 2FA backup-code repository at /Users/mubuntu/Documents/2fa. Use when the user asks to add a service/site to the 2FA README, import or move downloaded backup/recovery-code files from ~/Downloads, normalize a code filename to the site2fa.txt convention, review an import, or commit and push those changes.
---

# Manage 2FA

Use `/Users/mubuntu/Documents/2fa/scripts/manage_2fa.py` as the deterministic backend. Never read, print, summarize, or expose recovery-code file contents.

## Add A Site

1. Obtain the site display name and absolute `http://` or `https://` URL from the request. Ask only for a missing value that cannot be inferred safely.
2. Run a preview:

   ```sh
   /Users/mubuntu/Documents/2fa/scripts/manage_2fa.py add "<site>" "<url>" --dry-run
   ```

3. If the preview succeeds, run the same command without `--dry-run`.
4. Inspect `git diff -- README.md` and report the added or already-present entry.

Do not replace an existing site's URL when the command reports a conflict. Surface the conflict and ask the user which URL is authoritative.

## Import A Download

1. Inspect candidate filenames only. Do not display file contents:

   ```sh
   find "$HOME/Downloads" -maxdepth 1 -type f \( -iname '*2fa*.txt' -o -iname '*2fa*.csv' -o -iname '*backup*code*.txt' -o -iname '*backup*code*.csv' -o -iname '*recovery*code*.txt' -o -iname '*recovery*code*.csv' \) -print
   ```

2. When exactly one candidate exists, preview it:

   ```sh
   /Users/mubuntu/Documents/2fa/scripts/manage_2fa.py import-download --file "<filename>" --dry-run
   ```

3. When multiple candidates exist, select the one identified by the user. If none is identified, ask which filename to import.
4. If the site already exists in the README, allow the script to reuse its URL. For a new site, obtain the correct URL from the user and pass `--url`; use `--site` when filename inference produces the wrong display name.
5. After a successful preview, rerun without `--dry-run`.
6. Verify the source no longer exists, the normalized `<site>2fa.txt` destination exists, and the README entry is correct. Use metadata and filenames only; never inspect code contents.

Never overwrite a destination collision. Report the existing destination and leave both files untouched.

## Review And Git

- Preserve unrelated dirty worktree changes. Treat pre-existing files as user-owned.
- After mutation, inspect `git status --short` and targeted diffs. Do not include recovery-code contents in chat output.
- Leave changes uncommitted unless the user explicitly requests a commit or push.
- For an explicit commit or push, stage only the imported code file, README, and directly related automation files requested in the same task. Commit with a concise message, push the current tracked branch, and verify final status.

## Validation

When automation code changes, run:

```sh
cd /Users/mubuntu/Documents/2fa
basedpyright scripts tests
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -v
git diff --check
```
