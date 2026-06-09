#!/usr/bin/env zsh

# Patch Atuin's non-popup zsh search capture path.
#
# Atuin's generated zsh helper captures the selected command by running
# `atuin search -i` in command substitution with swapped stdout/stderr. In this
# terminal setup that path can fail to return Tab/Enter selections. Use a
# temp-file capture model for non-popup search, including inside tmux when
# ATUIN_TMUX_POPUP=false.
#
# Debug switches:
#   ATUIN_ZSH_TTY_CAPTURE=0       Bypass this patch and use Atuin's original path.
#   ATUIN_ZSH_TTY_CAPTURE_DEBUG=1 Log selected path to
#                                 $XDG_STATE_HOME/atuin/zsh-tty-capture.log.

[[ -n ${functions[__atuin_search_cmd]:-} ]] || return 0
[[ -n ${functions[__atuin_search_cmd_original]:-} ]] ||
  functions -c __atuin_search_cmd __atuin_search_cmd_original

__atuin_zsh_tty_capture_debug() {
  [[ ${ATUIN_ZSH_TTY_CAPTURE_DEBUG:-0} == 1 ]] || return 0

  local log_dir="${XDG_STATE_HOME:-$HOME/.local/state}/atuin"
  mkdir -p "$log_dir" 2>/dev/null || return 0
  print -r -- "$(date '+%Y-%m-%dT%H:%M:%S%z') path=$1 tmux=${TMUX:+1} popup=${ATUIN_TMUX_POPUP:-unset} args=$*" \
    >>"$log_dir/zsh-tty-capture.log"
}

__atuin_search_cmd() {
  __atuin_tmux_popup_check && {
    __atuin_zsh_tty_capture_debug popup "$@"
    __atuin_search_cmd_original "$@"
    return
  }

  [[ ${ATUIN_ZSH_TTY_CAPTURE:-1} == 0 ]] && {
    __atuin_zsh_tty_capture_debug original "$@"
    __atuin_search_cmd_original "$@"
    return
  }

  __atuin_zsh_tty_capture_debug tty "$@"

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
