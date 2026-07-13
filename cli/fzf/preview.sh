#!/usr/bin/env bash

set -u

target=${1:-}
[[ -z $target ]] && exit 0

# Handle directories with eva, falling back to ls.
[[ -d $target ]] && {
  if command -v eva &>/dev/null; then
    (
      cd -- "$target" || exit
      eva \
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
}

# Handle files with file metadata for binaries, bat for text, or cat fallback.
[[ -f $target ]] && {
  mime=$(file --mime --brief -- "$target" 2>/dev/null || true)

  if [[ $mime == *charset=binary* ]]; then
    file -- "$target"
  elif command -v bat &>/dev/null; then
    bat --color=always --style=changes -- "$target"
  else
    cat -- "$target"
  fi

  exit 0
}
