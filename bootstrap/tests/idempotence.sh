#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FIXTURE="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-bootstrap-test.XXXXXX")"
LOG_ONE="$FIXTURE/first.log"
LOG_TWO="$FIXTURE/second.log"
trap 'rm -rf "$FIXTURE"' EXIT

mkdir -p "$FIXTURE/home/.config/nvim"
printf 'preserve bashrc\n' >"$FIXTURE/home/.bashrc"
printf 'preserve nvim\n' >"$FIXTURE/home/.config/nvim/local.txt"
ln -s "$ROOT/auth/git" "$FIXTURE/home/.config/git"
mkdir -p "$FIXTURE/home/.config/ssh"
printf 'Include %s\nHost example.invalid\n  User preserve-me\n' \
  "$ROOT/auth/ssh/identities/1password" >"$FIXTURE/home/.config/ssh/config"

run_fixture() {
  env -u XDG_CONFIG_HOME -u XDG_CACHE_HOME -u XDG_DATA_HOME -u XDG_STATE_HOME \
    HOME="$FIXTURE/home" USER=bootstrap-test \
    "$ROOT/bootstrap.sh" --partial --only symlinks >"$1" 2>&1
}

run_fixture "$LOG_ONE"
run_fixture "$LOG_TWO"

mkdir -p "$FIXTURE/clean-home"
env -u XDG_CONFIG_HOME -u XDG_CACHE_HOME -u XDG_DATA_HOME -u XDG_STATE_HOME \
  HOME="$FIXTURE/clean-home" USER=bootstrap-test \
  "$ROOT/bootstrap.sh" --fresh --dry-run >"$FIXTURE/clean-dry-run.log" 2>&1
grep -q 'BOOTSTRAP COMPLETE' "$FIXTURE/clean-dry-run.log"
if grep -q '\[ERROR\]' "$FIXTURE/clean-dry-run.log"; then
  printf 'clean dry-run reported an error\n' >&2
  exit 1
fi

[[ $(readlink "$FIXTURE/home/.bashrc") == "$ROOT/shells/bash/.bashrc" ]]
[[ $(readlink "$FIXTURE/home/.config/nvim") == "$ROOT/editors/nvim" ]]
[[ -d $FIXTURE/home/.config/git && ! -L $FIXTURE/home/.config/git ]]
[[ -d $FIXTURE/home/.config/ssh && ! -L $FIXTURE/home/.config/ssh ]]
[[ -f $FIXTURE/home/.config/ssh/config && ! -L $FIXTURE/home/.config/ssh/config ]]
grep -Fxq "Include \"$ROOT/auth/ssh/base\"" "$FIXTURE/home/.config/ssh/config"
grep -q 'User preserve-me' "$FIXTURE/home/.config/ssh/config"
[[ $(readlink "$FIXTURE/home/.config/ssh/identity.conf") == "$ROOT/auth/ssh/identities/1password" ]]
[[ $(readlink "$FIXTURE/home/.config/git/themes/sourdiesel") == "$ROOT/auth/git/themes/sourdiesel" ]]
grep -Fxq "$ROOT/auth/git/base" < <(git config --file "$FIXTURE/home/.config/git/config" --get-all include.path)
[[ $(git config --file "$FIXTURE/home/.config/git/config" user.name) == 'Vivek Jha' ]]
[[ $(git config --file "$FIXTURE/home/.config/git/config" commit.gpgsign) == true ]]
grep -Fxq "$ROOT" "$FIXTURE/home/.local/state/dotfiles/root"

find "$FIXTURE/home/.local/state/dotfiles/backups" -type f -path '*/.bashrc' \
  -exec grep -q 'preserve bashrc' {} \;
find "$FIXTURE/home/.local/state/dotfiles/backups" -type f -path '*/.config/nvim/local.txt' \
  -exec grep -q 'preserve nvim' {} \;

if grep -q 'Preserved existing' "$LOG_TWO"; then
  printf 'second bootstrap run created unexpected conflict backups\n' >&2
  exit 1
fi

printf 'ok: clean, conflicting, and repeated symlink setup\n'
