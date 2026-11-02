# Herdr

Repo-managed Herdr config and helpers.

## Neovim pane navigation

[`vim-herdr-navigation`](https://github.com/paulbkim-dev/vim-herdr-navigation)
provides seamless `<C-h/j/k/l>` navigation between Neovim splits and Herdr
panes. Install its Herdr side once with:

```sh
herdr plugin install paulbkim-dev/vim-herdr-navigation -y
```

The Neovim side is registered through native `vim.pack` and configured in
`editors/nvim/lua/plugins/herdr-navigation.lua`. The plugin owns the direct
`<C-h/j/k/l>` bindings; the built-in pane-focus bindings are disabled.

## Smart pane swap

Press `Ctrl+A`, release, then `x` to exchange the current pane with a neighbor
in either a side-by-side or stacked layout. `herdr-smart-swap` tries down,
right, up, then left and stops after one swap. A single-pane tab is a no-op.
Mixed layouts use that same direction priority. This exchanges pane positions;
it does not rotate the split or restart any processes.

A direct down-only swap remains available with `Ctrl+A`, then `Shift+X`.

Check the helper without changing live panes:

```sh
python3 ai/herdr/tests/test_smart_swap.py
```

## Reload Pi chats across sessions

Press **Ctrl+A**, release, then **Alt+R** (Option+R on macOS) to open a
confirmation popup. Type `y` and Enter to discard drafts and send `/reload` to
idle Pi chats across **all running local sessions**. Enter alone cancels.
The popup shows per-pane results and sends a summary notification; press Enter
again to close it. Busy chats are skipped. Close Pi dialogs/pickers first.

The shortcut calls the repo helper directly with `--confirm`, so it does not
require a new `~/.local/bin` symlink. It leaves the existing Ctrl+A then Ctrl+R
(process restore) and Ctrl+A then Shift+R (Herdr config reload) bindings alone.

`herdr-pi-reload` discovers **all running local Herdr sessions**, including the
unnamed/default session and `float`; it is not tied to any workspace or session name.
Bootstrap links the helper into `~/.local/bin`. Before that, use
`~/.dotfiles/ai/herdr/scripts/herdr-pi-reload` directly.

```sh
herdr-pi-reload --dry-run                 # preview eligible Pi panes; no input sent
herdr-pi-reload                           # clear drafts and send /reload everywhere
herdr-pi-reload --session my-session      # restrict to one session
herdr-pi-reload --session one --session two
```

**Drafts are discarded**, including multiline prompts. Leave chats at their normal
prompt, close dialogs/pickers, and do not type into them while the helper runs.
The helper sends Pi's default `Ctrl+C` clear-editor action once, then `/reload`
and Enter. It pauses before clearing to avoid Pi's double-Ctrl+C exit shortcut.
This assumes the default `app.clear` binding and normal prompt focus; terminal
injection cannot verify a custom editor or dialog's input state. Do not use this
helper with a remapped/intercepted clear action.

Only idle/done foreground Pi processes are eligible. Busy, blocked, unknown, and
suspended chats are skipped; other agents and stopped sessions are untouched.
Targets are rechecked before clearing and before submitting. `SENT` means input
was delivered, not that Pi confirmed a successful reload. Rerun for skipped chats
once they are idle. Errors produce a nonzero exit status.

Check without changing live panes:

```sh
python3 ai/herdr/tests/test_pi_reload.py
```

## Agent pane titles

Pi pane labels and agent display titles follow the current chat name. The Pi
extension restores display metadata when a Herdr live handoff replaces its socket.

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
herdr-resurrect save     # record foreground nvim/btop/pi/claude/codex commands in panes
herdr-resurrect restore  # rerun them in the same panes if those panes are idle
herdr-resurrect list     # inspect saved commands
herdr-resurrect clear-idle # run clear in idle panes
```

Current restore support:

- `nvim` foreground commands, including `nvim -S Session.vim`
- `btop` foreground commands
- `pi` panes, using `pi --session <session-file>` when Herdr reports a session path
- Claude Code panes, using `claude --resume <session-id>`; `claudex` sessions retain the local proxy/model launcher
- `codex` panes, using `codex resume <session-id>` from Herdr metadata or the live Codex session file, otherwise `codex resume --last`

Claude Code and Codex restore start their title watcher in the saved working directory.

State is local runtime data at `$XDG_STATE_HOME/herdr/sessions/<session>/resurrect.json` and is intentionally not tracked. Per-session files keep saves from the main and floating Herdr sessions from overwriting each other. Existing single-file state is still accepted when it belongs to the active session.

`restore` also runs `clear` in idle panes that did not get a restored process. This avoids stale shell/pane-history artifacts such as zsh's `%` partial-line marker after reboot. Disable that behavior with `HERDR_RESURRECT_CLEAR_IDLE=0 herdr-resurrect restore`.
