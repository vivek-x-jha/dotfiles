#!/usr/bin/env bash
# Shared fzf/fzf-lua previewer. Renders directories with eza/ls, text files with
# bat/cat, and binary files with file(1) metadata to avoid bat binary warnings.

set -u

target=${1:-}
[[ -n $target ]] || exit 0

if [[ -d $target ]]; then
  # Match `t`: render the selected directory as `.` instead of printing the
  # absolute path as the tree root in fzf, Ctrl-T, and fzf-lua previews.
  if command -v eza &>/dev/null; then
    (
      cd -- "$target" || exit
      eza \
        --all \
        --long \
        --git \
        --tree \
        --level=3 \
        --color=always \
        --icons=always \
        --group-directories-first \
        --ignore-glob='.git|.github|.venv|__pycache__' \
        -- .
    )
  else
    (
      cd -- "$target" || exit
      ls -lAh -- .
    )
  fi
  exit 0
fi

[[ -f $target ]] || exit 0

if command -v file &>/dev/null; then
  mime=$(file --mime --brief -- "$target" 2>/dev/null || true)
  if [[ $mime == *charset=binary* ]]; then
    file -- "$target"
    exit 0
  fi
fi

if command -v bat &>/dev/null; then
  bat --color=always --style=changes -- "$target"
else
  cat -- "$target"
fi
