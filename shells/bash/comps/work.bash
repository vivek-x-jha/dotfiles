# shellcheck shell=bash

_work_sessions() {
  local candidate
  local -A seen=()

  while IFS= read -r candidate; do
    [[ -n $candidate && -z ${seen[$candidate]+x} ]] || continue
    seen[$candidate]=1
    printf '%s\n' "$candidate"
  done < <(
    if [[ -d $HOME/Developer ]]; then
      find "$HOME/Developer" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null
    fi

    command -v tmux &>/dev/null && tmux list-sessions -F '#S' 2>/dev/null
  )
}

_work() {
  local cur prev opts value_opts cmd_opts

  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD - 1]}

  opts='-h --help -r --reload -p --python --window-label --left-label --right-label --agents-label --left-cmd --right-cmd --agents-cmd --top-right-label --bottom-right-label --top-right-cmd --bottom-right-cmd'
  value_opts='--window-label --left-label --right-label --agents-label --top-right-label --bottom-right-label'
  cmd_opts='--left-cmd --right-cmd --agents-cmd --top-right-cmd --bottom-right-cmd'

  [[ " $value_opts " == *" $prev "* ]] && return 0

  [[ " $cmd_opts " == *" $prev "* ]] && {
    mapfile -t COMPREPLY < <(compgen -c -- "$cur")
    return 0
  }

  [[ $cur == -* ]] && {
    mapfile -t COMPREPLY < <(compgen -W "$opts" -- "$cur")
    return 0
  }

  mapfile -t COMPREPLY < <(compgen -W "$(_work_sessions)" -- "$cur")
}

complete -F _work work
