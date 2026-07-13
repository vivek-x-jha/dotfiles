#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FIXTURE="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-install-test.XXXXXX")"
SOURCE="$FIXTURE/source"
DEST="$FIXTURE/home/.dotfiles"
trap 'rm -rf "$FIXTURE"' EXIT

mkdir -p "$SOURCE" "$FIXTURE/home"
git -C "$SOURCE" init -q
git -C "$SOURCE" checkout -q -b main
git -C "$SOURCE" config user.name 'Bootstrap Test'
git -C "$SOURCE" config user.email bootstrap@example.invalid
git -C "$SOURCE" config commit.gpgsign false
printf '#!/usr/bin/env bash\nexit 0\n' >"$SOURCE/bootstrap.sh"
chmod +x "$SOURCE/bootstrap.sh"
for number in $(seq 1 15); do
  printf '%s\n' "$number" >"$SOURCE/revision"
  git -C "$SOURCE" add bootstrap.sh revision
  git -C "$SOURCE" commit -qm "test revision $number"
done

REAL_GIT="$(command -v git)"
mkdir -p "$FIXTURE/fake-bin"
cat >"$FIXTURE/fake-bin/git" <<EOF
#!/bin/sh
if [ "\${1:-}" = clone ] && [ ! -e "$FIXTURE/retry-observed" ]; then
  : >"$FIXTURE/retry-observed"
  exit 75
fi
exec "$REAL_GIT" "\$@"
EOF
chmod +x "$FIXTURE/fake-bin/git"

PATH="$FIXTURE/fake-bin:$PATH" \
DOTFILES_REPO="file://$SOURCE" \
DOTFILES_DIR="$DEST" \
DOTFILES_DEPTH=10 \
DOTFILES_RETRY_DELAY=0 \
DOTFILES_CLONE_ONLY=1 \
  sh "$ROOT/install.sh" >"$FIXTURE/clone.log" 2>&1

[[ -f $FIXTURE/retry-observed ]]
grep -q 'Attempt 1/3 failed' "$FIXTURE/clone.log"
[[ $(git -C "$DEST" rev-list --count HEAD) == 10 ]]
[[ -f $DEST/.git/shallow ]]

printf 'local change\n' >>"$DEST/revision"
DOTFILES_REPO="file://$SOURCE" \
DOTFILES_DIR="$DEST" \
DOTFILES_DEPTH=10 \
DOTFILES_CLONE_ONLY=1 \
  sh "$ROOT/install.sh" >"$FIXTURE/reuse.log" 2>&1

grep -q 'local change' "$DEST/revision"
grep -q 'local changes; preserving them' "$FIXTURE/reuse.log"

mkdir -p "$FIXTURE/non-repository"
printf 'preserve\n' >"$FIXTURE/non-repository/local.txt"
if DOTFILES_REPO="file://$SOURCE" \
  DOTFILES_DIR="$FIXTURE/non-repository" \
  DOTFILES_CLONE_ONLY=1 \
  sh "$ROOT/install.sh" >"$FIXTURE/nonrepo.log" 2>&1; then
  printf 'installer unexpectedly replaced a non-repository destination\n' >&2
  exit 1
fi
grep -q preserve "$FIXTURE/non-repository/local.txt"
grep -q 'already exists but is not a Git checkout' "$FIXTURE/nonrepo.log"

printf 'ok: shallow clone and non-destructive existing checkout reuse\n'
