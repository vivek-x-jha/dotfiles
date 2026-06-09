#!/usr/bin/env zsh

# Patch Atuin's outside-tmux zsh search capture path.
#
# Atuin's generated zsh helper captures the selected command by running
# `atuin search -i` in command substitution with swapped stdout/stderr. In this
# terminal setup that path can fail to return Tab/Enter selections. The tmux
# popup path already avoids that by writing the selected command to a temp file,
# so use the same capture model outside tmux.

[[ -n ${functions[__atuin_search_cmd]:-} ]] || return 0
[[ -n ${functions[__atuin_search_cmd_original]:-} ]] ||
  functions -c __atuin_search_cmd __atuin_search_cmd_original

__atuin_search_cmd() {
  [[ -n ${TMUX-} ]] && {
    __atuin_search_cmd_original "$@"
    return
  }

  local result_file
  result_file=$(mktemp) || return 1

  {
    ATUIN_SHELL=zsh ATUIN_LOG=error ATUIN_QUERY=$BUFFER \
      atuin search "$@" -i </dev/tty >/dev/tty 2>"$result_file"
    [[ -f $result_file ]] && cat "$result_file"
  } always {
    rm -f "$result_file"
  }
}
