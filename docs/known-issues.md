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

## KI-2026-07-13-blink-cmp-neovim-012-pos-regression

**Status:** Workaround active.
**Last verified:** 2026-07-13 (Neovim 0.12.0 with blink.cmp `db8ea0b`).
**Area:** Neovim completion / blink.cmp

**Observed:** Typing with blink.cmp enabled raised `vim/pos.lua:206: attempt to index local 'pos' (a number value)` from `blink.cmp` completion triggers.

**Likely cause:** blink.cmp `db8ea0b` added a Neovim 0.12 compatibility branch that calls `vim.pos.cursor(buf, pos)`, but the installed Neovim 0.12.0 runtime expects `vim.pos.cursor(pos, opts)`. Calling `blink.cmp.completion.trigger.context.get_pos()` reproduced the same error directly.

**Workaround:** Pin blink.cmp to the last known-good revision, `cfe100ccac24b0a622d7b9f04aa8c9f3e7624a16`, in both `editors/nvim/init.lua` and `editors/nvim/nvim-pack-lock.json` so routine plugin updates do not restore the broken revision.

**Reproduce/retest:** On the broken revision, run `NVIM_LOG_FILE="$HOME/.local/state/nvim/nvim.log" nvim --headless "+lua local ok,res=pcall(require('blink.cmp.completion.trigger.context').get_pos); print(ok, res)" '+qa'`. After removing the pin for an upstream fix, verify completion while typing in insert and terminal modes.

**Exit criteria:** A newer blink.cmp revision uses the installed Neovim 0.12 `vim.Pos` signature and completion works in insert and terminal modes; then remove the explicit version pin and this entry.

**References:** `editors/nvim/init.lua`, `editors/nvim/nvim-pack-lock.json`, upstream blink.cmp commits `f187527` and `db8ea0b`.

## KI-2026-07-12-herdr-resurrect-command-injection

**Status:** Fixed pending verification.
**Last verified:** 2026-07-12 (live process evidence and shell validation).
**Area:** Herdr process resurrection

**Observed:** Re-running resurrection could insert a session-specific restore command as text into a pane where Neovim was already running.

**Likely cause:** Restore commands used `exec`, replacing the pane shell. Herdr then reported the foreground application PID as `shell_pid`, and the idle check incorrectly treated that application as an idle shell.

**Workaround/fix:** `herdr-resurrect` no longer wraps restored commands with `exec`, and `pane_is_idle` now verifies that the reported shell process is a recognized shell before injecting a command.

**Reproduce/retest:** Save and restore panes containing Neovim, Pi, and Codex, then invoke restore again while they remain active. Confirm all panes are reported busy and no restore command is inserted into an application.

**Exit criteria:** A complete save/restore cycle followed by repeated restore attempts leaves every active application unchanged and still restores idle panes correctly.

**References:** `ai/herdr/scripts/herdr-resurrect`.

## KI-2026-07-09-clean-macos-bootstrap-validation

**Status:** Open; guarded validation harness implemented, destructive VM run pending.
**Last verified:** 2026-07-09 (source fixtures and dry-runs only).
**Area:** Bootstrap / clean Apple Silicon macOS

**Observed:** Installer, profile composition, dependency/checkpoint behavior, idempotence, and full dry-run fixtures pass, but a complete package-installing run and convergence rerun have not yet been executed on a clean Apple Silicon macOS VM.

**Likely cause:** No disposable clean macOS VM is available in the current agent environment, and running the test on the live workstation would make broad global package and OS changes.

**Workaround:** In a disposable arm64 macOS VM, finish Command Line Tools installation and run `BOOTSTRAP_ALLOW_VM_INSTALL=1 bootstrap/tests/macos-vm.sh`. The harness records first-run, rerun, doctor, and timing logs under `$XDG_STATE_HOME/dotfiles/vm-validation/`.

**Reproduce/retest:** Start with a clean VM user that has no bootstrap completion marker, clone the repository, run the guarded harness, and inspect both timing logs and doctor output.

**Exit criteria:** The complete core install, immediate convergence rerun, and doctor all pass on a clean Apple Silicon VM; record the tested macOS version and elapsed timings, then resolve this entry.

**References:** `bootstrap/tests/macos-vm.sh`, `bootstrap/tests/macos-vm.env`.

## KI-2026-07-02-iterm-float-shared-session-redraw

**Status:** Mitigated in source; pending live verification in the iTerm floating profile.
**Last verified:** 2026-07-07 (source only: float launcher now uses `herdr --session float`).
**Area:** iTerm2 floating profile / Herdr multi-client redraw

**Observed:** Launching the floating iTerm2 profile while Herdr was already open in WezTerm could shift or redraw the WezTerm TUI.

**Likely cause:** Both terminals were attaching to the same Herdr session, so the second client could perturb shared layout/geometry.

**Workaround/fix:** Point the iTerm profile at the repo launcher:

```sh
/bin/bash -lc 'exec "$HOME/.dotfiles/terminals/iterm2/scripts/float-herdr.sh"'
```

`terminals/iterm2/scripts/float-herdr.sh` clears inherited `HERDR_*` variables and starts `/Users/mubuntu/.local/bin/herdr --session float`, isolating the floating terminal from the main Herdr session used elsewhere.

**Reproduce/retest:** Open Herdr in WezTerm, then summon the iTerm floating profile. Confirm the float terminal lands in session `float` and WezTerm does not visibly reflow.

**Exit criteria:** The floating iTerm profile consistently opens the separate Herdr `float` session without disturbing the WezTerm client.

**References:** Local source update only.
