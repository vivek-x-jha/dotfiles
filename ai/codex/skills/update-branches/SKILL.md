---
name: "update-branches"
description: "Run a validated git flow: inspect status and diff, run checks, stage logical changes, commit with commitizen-style messages, merge behind existing branches with the default branch, push updated branches, and leave the repo on the default branch."
metadata:
  short-description: "Run validated git flow"
---

# Update Branches

Use this skill when the user asks to run git flow, update branches, or otherwise wants the repo validated, committed, merged, and pushed.
Prefer a lower-cost model for straightforward runs with small diffs and clear commit boundaries. Use a stronger model only when the diff is subtle, the branch state is messy, or hunk-level staging needs extra judgment.

This skill cannot switch the active model mid-run on its own. If a different model is needed, the caller or orchestrator must start the run with that model or delegate the work to a separate agent.

## Workflow

1. Inspect `git status --short --branch`, the current diff, branch tracking state, and the default branch.
   Prefer `origin/HEAD` for the default branch; fall back to the current branch when no remote default is configured.
2. Run lightweight baseline validation:
   - Always run `git diff --check`.
   - Run targeted checks only for files changed in the staged commit set.
   - Run `./bootstrap.sh --check` only when bootstrap behavior, shell files, manifests, setup-managed config, or other repo-wide setup contracts changed, or when the user explicitly asks for full validation.
   - For simple docs, theme fragments, lockfiles, generated metadata, or other low-risk data-only changes, prefer git commands plus the smallest relevant smoke check over full bootstrap validation.
3. Stage logical parts and commit with commitizen-style messages.
   In an active chat, stage only changes made in the current chat or explicitly approved by the user for inclusion. Treat pre-existing dirty worktree changes as user-owned and leave them unstaged unless the user explicitly asks to include all local changes.
   Use `git add -p` when the diff naturally splits into separate logical hunks.
4. Push the default branch if it gained commits.
5. Identify existing local branches, their upstreams, and any already-tracked remote branches that are behind the default branch.
   Do not create a branch just because a conventional name such as `dev` does not exist.
6. For each existing behind branch that should be kept current, switch to it, merge the default branch, fix merge conflicts when the resolution is clear, rerun relevant checks, and commit merge resolutions if needed.
   Prefer `git merge --ff-only <default-branch>` when possible. If a non-fast-forward merge is needed, use a normal merge. If conflict resolution is ambiguous, interrupt the tool call and ask the user how to proceed.
7. Push every branch changed by this workflow.
8. Switch back to the default branch and confirm the expected local and remote refs match.

## Constraints

- Do not include `manifests/Brewfile` unless the package change is intentional.
- In active chat sessions, commit only chat-scoped or explicitly approved changes; do not sweep unrelated pre-existing dirty worktree changes into the update flow.
- Do not assume branch names such as `main`, `master`, or `dev`; discover the default branch and only update branches that already exist.
- Do not create missing integration branches or local tracking branches solely to update a remote branch.
- Keep the repo clean at the end.
- If a check fails, fix it before proceeding.
