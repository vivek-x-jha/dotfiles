# shellcheck shell=bash

_dotfiles_load_completions() {
  local prefix=${HOMEBREW_PREFIX:-/opt/homebrew} cmp command

  # Use an installed framework when available; no extra package is required.
  for cmp in "$prefix/etc/profile.d/bash_completion.sh" /usr/share/bash-completion/bash_completion; do
    [[ -r $cmp ]] || continue
    # shellcheck disable=SC1090
    source "$cmp"
    break
  done

  # Git also supplies a word parser when bash-completion is not installed.
  for cmp in "$prefix/etc/bash_completion.d/git-completion.bash" \
    /usr/share/bash-completion/completions/git /usr/share/git/completion/git-completion.bash; do
    [[ -r $cmp ]] || continue
    # shellcheck disable=SC1090
    source "$cmp"
    break
  done
  # shellcheck disable=SC1091
  source "$SHELL_CONFIG/bash/comps/_cmp-compat.bash"

  for command in atuin bat bob dust fd rg starship tldr uv; do
    for cmp in "$prefix/etc/bash_completion.d/$command" \
      "$prefix/share/bash-completion/completions/$command" \
      "/usr/share/bash-completion/completions/$command"; do
      [[ -r $cmp ]] || continue
      # shellcheck disable=SC1090
      source "$cmp"
      break
    done
  done

  for cmp in "$SHELL_CONFIG"/bash/comps/*.bash; do
    [[ $cmp == */_cmp-compat.bash ]] && continue
    # shellcheck disable=SC1090
    source "$cmp"
  done
}

_dotfiles_load_completions
unset -f _dotfiles_load_completions
