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

## KI-2026-07-16-vscode-shared-home-directory

**Status:** Workaround active.
**Last verified:** 2026-07-16 (VS Code 1.129.0).
**Area:** VS Code shared application state

**Observed:** Without a portable root, starting VS Code creates `~/.vscode-shared/sharedStorage/state.vscdb`, a small SQLite store for cross-profile recent-workspace and workspace-trust state.

**Likely cause:** VS Code's product metadata sets `sharedDataFolderName` to `.vscode-shared`, and the application environment service resolves that name directly below the user home directory unless a launch argument or portable root overrides it. XDG environment variables alone do not affect this path.

**Workaround:** Set `VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"` in the shell and macOS launchd environments. Existing native macOS user data is migrated to `$VSCODE_PORTABLE/user-data`, and existing shared state is migrated to `$VSCODE_PORTABLE/shared-data`. This handles CLI and GUI launches without a home-directory compatibility symlink.

**Reproduce/retest:** Confirm the VS Code process inherits `VSCODE_PORTABLE`, launch from both `code` and Finder/Dock, and verify state changes under `$XDG_DATA_HOME/vscode/shared-data` while `~/.vscode-shared` remains absent. Retest after VS Code upgrades.

**Exit criteria:** VS Code supports an XDG-aware shared-data path or a persistent setting/environment variable that relocates only shared state; then remove portable mode after migrating user data back to the platform-native location.

**References:** `shells/env`, `launchd/set-xdg-environment.sh`, `bootstrap/lib/environment.sh`, installed VS Code `product.json` (`sharedDataFolderName`), and `appSharedDataHome` in the main process bundle.

## KI-2026-07-15-codex-desktop-home-fallback

**Status:** Workaround active.
**Last verified:** 2026-07-15 (ChatGPT/Codex desktop 26.707.72221; bundled Codex CLI 0.144.2).
**Area:** Codex desktop state relocation

**Observed:** With `CODEX_HOME="$XDG_STATE_HOME/codex"` present in the ChatGPT process environment, both the desktop frontend database and bundled app-server use the XDG root. However, every clean desktop restart also recreates `~/.codex/config.toml` containing the same Computer Use `notify` setting already present in the XDG config.

**Likely cause:** The desktop's macOS Computer Use notification bootstrap still writes its notifier configuration through the default `~/.codex` path independently of the main Codex-home resolver.

**Workaround:** Publish the XDG and agent variables at GUI login with `com.mubuntu.xdg-environment`, keep canonical state at `~/.local/state/codex`, and manage the relative compatibility link `~/.codex -> .local/state/codex` so the remaining fallback write reaches the same config.

**Reproduce/retest:** Confirm the ChatGPT process inherits `CODEX_HOME`, inspect its open `codex-dev.db` path, temporarily test without the compatibility link, and restart the app twice. Version 26.707.72221 opens the XDG database but recreates the legacy config on each restart.

**Exit criteria:** A supported ChatGPT/Codex desktop release restarts repeatedly with `CODEX_HOME` set without accessing or creating `~/.codex`; then remove the compatibility link and this entry.

**References:** `launchd/com.mubuntu.xdg-environment.plist`, `launchd/set-xdg-environment.sh`, `shells/env`, and the installed desktop app's `resolveCodexHome` and Computer Use notifier code.

## KI-2026-07-14-cliproxyapi-oauth-file-mode

**Status:** Workaround active.
**Last verified:** 2026-07-15 (CLIProxyAPI 7.2.75 installed by Homebrew; relocated auth directory verified against the running service).
**Area:** CLIProxyAPI OAuth credential storage

**Observed:** `cliproxyapi -codex-login` created its Codex OAuth JSON file with mode `0644` under the private configured auth directory. CLIProxyAPI may also write fallback error logs containing sensitive request metadata or bodies in that directory.

**Likely cause:** CLIProxyAPI creates the file with Go's `os.Create`, so the final mode inherits the caller's usual `022` umask instead of being forced to `0600`.

**Workaround:** YAML `auth-dir` points at the private `0700` directory `~/.local/state/cli-proxy-api`. The shared `cliproxyapi` shell function runs the binary in a subshell with umask `077`; existing OAuth JSON files were corrected to mode `0600`. Treat the entire directory as sensitive.

**Reproduce/retest:** Authenticate a new account with a direct CLIProxyAPI binary invocation under umask `022`, then inspect the resulting file in the configured auth directory with `stat`. Retest without the wrapper after an upstream release changes credential creation.

**Exit criteria:** A supported CLIProxyAPI release creates new OAuth credential files with mode `0600` independently of the caller's umask; then remove the shell wrapper and this entry.

**References:** `ai/cliproxyapi/config.yaml`, `shells/aliases`, upstream `internal/auth/codex/token.go`.

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
