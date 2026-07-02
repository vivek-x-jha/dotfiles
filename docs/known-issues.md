# Known Issues

Managed ledger for recurring bugs, regressions, environment quirks, and active workarounds in this dotfiles setup.

## Rules

- Update an existing entry before adding a duplicate.
- Keep observations, likely causes, workarounds, reproduction steps, and exit criteria explicit.
- Include `Last verified` dates for facts that can drift.
- Do not include secrets, credentials, private tokens, or raw logs with sensitive values.
- Remove or archive resolved entries after validating their exit criteria.

## Entry Template

```md
## KI-YYYY-MM-DD-short-slug

**Status:** Open | Workaround active | Fixed pending verification | Resolved
**Last verified:** YYYY-MM-DD
**Area:** TODO

**Observed:** TODO

**Likely cause:** TODO, or `Unknown`.

**Workaround:** TODO, or `None known`.

**Reproduce:** TODO

**Exit criteria:** TODO

**References:** TODO
```

## Active Issues

## KI-2026-07-01-tmux-37-blank-pane-rendering

**Status:** Workaround active; tmux is pinned to `3.6b` locally.
**Last verified:** 2026-07-02 (`tmux -V` reports `tmux 3.6b`; `brew list --pinned` includes `tmux@3.6b`).
**Area:** tmux / WezTerm / TUI rendering

**Observed:** In WezTerm on macOS, tmux panes running heavy TUIs such as pi chats or Neovim could render blank or mostly blank. The pane content was still functional and appeared after hover/click/scroll or other external repaint events. The same pi and Neovim sessions rendered normally outside tmux.

**Likely cause:** tmux 3.7 introduced DECSET 2026 synchronized-output handling. The failure reproduced with tmux `3.7a` and disappeared after downgrading to `3.6b`, so treat this as a tmux 3.7/3.7a + WezTerm repaint/synchronized-output regression until retested.

**Workaround:** Keep `tmux@3.6b` linked and pinned locally.

```sh
brew list --pinned | grep '^tmux@3\.6b$'
tmux -V  # expected: tmux 3.6b
```

`update-tools --brew` runs `brew upgrade --formula`, which respects the `tmux@3.6b` pin. Avoid explicitly reinstalling unversioned `tmux` or running `brew bundle` from a Brewfile that contains `brew "tmux"` unless intentionally retesting.

**Reproduce/retest:** When upstream appears fixed, temporarily move back to unversioned tmux and retest pi chats and Neovim inside tmux/WezTerm.

```sh
brew unpin tmux@3.6b
brew unlink tmux@3.6b
brew install tmux
tmux kill-server 2>/dev/null || true
tmux -V
work -r
```

**Exit criteria:** Pi chats and Neovim render correctly inside tmux/WezTerm on an upstream tmux version newer than `3.6b`, without hover/click/scroll repaint workarounds. If fixed, remove the local `tmux@3.6b` formula/tap and update this note.

If still broken, return to the pinned version:

```sh
brew unlink tmux
brew link --force --overwrite tmux@3.6b
brew pin tmux@3.6b
tmux kill-server 2>/dev/null || true
work -r
```

**References:** Local verification only.
