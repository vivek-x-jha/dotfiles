# shellcheck shell=bash

# Restore editor panes and give new plain panes an initial manual label.
# This runs once at shell startup; existing pane labels remain user-controlled.
[[ ${HERDR_ENV:-} == 1 && -n ${HERDR_PANE_ID:-} ]] && {
  _herdr_default_pane_title_worker() {
    command -v herdr &>/dev/null && command -v jq &>/dev/null || return 0

    local info title pane_status resurrect_file pinfo
    info=$(herdr pane get "$HERDR_PANE_ID" 2>/dev/null) || return 0
    if [[ $(printf '%s' "$info" | jq -r '.result.pane.label // empty') == editor ]]; then
      # Only the pane's original idle shell may restart its editor, not a nested shell.
      pinfo=$(herdr pane process-info --pane "$HERDR_PANE_ID" 2>/dev/null) || return 0
      if printf '%s' "$pinfo" | jq -e --argjson pid "$$" '
        .result.process_info | .shell_pid == $pid and
        (.foreground_processes | length == 1 and .[0].pid == $pid)
      ' >/dev/null; then
        herdr pane run "$HERDR_PANE_ID" '"${EDITOR:-nvim}" -S Session.vim' >/dev/null
      fi
      return 0
    fi

    resurrect_file="${HERDR_RESURRECT_FILE:-${XDG_STATE_HOME:-$HOME/.local/state}/herdr/resurrect.json}"

    # Panes recorded for process restore will briefly start as shells after a
    # Herdr layout restore. Do not name those "terminal" before resurrect starts
    # nvim/pi/claude/codex in them.
    if [[ -f $resurrect_file ]] && jq -e --arg pane_id "$HERDR_PANE_ID" '.commands[]? | select(.pane_id == $pane_id)' "$resurrect_file" >/dev/null 2>&1; then
      return 0
    fi

    title=$(printf '%s' "$info" | jq -r '.result.pane.title // empty')
    pane_status=$(printf '%s' "$info" | jq -r '.result.pane.agent_status // empty')
    [[ -z $title && $pane_status == unknown ]] && herdr pane rename "$HERDR_PANE_ID" terminal &>/dev/null
  }

  _herdr_default_pane_title() {
    if [[ -n ${ZSH_VERSION:-} ]]; then
      # zsh reports completed background jobs unless they are disowned.
      eval '_herdr_default_pane_title_worker &>/dev/null &!'
    else
      _herdr_default_pane_title_worker &>/dev/null &
    fi
  }

  if [[ -n ${ZSH_VERSION:-} ]]; then
    _herdr_first_prompt() {
      precmd_functions=("${precmd_functions[@]:#_herdr_first_prompt}")
      _herdr_default_pane_title
    }
    # During .zshrc, foreground initialization commands can look like a busy pane.
    precmd_functions+=(_herdr_first_prompt)
  else
    _herdr_default_pane_title
  fi

  _herdr_agent_title_watch() {
    local agent="$1"
    local watcher="${DOTFILES_DIR:-$HOME/.dotfiles}/ai/herdr/scripts/herdr-${agent}-title-watch"
    [[ -x $watcher ]] || return 0
    if [[ -n ${ZSH_VERSION:-} ]]; then
      eval "$watcher &>/dev/null &!"
    else
      "$watcher" &>/dev/null &
    fi
  }

  claude() {
    _herdr_agent_title_watch claude
    command claude "$@"
  }

  codex() {
    _herdr_agent_title_watch codex
    command codex "$@"
  }
}
