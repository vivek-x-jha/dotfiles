#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: build-clean-latex.sh <subject/src/file.tex>" >&2
  exit 2
fi

tex="$1"
if [[ ! -f "$tex" ]]; then
  echo "missing tex file: $tex" >&2
  exit 2
fi

case "$tex" in
  */src/*.tex) ;;
  *)
    echo "expected path like <subject>/src/<file>.tex: $tex" >&2
    exit 2
    ;;
esac

subject="${tex%%/src/*}"
base="$(basename "$tex" .tex)"
build_dir="$subject/build"

mkdir -p "$build_dir"
latexmk -pdf -f -output-directory="$build_dir" "$tex"
latexmk -c -output-directory="$build_dir" "$tex"

rm -f \
  "$build_dir/$base.aux" \
  "$build_dir/$base.log" \
  "$build_dir/$base.fls" \
  "$build_dir/$base.fdb_latexmk" \
  "$build_dir/$base.synctex.gz" \
  "$build_dir/$base.out" \
  "$build_dir/$base.toc"

pdf="$build_dir/$base.pdf"
if [[ ! -f "$pdf" ]]; then
  echo "expected PDF was not produced: $pdf" >&2
  exit 1
fi

printf '%s\n' "$pdf"
