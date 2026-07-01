_cia() {
    local i cur prev opts cmd
    COMPREPLY=()
    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
        cur="$2"
    else
        cur="${COMP_WORDS[COMP_CWORD]}"
    fi
    prev="$3"
    cmd=""
    opts=""

    for i in "${COMP_WORDS[@]:0:COMP_CWORD}"
    do
        case "${cmd},${i}" in
            ",$1")
                cmd="cia"
                ;;
            cia,completions)
                cmd="cia__subcmd__completions"
                ;;
            cia,help)
                cmd="cia__subcmd__help"
                ;;
            cia,open)
                cmd="cia__subcmd__open"
                ;;
            cia,run-thread)
                cmd="cia__subcmd__run__subcmd__thread"
                ;;
            cia__subcmd__help,completions)
                cmd="cia__subcmd__help__subcmd__completions"
                ;;
            cia__subcmd__help,help)
                cmd="cia__subcmd__help__subcmd__help"
                ;;
            cia__subcmd__help,open)
                cmd="cia__subcmd__help__subcmd__open"
                ;;
            cia__subcmd__help,run-thread)
                cmd="cia__subcmd__help__subcmd__run__subcmd__thread"
                ;;
            *)
                ;;
        esac
    done

    case "${cmd}" in
        cia)
            opts="-h -V --project --help --version open completions run-thread help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 1 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --project)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        cia__subcmd__completions)
            opts="-h --project --help bash elvish fish powershell zsh"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --project)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        cia__subcmd__help)
            opts="open completions run-thread help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        cia__subcmd__help__subcmd__completions)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        cia__subcmd__help__subcmd__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        cia__subcmd__help__subcmd__open)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        cia__subcmd__help__subcmd__run__subcmd__thread)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        cia__subcmd__open)
            opts="-h --archived --harness --project --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --harness)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --project)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        cia__subcmd__run__subcmd__thread)
            opts="-h --thread-id --cwd-hex --title-hex --harness-id --agent-command-hex --codex-command-hex --session-dir-hex --project --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --thread-id)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cwd-hex)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --title-hex)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --harness-id)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --agent-command-hex)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --codex-command-hex)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --session-dir-hex)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --project)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
    esac
}

if [[ "${BASH_VERSINFO[0]}" -eq 4 && "${BASH_VERSINFO[1]}" -ge 4 || "${BASH_VERSINFO[0]}" -gt 4 ]]; then
    complete -F _cia -o nosort -o bashdefault -o default cia
else
    complete -F _cia -o bashdefault -o default cia
fi
