# Atuin selected-only syntax highlighting

`patches/selected-only-syntax-v18.24.1.patch` targets Atuin **18.24.1**, commit
`c58d2e993d05be423315f6ae3739e9ab3e45eea5` from `atuinsh/atuin`.

With `[ui] syntax_highlight = true`, the patched binary:

- Renders unselected command text with the theme's muted `Base` color.
- Applies the existing `Syntax*` colors only to the selected command.
- Bolds query matches without replacing their syntax colors.
- Leaves duration/time/status columns and alternate reverse highlighting alone.

Plain arguments, unsupported shells, and platforms without a syntax grammar retain
`Base`, as in upstream. Setting `syntax_highlight = false` keeps upstream's
single-color selection behavior.

## Build and try without installing

Requires Git and an installed Rust stable toolchain compatible with Atuin 18.24.1
(Rust 1.98 or newer). Cargo may download build dependencies. This patch changes
only rendering, not history storage or sync.

```sh
(
  set -eu
  patch_file="$HOME/.dotfiles/cli/atuin/patches/selected-only-syntax-v18.24.1.patch"
  workdir="$(mktemp -d "${TMPDIR:-/tmp}/atuin-selected-syntax.XXXXXX")"
  git clone --depth 1 --branch v18.24.1 https://github.com/atuinsh/atuin.git "$workdir/atuin"
  cd "$workdir/atuin"
  test "$(git rev-parse HEAD)" = c58d2e993d05be423315f6ae3739e9ab3e45eea5
  git apply --check "$patch_file"
  git apply "$patch_file"
  cargo +stable test --locked --release -p atuin --bin atuin history_list::tests
  cargo +stable build --locked --release -p atuin
  printf 'Patched binary: %s/target/release/atuin\n' "$PWD"
  ATUIN_UI__SYNTAX_HIGHLIGHT=true ./target/release/atuin search --interactive
)
```

The environment override enables selected-only syntax for that invocation without
changing the managed config. This build-and-try procedure does not install or
replace a binary.

The patch includes 48 renderer test cases covering selection changes, normal and
inverted layouts, query matches, syntax disabled, and alternate highlighting.
Verify visually that moving selection colors only the focused command and leaves
the other commands muted.

## Installed user override

The patched release binary is installed at `~/.local/bin/atuin`, ahead of Homebrew
in the managed PATH. `config.toml` enables `[ui] syntax_highlight = true` for it.
The Homebrew executable and running daemon are left intact. Existing shells may
need `rehash` (Zsh) or `hash -r` (Bash) before reopening the picker.

The build checkout and logs live under
`${XDG_CACHE_HOME:-$HOME/.cache}/atuin-selected-syntax/`; the installed binary is a
copy, so clearing that cache does not remove it. Homebrew upgrades do **not**
update this override. Rebuild/reinstall the patch when upgrading Atuin, or disable
the override to use the stock binary. Bootstrap still installs stock Atuin; a
fresh machine needs this custom build to reproduce selected-only syntax colors.

To roll back, first set `[ui] syntax_highlight = false` in `config.toml`, then move
`~/.local/bin/atuin` out of the way (for example, to `atuin-selected-syntax.disabled`
in the same directory). Refresh the shell command cache and reopen the picker.
This restores Homebrew without deleting either binary or touching history data.

Recheck the patch against each upstream upgrade; do not force failed hunks.
Reverse it in the source checkout with
`git apply --reverse "$HOME/.dotfiles/cli/atuin/patches/selected-only-syntax-v18.24.1.patch"`.
