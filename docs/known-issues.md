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
