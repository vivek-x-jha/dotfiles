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
