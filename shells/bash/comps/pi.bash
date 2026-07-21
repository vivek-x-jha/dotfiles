# shellcheck shell=bash

# Static completion for pi (@earendil-works/pi-coding-agent).

_pi_contains() {
  local needle=$1 item
  shift
  for item in "$@"; do [[ $item == "$needle" ]] && return 0; done
  return 1
}

_pi_first_non_option() {
  local i word
  for ((i = 1; i < COMP_CWORD; i++)); do
    word=${COMP_WORDS[i]}
    [[ $word == -- ]] && { ((i++)); break; }
    [[ $word == -* ]] && {
      case $word in
        --provider|--model|--api-key|--system-prompt|--append-system-prompt|--mode|--session|--session-id|--fork|--session-dir|--name|-n|--models|--tools|-t|--exclude-tools|-xt|--thinking|--extension|-e|--skill|--prompt-template|--theme|--export|--list-models)
          ((i++))
          ;;
      esac
      continue
    }
    printf '%s\n' "$word"
    return 0
  done
}

_pi_comp_files() {
  mapfile -t COMPREPLY < <(compgen -f -- "$cur")
}

_pi_comp_dirs() {
  mapfile -t COMPREPLY < <(compgen -d -- "$cur")
}

_pi_comp_words() {
  mapfile -t COMPREPLY < <(compgen -W "$1" -- "$cur")
}

_pi() {
  local cur prev subcmd
  local commands global_opts provider_values thinking_values mode_values tool_values update_opts package_opts trust_opts update_targets

  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD - 1]}

  commands='install remove uninstall update list config'
  provider_values='amazon-bedrock ant-ling anthropic azure-openai-responses cerebras cloudflare-ai-gateway cloudflare-workers-ai deepseek fireworks github-copilot google google-vertex groq huggingface kimi-coding minimax minimax-cn mistral moonshotai moonshotai-cn nvidia ollama openai openai-codex opencode opencode-go openrouter qwen-token-plan qwen-token-plan-cn together vercel-ai-gateway xai xiaomi xiaomi-token-plan-ams xiaomi-token-plan-cn xiaomi-token-plan-sgp zai zai-coding-cn'
  thinking_values='off minimal low medium high xhigh max'
  mode_values='text json rpc'
  tool_values='read bash edit write grep find ls'
  update_targets='pi self'
  trust_opts='-a --approve -na --no-approve -h --help'
  package_opts='-l --local -a --approve -na --no-approve -h --help'
  update_opts='--self --extensions --models --all --extension -a --approve -na --no-approve --force -h --help'
  global_opts='--provider --model --api-key --system-prompt --append-system-prompt --mode -p --print -c --continue -r --resume --session --session-id --fork --session-dir --no-session -n --name --models -nt --no-tools -nbt --no-builtin-tools -t --tools -xt --exclude-tools --thinking -e --extension -ne --no-extensions --skill -ns --no-skills --prompt-template -np --no-prompt-templates --theme --no-themes -nc --no-context-files --export --list-models --verbose -a --approve -na --no-approve --offline -h --help -v --version'

  case $prev in
    --provider)
      _pi_comp_words "$provider_values"
      return 0
      ;;
    --thinking)
      _pi_comp_words "$thinking_values"
      return 0
      ;;
    --mode)
      _pi_comp_words "$mode_values"
      return 0
      ;;
    --tools|-t|--exclude-tools|-xt)
      _pi_comp_words "$tool_values"
      return 0
      ;;
    --session-dir)
      _pi_comp_dirs
      return 0
      ;;
    --append-system-prompt|--session|--fork|--extension|-e|--skill|--prompt-template|--theme|--export)
      _pi_comp_files
      return 0
      ;;
    --api-key|--system-prompt|--model|--session-id|--name|-n|--models|--list-models)
      return 0
      ;;
  esac

  subcmd=$(_pi_first_non_option)

  if [[ -z $subcmd && $cur == -* ]]; then
    _pi_comp_words "$global_opts"
    return 0
  fi

  if [[ -z $subcmd ]]; then
    _pi_comp_words "$commands"
    # Also include local files for message @file/path use-cases.
    local -a file_matches
    mapfile -t file_matches < <(compgen -f -- "$cur")
    COMPREPLY+=("${file_matches[@]}")
    return 0
  fi

  case $subcmd in
    install|remove|uninstall)
      if [[ $cur == -* ]]; then
        _pi_comp_words "$package_opts"
      else
        _pi_comp_files
      fi
      ;;
    update)
      if [[ $prev == --extension ]]; then
        _pi_comp_files
      elif [[ $cur == -* ]]; then
        _pi_comp_words "$update_opts"
      else
        _pi_comp_words "$update_targets"
        local -a file_matches
        mapfile -t file_matches < <(compgen -f -- "$cur")
        COMPREPLY+=("${file_matches[@]}")
      fi
      ;;
    list)
      [[ $cur == -* ]] && _pi_comp_words "$trust_opts"
      ;;
    config)
      [[ $cur == -* ]] && _pi_comp_words "-l --local $trust_opts"
      ;;
    *)
      if [[ $cur == -* ]]; then
        _pi_comp_words "$global_opts"
      else
        _pi_comp_files
      fi
      ;;
  esac
}

complete -F _pi pi
