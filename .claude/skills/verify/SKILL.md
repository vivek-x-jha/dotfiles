---
name: verify
description: Verify dotfiles environment, XDG path, and managed symlink changes through clean shells and the real installed CLI.
---

# Verify dotfiles runtime changes

1. Read `AGENTS.md`, establish the relevant uncommitted diff, and avoid unrelated dirty files.
2. For shell environment changes, start a clean shell that explicitly sources `~/.zshenv` and print only the variable/path being verified:
   ```sh
   env -i HOME="$HOME" USER="$USER" PATH="/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin" \
     /bin/zsh -dfc 'source "$HOME/.zshenv"; printf "%s\n" "$VARIABLE"; command -v tool'
   ```
3. Inspect managed link type, relative target, real target, ownership, and security-sensitive modes without reading credential contents.
4. Drive the installed tool through its public CLI at least twice. Confirm reported config/data paths and that repeated use does not recreate a legacy real directory or split state.
5. When a compatibility symlink is intentional, probe once with the environment override unset and confirm the reported legacy path resolves to the same real file.
6. On macOS, compare `launchctl getenv VARIABLE` with the shell value when bootstrap publishes it.
7. Run `./bootstrap.sh --doctor` and report unrelated failures separately; run `./bootstrap.sh --dry-run --only symlinks` to observe managed-link convergence without changing state.
8. Finish with `git diff --check` for the touched paths. Do not run the repository test suite as runtime verification.
