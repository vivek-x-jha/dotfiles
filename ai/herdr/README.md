# Herdr

Repo-managed Herdr config and helpers.

## Agent pane titles

`herdr-claude-title-watch` labels Claude Code panes with the generated session
name and the Nerd Font star icon (``). This also applies to `claudex`, since
that alias launches the wrapped `claude` command. Until Claude writes an
`ai-title` or `custom-title` event, the pane displays `  Claude Code`.

`herdr-codex-title-watch` similarly labels Codex panes with the Codex thread
name and the Nerd Font robot-outline icon. A new Codex session has no thread
name until its first prompt, so the pane keeps its initial label until Codex
writes that name to `$CODEX_HOME/session_index.jsonl`.

When a session name becomes available, the watchers clear generated `terminal`
or agent-name labels before reporting metadata because explicit Herdr labels
take precedence over agent metadata. Other manually assigned labels are left
untouched.

Interactive shells start the watchers through the `claude` and `codex` shell
wrappers. `herdr-resurrect restore` also starts the matching watcher explicitly
alongside restored Claude Code and Codex commands. Saved state keeps canonical
resume commands; restore also accepts older Codex state containing a watcher
prefix.

## Process restore

Herdr persists spaces, tabs, panes, cwd, and pane history, but OS processes do not survive a machine reboot. `herdr-resurrect` is a small tmux-resurrect-style helper for the first-priority interactive processes:

```sh
herdr-resurrect save     # record foreground nvim/pi/claude/codex commands in panes
herdr-resurrect restore  # rerun them in the same panes if those panes are idle
herdr-resurrect list     # inspect saved commands
herdr-resurrect clear-idle # run clear in idle panes
```

Current restore support:

- `nvim` foreground commands, including `nvim -S Session.vim`
- `pi` panes, using `pi --session <session-file>` when Herdr reports a session path
- Claude Code panes, using `claude --resume <session-id>`; `claudex` sessions retain the local proxy/model launcher
- `codex` panes, using `codex resume <session-id>` from Herdr metadata or the live Codex session file, otherwise `codex resume --last`

Claude Code and Codex restore start their title watcher in the saved working directory.

State is local runtime data at `$XDG_STATE_HOME/herdr/resurrect.json` and is intentionally not tracked.

`restore` also runs `clear` in idle panes that did not get a restored process. This avoids stale shell/pane-history artifacts such as zsh's `%` partial-line marker after reboot. Disable that behavior with `HERDR_RESURRECT_CLEAR_IDLE=0 herdr-resurrect restore`.
