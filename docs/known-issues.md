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

## KI-2026-07-02-iterm-float-work-restore-race

**Status:** Fixed pending verification after a reboot/full restore cycle.
**Last verified:** 2026-07-02 (`laptop-dev-hotkey` no longer uses Initial Text; live and source iTerm profiles run `terminals/tmux/scripts/work-float`).
**Area:** iTerm2 hotkey window / tmux / `work -r`

**Observed:** The iTerm floating hotkey window could appear attached to the restored `pi` tmux session instead of `float`, and `work float` could be delivered to an active chat pane, creating odd duplicate/inactive `cia` chats such as `pi:c`.

**Likely cause:** The iTerm hotkey profile mixed a real command with `Initial Text: work float`. Initial Text is keystroke injection, so restored/reused iTerm state could type into whatever tmux pane was active. `work float` could also race `work -r`/tmux-resurrect while tmux was restoring active clients.

**Workaround/fix:** The `laptop-dev-hotkey` profile now clears Initial Text and runs a real command:

```sh
/bin/bash -c 'exec "$HOME/.dotfiles/terminals/tmux/scripts/work-float"'
```

`work-float` waits on `~/.local/state/tmux/work-restore.lock` before running `work float`; `work -r` creates/removes that lock around restore.

**Reproduce/retest:** Save tmux, restart, open WezTerm, run `work -r`, then summon the iTerm hotkey window. Check clients:

```sh
tmux list-clients -F '#{client_tty} #{client_session} #{client_last_session}'
```

**Exit criteria:** After a reboot/full restore cycle, WezTerm can remain on `pi`, the iTerm hotkey client attaches to `float`, and no `work float` text or duplicate `cia` chat appears in active chat input. If stable, archive this entry as resolved.

**References:** Local verification only.
