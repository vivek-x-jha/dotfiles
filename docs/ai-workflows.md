# AI Workflows

Use this file as a prompt playbook for Codex, Claude, or another coding agent while working in this repo. The names below are slash-command style labels. They are not shell commands unless an AI client lets you register custom slash commands; otherwise paste the label and prompt text into the agent.

## How To Use

1. Open an AI coding session in `~/.dotfiles`.
2. Paste one workflow prompt from this file.
3. Let the agent run the listed checks.
4. For changes, require git flow before finishing.

Example:

```text
/sanity
Run the sanity workflow from docs/ai-workflows.md.
```

If your AI client supports custom slash commands, create commands with the same names and use the prompt body from each section.

## /sanity

Goal: prove the repo is healthy before or after a change.

Prompt:

```text
Run repo sanity checks. Use ./bootstrap.sh --check, bash -n bootstrap.sh, and git diff --check. If any check fails, inspect the failure, patch the smallest safe fix, rerun targeted checks, then rerun the full sanity set. Do not commit unless I explicitly ask for git flow.
```

Expected checks:

```sh
./bootstrap.sh --check
bash -n bootstrap.sh
git diff --check
```

## /review

Goal: review the current diff like a pull request.

Prompt:

```text
Review the current git diff as a PR. Lead with findings ordered by severity. Focus on bugs, regressions, stale docs, missing checks, XDG violations, dry-run violations, and bootstrap behavior changes. Include file and line references. If no issues are found, say that clearly and list residual risks.
```

## /git-flow

Goal: validate, commit, fast-forward `dev`, push both branches, and end on `main`.

Prompt:

```text
Run git flow. First inspect git status and current diff. Validate with ./bootstrap.sh --check and git diff --check plus any targeted checks relevant to the changed files. Stage logical parts, commit with commitizen-style messages, switch to dev, merge --ff-only main, push dev, switch back to main, push main, and confirm main/dev/origin refs match. Do not include manifests/Brewfile unless the package change is intentional.
```

Expected final state:

```sh
git status --short --branch
git rev-parse main dev origin/main origin/dev
```

## /bootstrap-change

Goal: change bootstrap behavior safely.

Prompt:

```text
Implement the requested bootstrap change. Keep operations idempotent, preserve --dry-run by routing mutating shell actions through run where practical, keep macOS/Linux branches guarded, and update README.md and AGENTS.md if user-facing behavior changes. Validate with ./bootstrap.sh --check, bash -n bootstrap.sh, and git diff --check. If checks pass, run git flow.
```

Common checks:

```sh
./bootstrap.sh --check
bash -n bootstrap.sh
git diff --check
```

## /nvim-update

Goal: update Neovim plugins and commit the lockfile.

Prompt:

```text
Update Neovim plugins using the repo's vim.pack flow. Run the headless forced update if needed, inspect editors/nvim/nvim-pack-lock.json, verify relevant installed plugin revisions, run ./bootstrap.sh --check and git diff --check, then commit only the lockfile unless config changes are required. Run git flow if checks pass.
```

Useful command:

```sh
nvim --headless '+lua vim.pack.update(nil, { force = true })' '+qa'
```

## /package-sync

Goal: keep package manifests aligned with actual management source.

Prompt:

```text
Compare manifests/Brewfile, apt/dnf manifests, cargo-installed tools, uv tools, and actual command resolution. Identify tools managed by the wrong source, stale package entries, duplicate providers, and missing Linux install paths. Patch only clear fixes, update docs when behavior changes, validate, and run git flow.
```

Useful commands:

```sh
cargo install --list
command -v atuin bat btop eza fd fzf gh glow rg starship tldr uv zoxide
brew bundle check --file "$HOME/.dotfiles/manifests/Brewfile"
```

## /xdg-audit

Goal: find config/state/data files polluting `$HOME` or broken symlinks.

Prompt:

```text
Audit XDG usage. Compare $HOME, $XDG_CONFIG_HOME, $XDG_DATA_HOME, $XDG_STATE_HOME, and $XDG_CACHE_HOME for stale files, broken symlinks, duplicate config roots, and tools that can be moved through env vars, flags, or symlinks. Do not delete anything without explicit approval. Provide commands or patch bootstrap when the fix is safe.
```

Useful commands:

```sh
find "$HOME" -maxdepth 1 -name '.*' -print
find "$XDG_CONFIG_HOME" -xtype l -print
```

## /debug-failure

Goal: debug a failing command or workflow.

Prompt:

```text
Debug this failure. Reproduce it if safe, collect the smallest relevant logs/config, explain the root cause, patch if appropriate, and rerun the failing command plus the nearest sanity checks. If a command fails because of sandbox permissions or network restrictions, rerun it with the required permission request.
```

## Daily Pattern

Use AI as a maintainer loop:

```text
/sanity
/review
/git-flow
```

Use AI as a focused implementer:

```text
/bootstrap-change
/nvim-update
/package-sync
/xdg-audit
```

Keep requests bounded. The best prompt names the target file, expected behavior, validation command, and whether to commit.
