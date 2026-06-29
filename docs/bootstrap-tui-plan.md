# Bootstrap TUI Consolidation Plan

## Goal

Replace the current linear “big check/run everything” bootstrap experience with a small task backend and a TUI front-end. Each setup area should be independently discoverable, testable, idempotent, and skippable when already healthy.

Core philosophy:

1. **Actions are idempotent.** Running a task repeatedly should converge to the same configured state.
2. **Health checks are first-class.** If `fzf` is already installed, dotfiles are linked, and the backend test passes, the TUI marks that task as `Done` and does not run it by default.
3. **Apply only what is needed.** Failed, missing, or stale tasks are selected by default; healthy tasks are opt-in reruns.
4. **Dry-run and CLI stay supported.** The TUI should be a better interface over the same backend, not the only way to bootstrap.
5. **Secrets and privileged actions stay gated.** 1Password, sudo, shell changes, macOS defaults, and auth setup must remain explicit.

## Proposed User Experience

Add a new mode:

```sh
./bootstrap.sh --tui
# or later: ./bootstrap tui
```

Initial screen:

```text
Dotfiles Bootstrap

Status   Task                  Summary
Done     fzf                   fzf installed; shell integration test passed
Done     symlinks              XDG/home symlinks match repo
Needed   packages              12 Homebrew formulae missing
Needed   git                   git identity missing
Skipped  atuin sync            disabled; requires 1Password
Risky    sudo touch id          privileged; opt-in only

[Space] select  [Enter] apply selected  [d] details  [r] retest  [q] quit
```

Default selection behavior:

- `Done`: not selected
- `Needed` / `Failed`: selected
- `Skipped`: not selected
- `Risky` / `Secret`: not selected unless explicitly enabled
- `Unknown`: selected only if the task is part of the selected profile

## Architecture

### 1. Introduce task descriptors

Create a central task registry, for example `bootstrap/lib/tasks.sh`, where each target has metadata:

```sh
BOOTSTRAP_TASKS=(
  packages
  fzf
  gh
  glow
  environment
  symlinks
  codex
  os
  git
  repos
  templates
  shell_plugins
  atuin
  bat
  sudo_auth
  shell
  hammerspoon
  rust
  cia
  ide
)
```

For each task define:

- `label`
- `category`
- `risk`: `safe`, `network`, `secret`, `privileged`, `destructive-ish`
- `default_profile`: `fresh`, `partial`, `optional`
- `dependencies`
- `check_fn`
- `apply_fn`
- `test_fn` or backend acceptance check
- `config_var`, preserving current `BOOTSTRAP_*` variables

### 2. Split every task into `check`, `apply`, and `test`

Each bootstrap target should become a small contract:

```sh
bootstrap_task_fzf_check   # read-only state discovery
bootstrap_task_fzf_apply   # idempotent changes only
bootstrap_task_fzf_test    # backend acceptance test
```

Example for `fzf`:

- Check:
  - `command -v fzf`
  - expected shell integration source exists
  - expected dotfile symlink/source path exists
- Apply:
  - install only if missing
  - refresh config only if target differs
- Test:
  - `fzf --version`
  - non-interactive shell load smoke test for the fzf integration

If check + test pass, TUI shows `Done` and apply is skipped.

### 3. Replace monolithic doctor with targeted health checks

Keep `./bootstrap.sh --doctor`, but make it aggregate task checks instead of carrying one large hard-coded checklist. This avoids agents/users repeatedly stepping through unrelated checks.

New modes:

```sh
./bootstrap.sh --status              # all task statuses, read-only
./bootstrap.sh --status --only fzf
./bootstrap.sh --test --only fzf     # backend acceptance tests only
./bootstrap.sh --apply --only fzf    # apply selected task, then test
```

Existing compatibility:

- `--check` remains repo/syntax validation.
- `--doctor` becomes installed-state validation via the registry.
- `--only`, `--skip`, `--dry-run`, `--with-1password` continue to work.

### 4. Build TUI as a thin frontend

Prefer a graceful dependency ladder:

1. `fzf` multi-select UI when available.
2. `gum`/`whiptail` later if desired.
3. Plain Bash numbered menu fallback for fresh machines where `fzf` is not installed yet.

Important: because `fzf` itself is one bootstrap task, the TUI must not require `fzf` to start.

### 5. Persist local choices and task state carefully

Use config for preferences, not truth:

- `$XDG_CONFIG_HOME/dotfiles/bootstrap.env`: user-selected defaults.
- `$XDG_STATE_HOME/dotfiles/bootstrap/status.tsv` or JSON: last observed statuses, timestamps, and test output summaries.

The source of truth is always live checks, not cached status. Cache is only for UI speed/history.

### 6. Make task output agent-friendly

Add machine-readable output:

```sh
./bootstrap.sh --status --json
./bootstrap.sh --apply --only fzf --json
```

This lets agents inspect the exact failing backend test instead of running the entire bootstrap/doctor path.

## Migration Phases

### Phase 1: Registry skeleton

- Add task registry mapping current target names to existing functions.
- Preserve current `main` flow by iterating registry in the same order.
- No behavior change beyond centralizing metadata.

### Phase 2: Checks for high-value tasks

Add `check/test` contracts for the tasks that cause the most repeated work:

1. `fzf`
2. `symlinks`
3. `git`
4. `codex`
5. `shell_plugins`
6. `bat`
7. `ide`
8. package manager/package manifests

### Phase 3: Status/apply CLI

Implement:

- `--status`
- `--test`
- `--apply`
- `--json`

At this point agents can run targeted status/tests instead of `--doctor`.

### Phase 4: TUI MVP

- Add `--tui`.
- Show statuses.
- Allow select/retest/details/apply.
- Default-select only needed tasks.
- Require confirmation for `secret` and `privileged` tasks.

### Phase 5: Convert doctor

Refactor `doctor_bootstrap` to call registry checks/tests. Keep any repo-wide checks in `--check`.

### Phase 6: Documentation cleanup

Update:

- `README.md` Bootstrap Flow and Validation sections.
- `AGENTS.md` checks to recommend targeted `--status/--test --only <task>` before full doctor.
- Any setup docs that currently instruct users to run the whole bootstrap repeatedly.

## Task Status Model

Suggested statuses:

- `done`: check and test pass.
- `needed`: missing or stale; safe to apply.
- `failed`: test failed after apply or check found broken state.
- `skipped`: disabled by config/profile.
- `blocked`: dependency missing or platform unsupported.
- `risk`: requires sudo, secrets, auth, shell change, or destructive migration.
- `unknown`: check not implemented yet.

## Acceptance Criteria

- A healthy configured machine can open the TUI and see most tasks as `Done` without running apply steps.
- `./bootstrap.sh --status --only fzf` is read-only and fast.
- `./bootstrap.sh --apply --only fzf` installs/configures only fzf, then runs its backend test.
- `--doctor` no longer duplicates a giant independent checklist; it reports task health from the same backend.
- Fresh machines still work without `fzf` installed.
- Existing non-interactive bootstrap behavior remains available for automation.
