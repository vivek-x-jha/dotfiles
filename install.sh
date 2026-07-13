#!/bin/sh
# Portable one-shot entrypoint. This file intentionally stays POSIX sh so it can
# be executed with: curl -fsSL <raw-url>/install.sh | sh
set -u

DOTFILES_REPO=${DOTFILES_REPO:-https://github.com/vivek-x-jha/dotfiles.git}
DOTFILES_DIR=${DOTFILES_DIR:-"$HOME/.dotfiles"}
DOTFILES_DEPTH=${DOTFILES_DEPTH:-10}
DOTFILES_BRANCH=${DOTFILES_BRANCH:-main}
DOTFILES_RETRY_ATTEMPTS=${DOTFILES_RETRY_ATTEMPTS:-3}
DOTFILES_RETRY_DELAY=${DOTFILES_RETRY_DELAY:-3}

info() { printf '[dotfiles] %s\n' "$*"; }
fail() {
  printf '[dotfiles] ERROR: %s\n' "$*" >&2
  exit 1
}
retry() {
  retry_attempt=1
  retry_wait=$DOTFILES_RETRY_DELAY
  while [ "$retry_attempt" -le "$DOTFILES_RETRY_ATTEMPTS" ]; do
    "$@" && return 0
    if [ "$retry_attempt" -lt "$DOTFILES_RETRY_ATTEMPTS" ]; then
      info "Attempt $retry_attempt/$DOTFILES_RETRY_ATTEMPTS failed; retrying in ${retry_wait}s"
      sleep "$retry_wait"
      retry_wait=$((retry_wait * 2))
    fi
    retry_attempt=$((retry_attempt + 1))
  done
  return 1
}
clone_checkout() {
  git clone --depth "$DOTFILES_DEPTH" --branch "$DOTFILES_BRANCH" --single-branch \
    "$DOTFILES_REPO" "$DOTFILES_DIR" && return 0
  rm -rf "$DOTFILES_DIR"
  return 1
}

case "$DOTFILES_DEPTH" in
  ''|*[!0-9]*) fail "DOTFILES_DEPTH must be a positive integer" ;;
  0) fail "DOTFILES_DEPTH must be greater than zero" ;;
esac
case "$DOTFILES_RETRY_ATTEMPTS" in
  ''|*[!0-9]*) fail "DOTFILES_RETRY_ATTEMPTS must be a positive integer" ;;
esac
case "$DOTFILES_RETRY_DELAY" in
  ''|*[!0-9]*) fail "DOTFILES_RETRY_DELAY must be a non-negative integer" ;;
esac
[ "$DOTFILES_RETRY_ATTEMPTS" -gt 0 ] || fail "DOTFILES_RETRY_ATTEMPTS must be greater than zero"

if ! command -v git >/dev/null 2>&1; then
  fail "git is required. On macOS, run 'xcode-select --install', finish the installer, and retry."
fi

if [ "$(uname -s)" = Darwin ] && command -v xcode-select >/dev/null 2>&1; then
  if ! xcode-select -p >/dev/null 2>&1; then
    fail "Apple Command Line Tools are not installed. Run 'xcode-select --install', finish the installer, and retry."
  fi
fi

if [ -e "$DOTFILES_DIR" ] && [ ! -d "$DOTFILES_DIR/.git" ]; then
  fail "$DOTFILES_DIR already exists but is not a Git checkout; move it aside or set DOTFILES_DIR."
fi

if [ ! -d "$DOTFILES_DIR/.git" ]; then
  parent=$(dirname "$DOTFILES_DIR")
  mkdir -p "$parent" || fail "unable to create $parent"
  info "Cloning $DOTFILES_REPO to $DOTFILES_DIR (branch $DOTFILES_BRANCH, last $DOTFILES_DEPTH commits)"
  retry clone_checkout || fail "clone failed after $DOTFILES_RETRY_ATTEMPTS attempts"
else
  info "Using existing checkout at $DOTFILES_DIR"
  if [ -z "$(git -C "$DOTFILES_DIR" status --porcelain 2>/dev/null)" ]; then
    current_branch=$(git -C "$DOTFILES_DIR" symbolic-ref --quiet --short HEAD 2>/dev/null || printf '')
    if [ "$current_branch" = "$DOTFILES_BRANCH" ]; then
      info "Updating existing clean checkout with a fast-forward only"
      if ! retry git -C "$DOTFILES_DIR" pull --ff-only; then
        info "Update was not possible; preserving the checkout and continuing with its current revision"
      fi
    else
      info "Checkout is on '${current_branch:-detached HEAD}'; leaving its revision unchanged"
    fi
  else
    info "Checkout has local changes; preserving them and skipping update"
  fi
fi

[ -f "$DOTFILES_DIR/bootstrap.sh" ] || fail "bootstrap.sh is missing from $DOTFILES_DIR"
if [ "${DOTFILES_CLONE_ONLY:-0}" = 1 ]; then
  info "Clone-only mode complete"
  exit 0
fi

info "Starting bootstrap"
if ( : </dev/tty ) 2>/dev/null; then
  exec /bin/bash "$DOTFILES_DIR/bootstrap.sh" "$@" </dev/tty
fi
exec /bin/bash "$DOTFILES_DIR/bootstrap.sh" "$@"
