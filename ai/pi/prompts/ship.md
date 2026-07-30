---
description: Verify, commit, and push the intended changes
argument-hint: "[scope or instructions]"
---
Finish and ship the current work.

Scope or additional instructions: ${ARGUMENTS:-all intended changes from this session}

This `/ship` invocation explicitly authorizes a normal commit and push. Do not force-push, change remotes, bypass protections, or include unrelated user-owned changes.

1. Inspect `git status`, staged and unstaged diffs, and recent history with `git log --oneline -10`.
2. Identify only the intended changes in scope. If intent is ambiguous or unrelated dirty work cannot be separated safely, ask before staging.
3. Run the smallest relevant checks. Fix failures caused by the intended changes; report checks that cannot run.
4. Match the repository's commit-message style, falling back to Conventional Commits when unclear. Split commits only when changes are logically distinct or requested.
5. Commit the intended changes. Do not create an empty commit.
6. Push the current branch to its existing upstream.
7. Report the commit hash and message, checks run, and push result.
