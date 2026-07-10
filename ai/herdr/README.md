# Herdr

Repo-managed Herdr config and helpers.

## Process restore

Herdr persists spaces, tabs, panes, cwd, and pane history, but OS processes do not survive a machine reboot. `herdr-resurrect` is a small tmux-resurrect-style helper for the first-priority interactive processes:

```sh
herdr-resurrect save     # record foreground nvim/pi/codex commands in panes
herdr-resurrect restore  # rerun them in the same panes if those panes are idle
herdr-resurrect list     # inspect saved commands
herdr-resurrect clear-idle # run clear in idle panes
```

Current restore support:

- `nvim` foreground commands, including `nvim -S Session.vim`
- `pi` panes, using `pi --session <session-file>` when Herdr reports a session path
- `codex` panes, using `codex resume <session-id>` from Herdr metadata or the live Codex session file, otherwise `codex resume --last`

State is local runtime data at `$XDG_STATE_HOME/herdr/resurrect.json` and is intentionally not tracked.

`restore` also runs `clear` in idle panes that did not get a restored process. This avoids stale shell/pane-history artifacts such as zsh's `%` partial-line marker after reboot. Disable that behavior with `HERDR_RESURRECT_CLEAR_IDLE=0 herdr-resurrect restore`.
