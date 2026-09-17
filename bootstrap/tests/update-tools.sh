#!/usr/bin/env bash
# shellcheck disable=SC1091
set -eo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FIXTURE="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-update-tools.XXXXXX")"
trap 'rm -rf "$FIXTURE"' EXIT

export HOME="$FIXTURE/home"
export DOTFILES_DIR="$FIXTURE/repo"
export GIT_CONFIG_GLOBAL=/dev/null
export GIT_CONFIG_NOSYSTEM=1
export GIT_AUTHOR_NAME='Update Tools Test'
export GIT_AUTHOR_EMAIL='update-tools@example.invalid'
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
mkdir -p "$HOME" "$FIXTURE/bin"

REMOTE="$FIXTURE/remote.git"
git init --bare -q "$REMOTE"
git init -q -b main "$DOTFILES_DIR"
git -C "$DOTFILES_DIR" config commit.gpgsign false
git -C "$DOTFILES_DIR" config core.hooksPath "$FIXTURE/hooks"
mkdir -p \
  "$DOTFILES_DIR/editors/nvim" \
  "$DOTFILES_DIR/shells/bash/comps" \
  "$DOTFILES_DIR/shells/zsh/comps"
printf '{"plugin":"old"}\n' >"$DOTFILES_DIR/editors/nvim/nvim-pack-lock.json"
printf 'old bash completion\n' >"$DOTFILES_DIR/shells/bash/comps/uv.bash"
printf 'old zsh completion\n' >"$DOTFILES_DIR/shells/zsh/comps/_uv"
printf 'original note\n' >"$DOTFILES_DIR/notes.txt"
git -C "$DOTFILES_DIR" add .
git -C "$DOTFILES_DIR" commit -qm 'test: initial state'
git -C "$DOTFILES_DIR" remote add origin "$REMOTE"
git -C "$DOTFILES_DIR" push -qu origin main

cat >"$FIXTURE/bin/nvim" <<'EOF'
#!/usr/bin/env bash
printf '{"plugin":"generated"}\n' >"$DOTFILES_DIR/editors/nvim/nvim-pack-lock.json"
EOF
cat >"$FIXTURE/bin/uv" <<'EOF'
#!/usr/bin/env bash
case "$*" in
  'generate-shell-completion bash') printf 'complete -W test uv\n' ;;
  'generate-shell-completion zsh') printf '#compdef uv\n_arguments "*: :"\n' ;;
  *) exit 1 ;;
esac
EOF
chmod +x "$FIXTURE/bin/nvim" "$FIXTURE/bin/uv"
export PATH="$FIXTURE/bin:/usr/bin:/bin"

source "$ROOT/shells/bash/funcs/update-tools"

update-tools --nvim --completions >"$FIXTURE/clean.log"
[[ $(git -C "$DOTFILES_DIR" log -1 --format=%s) == 'chore(comps): update shell completions' ]]
[[ $(git -C "$DOTFILES_DIR" log -2 --format=%s | tail -1) == 'chore(nvim): update plugin lockfile' ]]
[[ $(git -C "$DOTFILES_DIR" rev-parse HEAD) == $(git --git-dir="$REMOTE" rev-parse main) ]]
[[ -z $(git -C "$DOTFILES_DIR" status --porcelain) ]]

commit_count=$(git -C "$DOTFILES_DIR" rev-list --count HEAD)
printf '{"plugin":"user change"}\n' >"$DOTFILES_DIR/editors/nvim/nvim-pack-lock.json"
printf 'staged note\n' >"$DOTFILES_DIR/notes.txt"
git -C "$DOTFILES_DIR" add notes.txt
printf 'untracked work\n' >"$DOTFILES_DIR/scratch.txt"

update-tools --nvim --completions >"$FIXTURE/dirty.log"
[[ $(git -C "$DOTFILES_DIR" rev-list --count HEAD) == "$commit_count" ]]
[[ $(<"$DOTFILES_DIR/editors/nvim/nvim-pack-lock.json") == '{"plugin":"user change"}' ]]
[[ $(<"$DOTFILES_DIR/notes.txt") == 'staged note' ]]
[[ $(git -C "$DOTFILES_DIR" diff --cached --name-only) == notes.txt ]]
[[ -f "$DOTFILES_DIR/scratch.txt" ]]
[[ -z $(git -C "$DOTFILES_DIR" stash list) ]]
grep -q 'NEOVIM PLUGIN LOCKFILE HAD CHANGES BEFORE UPDATE; SKIPPING AUTOMATIC COMMIT' "$FIXTURE/dirty.log"

printf 'ok: update-tools commits generated files and restores existing work\n'
