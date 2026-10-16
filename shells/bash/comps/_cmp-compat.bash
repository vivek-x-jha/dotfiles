# Minimal fallback helpers for packaged completions when bash-completion is absent.
# Git supplies _get_comp_words_by_ref through the completion loader.
# Helpers populate dynamically scoped caller variables.
# shellcheck shell=bash disable=SC2034

if ! declare -F _init_completion >/dev/null; then
  _init_completion() {
    local split_longopt=false
    [[ ${1-} != -s ]] || { split_longopt=true; shift; }
    COMPREPLY=()
    declare -F _get_comp_words_by_ref >/dev/null || return 1
    _get_comp_words_by_ref -n =: "$@" cur prev words cword
    if "$split_longopt"; then
      split=false
      _split_longopt && split=true
    fi
    return 0
  }
fi

if ! declare -F _split_longopt >/dev/null; then
  _split_longopt() {
    [[ ${cur-} == --*=* ]] || return 1
    prev=${cur%%=*}
    cur=${cur#*=}
  }
fi

if ! declare -F _filedir >/dev/null; then
  _filedir() {
    if [[ ${1-} == -d ]]; then
      mapfile -t COMPREPLY < <(compgen -d -- "${cur-}")
    else
      mapfile -t COMPREPLY < <(compgen -f -- "${cur-}")
    fi
  }
fi

if ! declare -F _parse_help >/dev/null; then
  _parse_help() {
    "$1" --help 2>/dev/null | grep -oE '(^|[[:space:],])--?[[:alnum:]][[:alnum:]-]*' | tr -d '[:blank:],'
  }
fi
