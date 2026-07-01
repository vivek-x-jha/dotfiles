# Known Issues

## tmux 3.7/3.7a blank pane rendering in WezTerm

**Status:** Workaround active; tmux is pinned to `3.6b` locally.

**Observed:** In WezTerm on macOS, tmux panes running heavy TUIs such as pi chats or Neovim could render blank or mostly blank. The pane content was still functional and appeared after hover/click/scroll or other external repaint events. The same pi and Neovim sessions rendered normally outside tmux.

**Likely cause:** tmux 3.7 introduced DECSET 2026 synchronized-output handling. The failure reproduced with tmux `3.7a` and disappeared after downgrading to `3.6b`, so treat this as a tmux 3.7/3.7a + WezTerm repaint/synchronized-output regression until retested.

**Current workaround:**

```sh
brew list --pinned | grep '^tmux@3\.6b$'
tmux -V  # expected: tmux 3.6b
```

`update-tools --brew` runs `brew upgrade --formula`, which respects the `tmux@3.6b` pin. Avoid explicitly reinstalling unversioned `tmux` or running `brew bundle` from a Brewfile that contains `brew "tmux"` unless intentionally retesting.

**Retest when upstream appears fixed:**

```sh
brew unpin tmux@3.6b
brew unlink tmux@3.6b
brew install tmux
tmux kill-server 2>/dev/null || true
tmux -V
work -r
```

Then test pi chats and Neovim inside tmux/WezTerm. If fixed, remove the local `tmux@3.6b` formula/tap and update this note. If still broken, return to the pinned version:

```sh
brew unlink tmux
brew link --force --overwrite tmux@3.6b
brew pin tmux@3.6b
tmux kill-server 2>/dev/null || true
work -r
```
