# shellcheck shell=bash

# Static completion for Claude Code. Claude currently ships no completion command.

_claude_session_ids() {
  local root="${CLAUDE_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/claude}/projects"
  find "$root" -type f -name '*.jsonl' -exec basename {} .jsonl \; 2>/dev/null | sort -u
}

_claude() {
  local cur prev commands options
  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD - 1]}

  commands='agents auth auto-mode doctor gateway install mcp plugin plugins project setup-token ultrareview update upgrade'
  options='--add-dir --agent --agents --allow-dangerously-skip-permissions --allowedTools --allowed-tools --append-system-prompt --ax-screen-reader --bg --background --bare --betas --brief --chrome -c --continue --dangerously-skip-permissions -d --debug --debug-file --disable-slash-commands --disallowedTools --disallowed-tools --effort --exclude-dynamic-system-prompt-sections --fallback-model --file --fork-session --forward-subagent-text --from-pr -h --help --ide --include-hook-events --include-partial-messages --input-format --json-schema --max-budget-usd --mcp-config --model -n --name --no-chrome --no-session-persistence --output-format --permission-mode --plugin-dir --plugin-url -p --print --prompt-suggestions --remote-control --remote-control-session-name-prefix --replay-user-messages -r --resume --safe-mode --session-id --setting-sources --settings --strict-mcp-config --system-prompt --tmux --tools --verbose -v --version -w --worktree'

  case $prev in
    -r|--resume|--session-id)
      mapfile -t COMPREPLY < <(compgen -W "$(_claude_session_ids)" -- "$cur")
      return 0
      ;;
    --model|--fallback-model)
      mapfile -t COMPREPLY < <(compgen -W 'default sonnet opus haiku fable gpt-5.6-sol' -- "$cur")
      return 0
      ;;
    --effort)
      mapfile -t COMPREPLY < <(compgen -W 'low medium high xhigh max' -- "$cur")
      return 0
      ;;
    --input-format)
      mapfile -t COMPREPLY < <(compgen -W 'text stream-json' -- "$cur")
      return 0
      ;;
    --output-format)
      mapfile -t COMPREPLY < <(compgen -W 'text json stream-json' -- "$cur")
      return 0
      ;;
    --permission-mode)
      mapfile -t COMPREPLY < <(compgen -W 'acceptEdits auto bypassPermissions manual dontAsk plan' -- "$cur")
      return 0
      ;;
    --setting-sources)
      mapfile -t COMPREPLY < <(compgen -W 'user project local' -- "$cur")
      return 0
      ;;
    --add-dir|--debug-file|--file|--mcp-config|--plugin-dir|--settings)
      mapfile -t COMPREPLY < <(compgen -f -- "$cur")
      return 0
      ;;
    --plugin-url)
      return 0
      ;;
    --agent|--agents|--allowedTools|--allowed-tools|--append-system-prompt|--betas|--debug|--disallowedTools|--disallowed-tools|--from-pr|--json-schema|--max-budget-usd|--name|-n|--prompt-suggestions|--remote-control|--remote-control-session-name-prefix|--system-prompt|--tools|--worktree|-w)
      return 0
      ;;
  esac

  if [[ $cur == -* ]]; then
    mapfile -t COMPREPLY < <(compgen -W "$options" -- "$cur")
  elif (( COMP_CWORD == 1 )); then
    mapfile -t COMPREPLY < <(compgen -W "$commands" -- "$cur")
    local -a files
    mapfile -t files < <(compgen -f -- "$cur")
    COMPREPLY+=("${files[@]}")
  else
    mapfile -t COMPREPLY < <(compgen -f -- "$cur")
  fi
}

complete -F _claude -o bashdefault -o default claude claudex
