# shellcheck shell=bash disable=SC2207

_atuin() {
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
                cmd="atuin"
                ;;
            atuin,account)
                cmd="atuin__subcmd__account"
                ;;
            atuin,ai)
                cmd="atuin__subcmd__ai"
                ;;
            atuin,config)
                cmd="atuin__subcmd__config"
                ;;
            atuin,contributors)
                cmd="atuin__subcmd__contributors"
                ;;
            atuin,daemon)
                cmd="atuin__subcmd__daemon"
                ;;
            atuin,default-config)
                cmd="atuin__subcmd__default__subcmd__config"
                ;;
            atuin,doctor)
                cmd="atuin__subcmd__doctor"
                ;;
            atuin,dotfiles)
                cmd="atuin__subcmd__dotfiles"
                ;;
            atuin,gen-completions)
                cmd="atuin__subcmd__gen__subcmd__completions"
                ;;
            atuin,help)
                cmd="atuin__subcmd__help"
                ;;
            atuin,history)
                cmd="atuin__subcmd__history"
                ;;
            atuin,hook)
                cmd="atuin__subcmd__hook"
                ;;
            atuin,import)
                cmd="atuin__subcmd__import"
                ;;
            atuin,info)
                cmd="atuin__subcmd__info"
                ;;
            atuin,init)
                cmd="atuin__subcmd__init"
                ;;
            atuin,key)
                cmd="atuin__subcmd__key"
                ;;
            atuin,kv)
                cmd="atuin__subcmd__kv"
                ;;
            atuin,login)
                cmd="atuin__subcmd__login"
                ;;
            atuin,logout)
                cmd="atuin__subcmd__logout"
                ;;
            atuin,pty-proxy)
                cmd="atuin__subcmd__pty__subcmd__proxy"
                ;;
            atuin,register)
                cmd="atuin__subcmd__register"
                ;;
            atuin,scripts)
                cmd="atuin__subcmd__scripts"
                ;;
            atuin,search)
                cmd="atuin__subcmd__search"
                ;;
            atuin,setup)
                cmd="atuin__subcmd__setup"
                ;;
            atuin,stats)
                cmd="atuin__subcmd__stats"
                ;;
            atuin,status)
                cmd="atuin__subcmd__status"
                ;;
            atuin,store)
                cmd="atuin__subcmd__store"
                ;;
            atuin,sync)
                cmd="atuin__subcmd__sync"
                ;;
            atuin,uuid)
                cmd="atuin__subcmd__uuid"
                ;;
            atuin,wrapped)
                cmd="atuin__subcmd__wrapped"
                ;;
            atuin__subcmd__account,change-password)
                cmd="atuin__subcmd__account__subcmd__change__subcmd__password"
                ;;
            atuin__subcmd__account,delete)
                cmd="atuin__subcmd__account__subcmd__delete"
                ;;
            atuin__subcmd__account,help)
                cmd="atuin__subcmd__account__subcmd__help"
                ;;
            atuin__subcmd__account,link)
                cmd="atuin__subcmd__account__subcmd__link"
                ;;
            atuin__subcmd__account,login)
                cmd="atuin__subcmd__account__subcmd__login"
                ;;
            atuin__subcmd__account,logout)
                cmd="atuin__subcmd__account__subcmd__logout"
                ;;
            atuin__subcmd__account,register)
                cmd="atuin__subcmd__account__subcmd__register"
                ;;
            atuin__subcmd__account__subcmd__help,change-password)
                cmd="atuin__subcmd__account__subcmd__help__subcmd__change__subcmd__password"
                ;;
            atuin__subcmd__account__subcmd__help,delete)
                cmd="atuin__subcmd__account__subcmd__help__subcmd__delete"
                ;;
            atuin__subcmd__account__subcmd__help,help)
                cmd="atuin__subcmd__account__subcmd__help__subcmd__help"
                ;;
            atuin__subcmd__account__subcmd__help,link)
                cmd="atuin__subcmd__account__subcmd__help__subcmd__link"
                ;;
            atuin__subcmd__account__subcmd__help,login)
                cmd="atuin__subcmd__account__subcmd__help__subcmd__login"
                ;;
            atuin__subcmd__account__subcmd__help,logout)
                cmd="atuin__subcmd__account__subcmd__help__subcmd__logout"
                ;;
            atuin__subcmd__account__subcmd__help,register)
                cmd="atuin__subcmd__account__subcmd__help__subcmd__register"
                ;;
            atuin__subcmd__ai,help)
                cmd="atuin__subcmd__ai__subcmd__help"
                ;;
            atuin__subcmd__ai,init)
                cmd="atuin__subcmd__ai__subcmd__init"
                ;;
            atuin__subcmd__ai,inline)
                cmd="atuin__subcmd__ai__subcmd__inline"
                ;;
            atuin__subcmd__ai__subcmd__help,help)
                cmd="atuin__subcmd__ai__subcmd__help__subcmd__help"
                ;;
            atuin__subcmd__ai__subcmd__help,init)
                cmd="atuin__subcmd__ai__subcmd__help__subcmd__init"
                ;;
            atuin__subcmd__ai__subcmd__help,inline)
                cmd="atuin__subcmd__ai__subcmd__help__subcmd__inline"
                ;;
            atuin__subcmd__config,get)
                cmd="atuin__subcmd__config__subcmd__get"
                ;;
            atuin__subcmd__config,help)
                cmd="atuin__subcmd__config__subcmd__help"
                ;;
            atuin__subcmd__config,print)
                cmd="atuin__subcmd__config__subcmd__print"
                ;;
            atuin__subcmd__config,set)
                cmd="atuin__subcmd__config__subcmd__set"
                ;;
            atuin__subcmd__config__subcmd__help,get)
                cmd="atuin__subcmd__config__subcmd__help__subcmd__get"
                ;;
            atuin__subcmd__config__subcmd__help,help)
                cmd="atuin__subcmd__config__subcmd__help__subcmd__help"
                ;;
            atuin__subcmd__config__subcmd__help,print)
                cmd="atuin__subcmd__config__subcmd__help__subcmd__print"
                ;;
            atuin__subcmd__config__subcmd__help,set)
                cmd="atuin__subcmd__config__subcmd__help__subcmd__set"
                ;;
            atuin__subcmd__daemon,help)
                cmd="atuin__subcmd__daemon__subcmd__help"
                ;;
            atuin__subcmd__daemon,restart)
                cmd="atuin__subcmd__daemon__subcmd__restart"
                ;;
            atuin__subcmd__daemon,start)
                cmd="atuin__subcmd__daemon__subcmd__start"
                ;;
            atuin__subcmd__daemon,status)
                cmd="atuin__subcmd__daemon__subcmd__status"
                ;;
            atuin__subcmd__daemon,stop)
                cmd="atuin__subcmd__daemon__subcmd__stop"
                ;;
            atuin__subcmd__daemon__subcmd__help,help)
                cmd="atuin__subcmd__daemon__subcmd__help__subcmd__help"
                ;;
            atuin__subcmd__daemon__subcmd__help,restart)
                cmd="atuin__subcmd__daemon__subcmd__help__subcmd__restart"
                ;;
            atuin__subcmd__daemon__subcmd__help,start)
                cmd="atuin__subcmd__daemon__subcmd__help__subcmd__start"
                ;;
            atuin__subcmd__daemon__subcmd__help,status)
                cmd="atuin__subcmd__daemon__subcmd__help__subcmd__status"
                ;;
            atuin__subcmd__daemon__subcmd__help,stop)
                cmd="atuin__subcmd__daemon__subcmd__help__subcmd__stop"
                ;;
            atuin__subcmd__dotfiles,alias)
                cmd="atuin__subcmd__dotfiles__subcmd__alias"
                ;;
            atuin__subcmd__dotfiles,help)
                cmd="atuin__subcmd__dotfiles__subcmd__help"
                ;;
            atuin__subcmd__dotfiles,var)
                cmd="atuin__subcmd__dotfiles__subcmd__var"
                ;;
            atuin__subcmd__dotfiles__subcmd__alias,clear)
                cmd="atuin__subcmd__dotfiles__subcmd__alias__subcmd__clear"
                ;;
            atuin__subcmd__dotfiles__subcmd__alias,delete)
                cmd="atuin__subcmd__dotfiles__subcmd__alias__subcmd__delete"
                ;;
            atuin__subcmd__dotfiles__subcmd__alias,help)
                cmd="atuin__subcmd__dotfiles__subcmd__alias__subcmd__help"
                ;;
            atuin__subcmd__dotfiles__subcmd__alias,list)
                cmd="atuin__subcmd__dotfiles__subcmd__alias__subcmd__list"
                ;;
            atuin__subcmd__dotfiles__subcmd__alias,set)
                cmd="atuin__subcmd__dotfiles__subcmd__alias__subcmd__set"
                ;;
            atuin__subcmd__dotfiles__subcmd__alias__subcmd__help,clear)
                cmd="atuin__subcmd__dotfiles__subcmd__alias__subcmd__help__subcmd__clear"
                ;;
            atuin__subcmd__dotfiles__subcmd__alias__subcmd__help,delete)
                cmd="atuin__subcmd__dotfiles__subcmd__alias__subcmd__help__subcmd__delete"
                ;;
            atuin__subcmd__dotfiles__subcmd__alias__subcmd__help,help)
                cmd="atuin__subcmd__dotfiles__subcmd__alias__subcmd__help__subcmd__help"
                ;;
            atuin__subcmd__dotfiles__subcmd__alias__subcmd__help,list)
                cmd="atuin__subcmd__dotfiles__subcmd__alias__subcmd__help__subcmd__list"
                ;;
            atuin__subcmd__dotfiles__subcmd__alias__subcmd__help,set)
                cmd="atuin__subcmd__dotfiles__subcmd__alias__subcmd__help__subcmd__set"
                ;;
            atuin__subcmd__dotfiles__subcmd__help,alias)
                cmd="atuin__subcmd__dotfiles__subcmd__help__subcmd__alias"
                ;;
            atuin__subcmd__dotfiles__subcmd__help,help)
                cmd="atuin__subcmd__dotfiles__subcmd__help__subcmd__help"
                ;;
            atuin__subcmd__dotfiles__subcmd__help,var)
                cmd="atuin__subcmd__dotfiles__subcmd__help__subcmd__var"
                ;;
            atuin__subcmd__dotfiles__subcmd__help__subcmd__alias,clear)
                cmd="atuin__subcmd__dotfiles__subcmd__help__subcmd__alias__subcmd__clear"
                ;;
            atuin__subcmd__dotfiles__subcmd__help__subcmd__alias,delete)
                cmd="atuin__subcmd__dotfiles__subcmd__help__subcmd__alias__subcmd__delete"
                ;;
            atuin__subcmd__dotfiles__subcmd__help__subcmd__alias,list)
                cmd="atuin__subcmd__dotfiles__subcmd__help__subcmd__alias__subcmd__list"
                ;;
            atuin__subcmd__dotfiles__subcmd__help__subcmd__alias,set)
                cmd="atuin__subcmd__dotfiles__subcmd__help__subcmd__alias__subcmd__set"
                ;;
            atuin__subcmd__dotfiles__subcmd__help__subcmd__var,delete)
                cmd="atuin__subcmd__dotfiles__subcmd__help__subcmd__var__subcmd__delete"
                ;;
            atuin__subcmd__dotfiles__subcmd__help__subcmd__var,list)
                cmd="atuin__subcmd__dotfiles__subcmd__help__subcmd__var__subcmd__list"
                ;;
            atuin__subcmd__dotfiles__subcmd__help__subcmd__var,set)
                cmd="atuin__subcmd__dotfiles__subcmd__help__subcmd__var__subcmd__set"
                ;;
            atuin__subcmd__dotfiles__subcmd__var,delete)
                cmd="atuin__subcmd__dotfiles__subcmd__var__subcmd__delete"
                ;;
            atuin__subcmd__dotfiles__subcmd__var,help)
                cmd="atuin__subcmd__dotfiles__subcmd__var__subcmd__help"
                ;;
            atuin__subcmd__dotfiles__subcmd__var,list)
                cmd="atuin__subcmd__dotfiles__subcmd__var__subcmd__list"
                ;;
            atuin__subcmd__dotfiles__subcmd__var,set)
                cmd="atuin__subcmd__dotfiles__subcmd__var__subcmd__set"
                ;;
            atuin__subcmd__dotfiles__subcmd__var__subcmd__help,delete)
                cmd="atuin__subcmd__dotfiles__subcmd__var__subcmd__help__subcmd__delete"
                ;;
            atuin__subcmd__dotfiles__subcmd__var__subcmd__help,help)
                cmd="atuin__subcmd__dotfiles__subcmd__var__subcmd__help__subcmd__help"
                ;;
            atuin__subcmd__dotfiles__subcmd__var__subcmd__help,list)
                cmd="atuin__subcmd__dotfiles__subcmd__var__subcmd__help__subcmd__list"
                ;;
            atuin__subcmd__dotfiles__subcmd__var__subcmd__help,set)
                cmd="atuin__subcmd__dotfiles__subcmd__var__subcmd__help__subcmd__set"
                ;;
            atuin__subcmd__help,account)
                cmd="atuin__subcmd__help__subcmd__account"
                ;;
            atuin__subcmd__help,ai)
                cmd="atuin__subcmd__help__subcmd__ai"
                ;;
            atuin__subcmd__help,config)
                cmd="atuin__subcmd__help__subcmd__config"
                ;;
            atuin__subcmd__help,contributors)
                cmd="atuin__subcmd__help__subcmd__contributors"
                ;;
            atuin__subcmd__help,daemon)
                cmd="atuin__subcmd__help__subcmd__daemon"
                ;;
            atuin__subcmd__help,default-config)
                cmd="atuin__subcmd__help__subcmd__default__subcmd__config"
                ;;
            atuin__subcmd__help,doctor)
                cmd="atuin__subcmd__help__subcmd__doctor"
                ;;
            atuin__subcmd__help,dotfiles)
                cmd="atuin__subcmd__help__subcmd__dotfiles"
                ;;
            atuin__subcmd__help,gen-completions)
                cmd="atuin__subcmd__help__subcmd__gen__subcmd__completions"
                ;;
            atuin__subcmd__help,help)
                cmd="atuin__subcmd__help__subcmd__help"
                ;;
            atuin__subcmd__help,history)
                cmd="atuin__subcmd__help__subcmd__history"
                ;;
            atuin__subcmd__help,hook)
                cmd="atuin__subcmd__help__subcmd__hook"
                ;;
            atuin__subcmd__help,import)
                cmd="atuin__subcmd__help__subcmd__import"
                ;;
            atuin__subcmd__help,info)
                cmd="atuin__subcmd__help__subcmd__info"
                ;;
            atuin__subcmd__help,init)
                cmd="atuin__subcmd__help__subcmd__init"
                ;;
            atuin__subcmd__help,key)
                cmd="atuin__subcmd__help__subcmd__key"
                ;;
            atuin__subcmd__help,kv)
                cmd="atuin__subcmd__help__subcmd__kv"
                ;;
            atuin__subcmd__help,login)
                cmd="atuin__subcmd__help__subcmd__login"
                ;;
            atuin__subcmd__help,logout)
                cmd="atuin__subcmd__help__subcmd__logout"
                ;;
            atuin__subcmd__help,pty-proxy)
                cmd="atuin__subcmd__help__subcmd__pty__subcmd__proxy"
                ;;
            atuin__subcmd__help,register)
                cmd="atuin__subcmd__help__subcmd__register"
                ;;
            atuin__subcmd__help,scripts)
                cmd="atuin__subcmd__help__subcmd__scripts"
                ;;
            atuin__subcmd__help,search)
                cmd="atuin__subcmd__help__subcmd__search"
                ;;
            atuin__subcmd__help,setup)
                cmd="atuin__subcmd__help__subcmd__setup"
                ;;
            atuin__subcmd__help,stats)
                cmd="atuin__subcmd__help__subcmd__stats"
                ;;
            atuin__subcmd__help,status)
                cmd="atuin__subcmd__help__subcmd__status"
                ;;
            atuin__subcmd__help,store)
                cmd="atuin__subcmd__help__subcmd__store"
                ;;
            atuin__subcmd__help,sync)
                cmd="atuin__subcmd__help__subcmd__sync"
                ;;
            atuin__subcmd__help,uuid)
                cmd="atuin__subcmd__help__subcmd__uuid"
                ;;
            atuin__subcmd__help,wrapped)
                cmd="atuin__subcmd__help__subcmd__wrapped"
                ;;
            atuin__subcmd__help__subcmd__account,change-password)
                cmd="atuin__subcmd__help__subcmd__account__subcmd__change__subcmd__password"
                ;;
            atuin__subcmd__help__subcmd__account,delete)
                cmd="atuin__subcmd__help__subcmd__account__subcmd__delete"
                ;;
            atuin__subcmd__help__subcmd__account,link)
                cmd="atuin__subcmd__help__subcmd__account__subcmd__link"
                ;;
            atuin__subcmd__help__subcmd__account,login)
                cmd="atuin__subcmd__help__subcmd__account__subcmd__login"
                ;;
            atuin__subcmd__help__subcmd__account,logout)
                cmd="atuin__subcmd__help__subcmd__account__subcmd__logout"
                ;;
            atuin__subcmd__help__subcmd__account,register)
                cmd="atuin__subcmd__help__subcmd__account__subcmd__register"
                ;;
            atuin__subcmd__help__subcmd__ai,init)
                cmd="atuin__subcmd__help__subcmd__ai__subcmd__init"
                ;;
            atuin__subcmd__help__subcmd__ai,inline)
                cmd="atuin__subcmd__help__subcmd__ai__subcmd__inline"
                ;;
            atuin__subcmd__help__subcmd__config,get)
                cmd="atuin__subcmd__help__subcmd__config__subcmd__get"
                ;;
            atuin__subcmd__help__subcmd__config,print)
                cmd="atuin__subcmd__help__subcmd__config__subcmd__print"
                ;;
            atuin__subcmd__help__subcmd__config,set)
                cmd="atuin__subcmd__help__subcmd__config__subcmd__set"
                ;;
            atuin__subcmd__help__subcmd__daemon,restart)
                cmd="atuin__subcmd__help__subcmd__daemon__subcmd__restart"
                ;;
            atuin__subcmd__help__subcmd__daemon,start)
                cmd="atuin__subcmd__help__subcmd__daemon__subcmd__start"
                ;;
            atuin__subcmd__help__subcmd__daemon,status)
                cmd="atuin__subcmd__help__subcmd__daemon__subcmd__status"
                ;;
            atuin__subcmd__help__subcmd__daemon,stop)
                cmd="atuin__subcmd__help__subcmd__daemon__subcmd__stop"
                ;;
            atuin__subcmd__help__subcmd__dotfiles,alias)
                cmd="atuin__subcmd__help__subcmd__dotfiles__subcmd__alias"
                ;;
            atuin__subcmd__help__subcmd__dotfiles,var)
                cmd="atuin__subcmd__help__subcmd__dotfiles__subcmd__var"
                ;;
            atuin__subcmd__help__subcmd__dotfiles__subcmd__alias,clear)
                cmd="atuin__subcmd__help__subcmd__dotfiles__subcmd__alias__subcmd__clear"
                ;;
            atuin__subcmd__help__subcmd__dotfiles__subcmd__alias,delete)
                cmd="atuin__subcmd__help__subcmd__dotfiles__subcmd__alias__subcmd__delete"
                ;;
            atuin__subcmd__help__subcmd__dotfiles__subcmd__alias,list)
                cmd="atuin__subcmd__help__subcmd__dotfiles__subcmd__alias__subcmd__list"
                ;;
            atuin__subcmd__help__subcmd__dotfiles__subcmd__alias,set)
                cmd="atuin__subcmd__help__subcmd__dotfiles__subcmd__alias__subcmd__set"
                ;;
            atuin__subcmd__help__subcmd__dotfiles__subcmd__var,delete)
                cmd="atuin__subcmd__help__subcmd__dotfiles__subcmd__var__subcmd__delete"
                ;;
            atuin__subcmd__help__subcmd__dotfiles__subcmd__var,list)
                cmd="atuin__subcmd__help__subcmd__dotfiles__subcmd__var__subcmd__list"
                ;;
            atuin__subcmd__help__subcmd__dotfiles__subcmd__var,set)
                cmd="atuin__subcmd__help__subcmd__dotfiles__subcmd__var__subcmd__set"
                ;;
            atuin__subcmd__help__subcmd__history,dedup)
                cmd="atuin__subcmd__help__subcmd__history__subcmd__dedup"
                ;;
            atuin__subcmd__help__subcmd__history,end)
                cmd="atuin__subcmd__help__subcmd__history__subcmd__end"
                ;;
            atuin__subcmd__help__subcmd__history,init-store)
                cmd="atuin__subcmd__help__subcmd__history__subcmd__init__subcmd__store"
                ;;
            atuin__subcmd__help__subcmd__history,last)
                cmd="atuin__subcmd__help__subcmd__history__subcmd__last"
                ;;
            atuin__subcmd__help__subcmd__history,list)
                cmd="atuin__subcmd__help__subcmd__history__subcmd__list"
                ;;
            atuin__subcmd__help__subcmd__history,prune)
                cmd="atuin__subcmd__help__subcmd__history__subcmd__prune"
                ;;
            atuin__subcmd__help__subcmd__history,start)
                cmd="atuin__subcmd__help__subcmd__history__subcmd__start"
                ;;
            atuin__subcmd__help__subcmd__history,tail)
                cmd="atuin__subcmd__help__subcmd__history__subcmd__tail"
                ;;
            atuin__subcmd__help__subcmd__hook,install)
                cmd="atuin__subcmd__help__subcmd__hook__subcmd__install"
                ;;
            atuin__subcmd__help__subcmd__import,auto)
                cmd="atuin__subcmd__help__subcmd__import__subcmd__auto"
                ;;
            atuin__subcmd__help__subcmd__import,bash)
                cmd="atuin__subcmd__help__subcmd__import__subcmd__bash"
                ;;
            atuin__subcmd__help__subcmd__import,fish)
                cmd="atuin__subcmd__help__subcmd__import__subcmd__fish"
                ;;
            atuin__subcmd__help__subcmd__import,nu)
                cmd="atuin__subcmd__help__subcmd__import__subcmd__nu"
                ;;
            atuin__subcmd__help__subcmd__import,nu-hist-db)
                cmd="atuin__subcmd__help__subcmd__import__subcmd__nu__subcmd__hist__subcmd__db"
                ;;
            atuin__subcmd__help__subcmd__import,powershell)
                cmd="atuin__subcmd__help__subcmd__import__subcmd__powershell"
                ;;
            atuin__subcmd__help__subcmd__import,replxx)
                cmd="atuin__subcmd__help__subcmd__import__subcmd__replxx"
                ;;
            atuin__subcmd__help__subcmd__import,resh)
                cmd="atuin__subcmd__help__subcmd__import__subcmd__resh"
                ;;
            atuin__subcmd__help__subcmd__import,xonsh)
                cmd="atuin__subcmd__help__subcmd__import__subcmd__xonsh"
                ;;
            atuin__subcmd__help__subcmd__import,xonsh-sqlite)
                cmd="atuin__subcmd__help__subcmd__import__subcmd__xonsh__subcmd__sqlite"
                ;;
            atuin__subcmd__help__subcmd__import,zsh)
                cmd="atuin__subcmd__help__subcmd__import__subcmd__zsh"
                ;;
            atuin__subcmd__help__subcmd__import,zsh-hist-db)
                cmd="atuin__subcmd__help__subcmd__import__subcmd__zsh__subcmd__hist__subcmd__db"
                ;;
            atuin__subcmd__help__subcmd__kv,delete)
                cmd="atuin__subcmd__help__subcmd__kv__subcmd__delete"
                ;;
            atuin__subcmd__help__subcmd__kv,get)
                cmd="atuin__subcmd__help__subcmd__kv__subcmd__get"
                ;;
            atuin__subcmd__help__subcmd__kv,list)
                cmd="atuin__subcmd__help__subcmd__kv__subcmd__list"
                ;;
            atuin__subcmd__help__subcmd__kv,rebuild)
                cmd="atuin__subcmd__help__subcmd__kv__subcmd__rebuild"
                ;;
            atuin__subcmd__help__subcmd__kv,set)
                cmd="atuin__subcmd__help__subcmd__kv__subcmd__set"
                ;;
            atuin__subcmd__help__subcmd__pty__subcmd__proxy,init)
                cmd="atuin__subcmd__help__subcmd__pty__subcmd__proxy__subcmd__init"
                ;;
            atuin__subcmd__help__subcmd__scripts,delete)
                cmd="atuin__subcmd__help__subcmd__scripts__subcmd__delete"
                ;;
            atuin__subcmd__help__subcmd__scripts,edit)
                cmd="atuin__subcmd__help__subcmd__scripts__subcmd__edit"
                ;;
            atuin__subcmd__help__subcmd__scripts,get)
                cmd="atuin__subcmd__help__subcmd__scripts__subcmd__get"
                ;;
            atuin__subcmd__help__subcmd__scripts,list)
                cmd="atuin__subcmd__help__subcmd__scripts__subcmd__list"
                ;;
            atuin__subcmd__help__subcmd__scripts,new)
                cmd="atuin__subcmd__help__subcmd__scripts__subcmd__new"
                ;;
            atuin__subcmd__help__subcmd__scripts,run)
                cmd="atuin__subcmd__help__subcmd__scripts__subcmd__run"
                ;;
            atuin__subcmd__help__subcmd__store,pull)
                cmd="atuin__subcmd__help__subcmd__store__subcmd__pull"
                ;;
            atuin__subcmd__help__subcmd__store,purge)
                cmd="atuin__subcmd__help__subcmd__store__subcmd__purge"
                ;;
            atuin__subcmd__help__subcmd__store,push)
                cmd="atuin__subcmd__help__subcmd__store__subcmd__push"
                ;;
            atuin__subcmd__help__subcmd__store,rebuild)
                cmd="atuin__subcmd__help__subcmd__store__subcmd__rebuild"
                ;;
            atuin__subcmd__help__subcmd__store,rekey)
                cmd="atuin__subcmd__help__subcmd__store__subcmd__rekey"
                ;;
            atuin__subcmd__help__subcmd__store,status)
                cmd="atuin__subcmd__help__subcmd__store__subcmd__status"
                ;;
            atuin__subcmd__help__subcmd__store,verify)
                cmd="atuin__subcmd__help__subcmd__store__subcmd__verify"
                ;;
            atuin__subcmd__history,dedup)
                cmd="atuin__subcmd__history__subcmd__dedup"
                ;;
            atuin__subcmd__history,end)
                cmd="atuin__subcmd__history__subcmd__end"
                ;;
            atuin__subcmd__history,help)
                cmd="atuin__subcmd__history__subcmd__help"
                ;;
            atuin__subcmd__history,init-store)
                cmd="atuin__subcmd__history__subcmd__init__subcmd__store"
                ;;
            atuin__subcmd__history,last)
                cmd="atuin__subcmd__history__subcmd__last"
                ;;
            atuin__subcmd__history,list)
                cmd="atuin__subcmd__history__subcmd__list"
                ;;
            atuin__subcmd__history,prune)
                cmd="atuin__subcmd__history__subcmd__prune"
                ;;
            atuin__subcmd__history,start)
                cmd="atuin__subcmd__history__subcmd__start"
                ;;
            atuin__subcmd__history,tail)
                cmd="atuin__subcmd__history__subcmd__tail"
                ;;
            atuin__subcmd__history__subcmd__help,dedup)
                cmd="atuin__subcmd__history__subcmd__help__subcmd__dedup"
                ;;
            atuin__subcmd__history__subcmd__help,end)
                cmd="atuin__subcmd__history__subcmd__help__subcmd__end"
                ;;
            atuin__subcmd__history__subcmd__help,help)
                cmd="atuin__subcmd__history__subcmd__help__subcmd__help"
                ;;
            atuin__subcmd__history__subcmd__help,init-store)
                cmd="atuin__subcmd__history__subcmd__help__subcmd__init__subcmd__store"
                ;;
            atuin__subcmd__history__subcmd__help,last)
                cmd="atuin__subcmd__history__subcmd__help__subcmd__last"
                ;;
            atuin__subcmd__history__subcmd__help,list)
                cmd="atuin__subcmd__history__subcmd__help__subcmd__list"
                ;;
            atuin__subcmd__history__subcmd__help,prune)
                cmd="atuin__subcmd__history__subcmd__help__subcmd__prune"
                ;;
            atuin__subcmd__history__subcmd__help,start)
                cmd="atuin__subcmd__history__subcmd__help__subcmd__start"
                ;;
            atuin__subcmd__history__subcmd__help,tail)
                cmd="atuin__subcmd__history__subcmd__help__subcmd__tail"
                ;;
            atuin__subcmd__hook,help)
                cmd="atuin__subcmd__hook__subcmd__help"
                ;;
            atuin__subcmd__hook,install)
                cmd="atuin__subcmd__hook__subcmd__install"
                ;;
            atuin__subcmd__hook__subcmd__help,help)
                cmd="atuin__subcmd__hook__subcmd__help__subcmd__help"
                ;;
            atuin__subcmd__hook__subcmd__help,install)
                cmd="atuin__subcmd__hook__subcmd__help__subcmd__install"
                ;;
            atuin__subcmd__import,auto)
                cmd="atuin__subcmd__import__subcmd__auto"
                ;;
            atuin__subcmd__import,bash)
                cmd="atuin__subcmd__import__subcmd__bash"
                ;;
            atuin__subcmd__import,fish)
                cmd="atuin__subcmd__import__subcmd__fish"
                ;;
            atuin__subcmd__import,help)
                cmd="atuin__subcmd__import__subcmd__help"
                ;;
            atuin__subcmd__import,nu)
                cmd="atuin__subcmd__import__subcmd__nu"
                ;;
            atuin__subcmd__import,nu-hist-db)
                cmd="atuin__subcmd__import__subcmd__nu__subcmd__hist__subcmd__db"
                ;;
            atuin__subcmd__import,powershell)
                cmd="atuin__subcmd__import__subcmd__powershell"
                ;;
            atuin__subcmd__import,replxx)
                cmd="atuin__subcmd__import__subcmd__replxx"
                ;;
            atuin__subcmd__import,resh)
                cmd="atuin__subcmd__import__subcmd__resh"
                ;;
            atuin__subcmd__import,xonsh)
                cmd="atuin__subcmd__import__subcmd__xonsh"
                ;;
            atuin__subcmd__import,xonsh-sqlite)
                cmd="atuin__subcmd__import__subcmd__xonsh__subcmd__sqlite"
                ;;
            atuin__subcmd__import,zsh)
                cmd="atuin__subcmd__import__subcmd__zsh"
                ;;
            atuin__subcmd__import,zsh-hist-db)
                cmd="atuin__subcmd__import__subcmd__zsh__subcmd__hist__subcmd__db"
                ;;
            atuin__subcmd__import__subcmd__help,auto)
                cmd="atuin__subcmd__import__subcmd__help__subcmd__auto"
                ;;
            atuin__subcmd__import__subcmd__help,bash)
                cmd="atuin__subcmd__import__subcmd__help__subcmd__bash"
                ;;
            atuin__subcmd__import__subcmd__help,fish)
                cmd="atuin__subcmd__import__subcmd__help__subcmd__fish"
                ;;
            atuin__subcmd__import__subcmd__help,help)
                cmd="atuin__subcmd__import__subcmd__help__subcmd__help"
                ;;
            atuin__subcmd__import__subcmd__help,nu)
                cmd="atuin__subcmd__import__subcmd__help__subcmd__nu"
                ;;
            atuin__subcmd__import__subcmd__help,nu-hist-db)
                cmd="atuin__subcmd__import__subcmd__help__subcmd__nu__subcmd__hist__subcmd__db"
                ;;
            atuin__subcmd__import__subcmd__help,powershell)
                cmd="atuin__subcmd__import__subcmd__help__subcmd__powershell"
                ;;
            atuin__subcmd__import__subcmd__help,replxx)
                cmd="atuin__subcmd__import__subcmd__help__subcmd__replxx"
                ;;
            atuin__subcmd__import__subcmd__help,resh)
                cmd="atuin__subcmd__import__subcmd__help__subcmd__resh"
                ;;
            atuin__subcmd__import__subcmd__help,xonsh)
                cmd="atuin__subcmd__import__subcmd__help__subcmd__xonsh"
                ;;
            atuin__subcmd__import__subcmd__help,xonsh-sqlite)
                cmd="atuin__subcmd__import__subcmd__help__subcmd__xonsh__subcmd__sqlite"
                ;;
            atuin__subcmd__import__subcmd__help,zsh)
                cmd="atuin__subcmd__import__subcmd__help__subcmd__zsh"
                ;;
            atuin__subcmd__import__subcmd__help,zsh-hist-db)
                cmd="atuin__subcmd__import__subcmd__help__subcmd__zsh__subcmd__hist__subcmd__db"
                ;;
            atuin__subcmd__kv,delete)
                cmd="atuin__subcmd__kv__subcmd__delete"
                ;;
            atuin__subcmd__kv,get)
                cmd="atuin__subcmd__kv__subcmd__get"
                ;;
            atuin__subcmd__kv,help)
                cmd="atuin__subcmd__kv__subcmd__help"
                ;;
            atuin__subcmd__kv,list)
                cmd="atuin__subcmd__kv__subcmd__list"
                ;;
            atuin__subcmd__kv,rebuild)
                cmd="atuin__subcmd__kv__subcmd__rebuild"
                ;;
            atuin__subcmd__kv,set)
                cmd="atuin__subcmd__kv__subcmd__set"
                ;;
            atuin__subcmd__kv__subcmd__help,delete)
                cmd="atuin__subcmd__kv__subcmd__help__subcmd__delete"
                ;;
            atuin__subcmd__kv__subcmd__help,get)
                cmd="atuin__subcmd__kv__subcmd__help__subcmd__get"
                ;;
            atuin__subcmd__kv__subcmd__help,help)
                cmd="atuin__subcmd__kv__subcmd__help__subcmd__help"
                ;;
            atuin__subcmd__kv__subcmd__help,list)
                cmd="atuin__subcmd__kv__subcmd__help__subcmd__list"
                ;;
            atuin__subcmd__kv__subcmd__help,rebuild)
                cmd="atuin__subcmd__kv__subcmd__help__subcmd__rebuild"
                ;;
            atuin__subcmd__kv__subcmd__help,set)
                cmd="atuin__subcmd__kv__subcmd__help__subcmd__set"
                ;;
            atuin__subcmd__pty__subcmd__proxy,help)
                cmd="atuin__subcmd__pty__subcmd__proxy__subcmd__help"
                ;;
            atuin__subcmd__pty__subcmd__proxy,init)
                cmd="atuin__subcmd__pty__subcmd__proxy__subcmd__init"
                ;;
            atuin__subcmd__pty__subcmd__proxy__subcmd__help,help)
                cmd="atuin__subcmd__pty__subcmd__proxy__subcmd__help__subcmd__help"
                ;;
            atuin__subcmd__pty__subcmd__proxy__subcmd__help,init)
                cmd="atuin__subcmd__pty__subcmd__proxy__subcmd__help__subcmd__init"
                ;;
            atuin__subcmd__scripts,delete)
                cmd="atuin__subcmd__scripts__subcmd__delete"
                ;;
            atuin__subcmd__scripts,edit)
                cmd="atuin__subcmd__scripts__subcmd__edit"
                ;;
            atuin__subcmd__scripts,get)
                cmd="atuin__subcmd__scripts__subcmd__get"
                ;;
            atuin__subcmd__scripts,help)
                cmd="atuin__subcmd__scripts__subcmd__help"
                ;;
            atuin__subcmd__scripts,list)
                cmd="atuin__subcmd__scripts__subcmd__list"
                ;;
            atuin__subcmd__scripts,new)
                cmd="atuin__subcmd__scripts__subcmd__new"
                ;;
            atuin__subcmd__scripts,run)
                cmd="atuin__subcmd__scripts__subcmd__run"
                ;;
            atuin__subcmd__scripts__subcmd__help,delete)
                cmd="atuin__subcmd__scripts__subcmd__help__subcmd__delete"
                ;;
            atuin__subcmd__scripts__subcmd__help,edit)
                cmd="atuin__subcmd__scripts__subcmd__help__subcmd__edit"
                ;;
            atuin__subcmd__scripts__subcmd__help,get)
                cmd="atuin__subcmd__scripts__subcmd__help__subcmd__get"
                ;;
            atuin__subcmd__scripts__subcmd__help,help)
                cmd="atuin__subcmd__scripts__subcmd__help__subcmd__help"
                ;;
            atuin__subcmd__scripts__subcmd__help,list)
                cmd="atuin__subcmd__scripts__subcmd__help__subcmd__list"
                ;;
            atuin__subcmd__scripts__subcmd__help,new)
                cmd="atuin__subcmd__scripts__subcmd__help__subcmd__new"
                ;;
            atuin__subcmd__scripts__subcmd__help,run)
                cmd="atuin__subcmd__scripts__subcmd__help__subcmd__run"
                ;;
            atuin__subcmd__store,help)
                cmd="atuin__subcmd__store__subcmd__help"
                ;;
            atuin__subcmd__store,pull)
                cmd="atuin__subcmd__store__subcmd__pull"
                ;;
            atuin__subcmd__store,purge)
                cmd="atuin__subcmd__store__subcmd__purge"
                ;;
            atuin__subcmd__store,push)
                cmd="atuin__subcmd__store__subcmd__push"
                ;;
            atuin__subcmd__store,rebuild)
                cmd="atuin__subcmd__store__subcmd__rebuild"
                ;;
            atuin__subcmd__store,rekey)
                cmd="atuin__subcmd__store__subcmd__rekey"
                ;;
            atuin__subcmd__store,status)
                cmd="atuin__subcmd__store__subcmd__status"
                ;;
            atuin__subcmd__store,verify)
                cmd="atuin__subcmd__store__subcmd__verify"
                ;;
            atuin__subcmd__store__subcmd__help,help)
                cmd="atuin__subcmd__store__subcmd__help__subcmd__help"
                ;;
            atuin__subcmd__store__subcmd__help,pull)
                cmd="atuin__subcmd__store__subcmd__help__subcmd__pull"
                ;;
            atuin__subcmd__store__subcmd__help,purge)
                cmd="atuin__subcmd__store__subcmd__help__subcmd__purge"
                ;;
            atuin__subcmd__store__subcmd__help,push)
                cmd="atuin__subcmd__store__subcmd__help__subcmd__push"
                ;;
            atuin__subcmd__store__subcmd__help,rebuild)
                cmd="atuin__subcmd__store__subcmd__help__subcmd__rebuild"
                ;;
            atuin__subcmd__store__subcmd__help,rekey)
                cmd="atuin__subcmd__store__subcmd__help__subcmd__rekey"
                ;;
            atuin__subcmd__store__subcmd__help,status)
                cmd="atuin__subcmd__store__subcmd__help__subcmd__status"
                ;;
            atuin__subcmd__store__subcmd__help,verify)
                cmd="atuin__subcmd__store__subcmd__help__subcmd__verify"
                ;;
            *)
                ;;
        esac
    done

    case "${cmd}" in
        atuin)
            opts="-h -V --help --version setup history hook import stats search sync login logout register key status account kv store dotfiles scripts init info doctor wrapped daemon default-config config ai pty-proxy uuid contributors gen-completions help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 1 ]] ; then
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
        atuin__subcmd__account)
            opts="-h --help login register logout delete change-password link help"
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
        atuin__subcmd__account__subcmd__change__subcmd__password)
            opts="-c -n -t -h --current-password --new-password --totp-code --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --current-password)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --new-password)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -n)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --totp-code)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -t)
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
        atuin__subcmd__account__subcmd__delete)
            opts="-p -t -h --password --totp-code --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --password)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --totp-code)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -t)
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
        atuin__subcmd__account__subcmd__help)
            opts="login register logout delete change-password link help"
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
        atuin__subcmd__account__subcmd__help__subcmd__change__subcmd__password)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__account__subcmd__help__subcmd__delete)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__account__subcmd__help__subcmd__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__account__subcmd__help__subcmd__link)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__account__subcmd__help__subcmd__login)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__account__subcmd__help__subcmd__logout)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__account__subcmd__help__subcmd__register)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__account__subcmd__link)
            opts="-h --help"
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
        atuin__subcmd__account__subcmd__login)
            opts="-u -p -k -t -h --username --password --key --totp-code --from-registration --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --username)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -u)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --password)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --key)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -k)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --totp-code)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -t)
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
        atuin__subcmd__account__subcmd__logout)
            opts="-h --help"
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
        atuin__subcmd__account__subcmd__register)
            opts="-u -p -e -h --username --password --email --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --username)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -u)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --password)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --email)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -e)
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
        atuin__subcmd__ai)
            opts="-h --help init inline help"
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
        atuin__subcmd__ai__subcmd__help)
            opts="init inline help"
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
        atuin__subcmd__ai__subcmd__help__subcmd__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__ai__subcmd__help__subcmd__init)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__ai__subcmd__help__subcmd__inline)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__ai__subcmd__init)
            opts="-h --help [SHELL]"
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
        atuin__subcmd__ai__subcmd__inline)
            opts="-v -h --verbose --api-endpoint --api-token --hook --help [COMMAND]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --api-endpoint)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --api-token)
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
        atuin__subcmd__config)
            opts="-h --help get set print help"
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
        atuin__subcmd__config__subcmd__get)
            opts="-r -v -h --resolved --verbose --help <KEY>"
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
        atuin__subcmd__config__subcmd__help)
            opts="get set print help"
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
        atuin__subcmd__config__subcmd__help__subcmd__get)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__config__subcmd__help__subcmd__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__config__subcmd__help__subcmd__print)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__config__subcmd__help__subcmd__set)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__config__subcmd__print)
            opts="-h --help [KEY]"
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
        atuin__subcmd__config__subcmd__set)
            opts="-t -h --type --help <KEY> <VALUE>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --type)
                    COMPREPLY=($(compgen -W "auto string boolean integer float" -- "${cur}"))
                    return 0
                    ;;
                -t)
                    COMPREPLY=($(compgen -W "auto string boolean integer float" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        atuin__subcmd__contributors)
            opts="-h --help"
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
        atuin__subcmd__daemon)
            opts="-h --daemonize --show-logs --help start status stop restart help"
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
        atuin__subcmd__daemon__subcmd__help)
            opts="start status stop restart help"
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
        atuin__subcmd__daemon__subcmd__help__subcmd__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__daemon__subcmd__help__subcmd__restart)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__daemon__subcmd__help__subcmd__start)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__daemon__subcmd__help__subcmd__status)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__daemon__subcmd__help__subcmd__stop)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__daemon__subcmd__restart)
            opts="-h --help"
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
        atuin__subcmd__daemon__subcmd__start)
            opts="-h --daemonize --show-logs --force --help"
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
        atuin__subcmd__daemon__subcmd__status)
            opts="-h --help"
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
        atuin__subcmd__daemon__subcmd__stop)
            opts="-h --help"
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
        atuin__subcmd__default__subcmd__config)
            opts="-h --help"
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
        atuin__subcmd__doctor)
            opts="-h --help"
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
        atuin__subcmd__dotfiles)
            opts="-h --help alias var help"
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
        atuin__subcmd__dotfiles__subcmd__alias)
            opts="-h --help set delete list clear help"
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
        atuin__subcmd__dotfiles__subcmd__alias__subcmd__clear)
            opts="-h --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__alias__subcmd__delete)
            opts="-h --help <NAME>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__alias__subcmd__help)
            opts="set delete list clear help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__alias__subcmd__help__subcmd__clear)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__alias__subcmd__help__subcmd__delete)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__alias__subcmd__help__subcmd__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__alias__subcmd__help__subcmd__list)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__alias__subcmd__help__subcmd__set)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__alias__subcmd__list)
            opts="-r -n -v -h --sort-by --reverse --name --value --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --sort-by)
                    COMPREPLY=($(compgen -W "name value" -- "${cur}"))
                    return 0
                    ;;
                --name)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -n)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --value)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -v)
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
        atuin__subcmd__dotfiles__subcmd__alias__subcmd__set)
            opts="-h --help <NAME> <VALUE>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__help)
            opts="alias var help"
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
        atuin__subcmd__dotfiles__subcmd__help__subcmd__alias)
            opts="set delete list clear"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__help__subcmd__alias__subcmd__clear)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__help__subcmd__alias__subcmd__delete)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__help__subcmd__alias__subcmd__list)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__help__subcmd__alias__subcmd__set)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__help__subcmd__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__help__subcmd__var)
            opts="set delete list"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__help__subcmd__var__subcmd__delete)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__help__subcmd__var__subcmd__list)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__help__subcmd__var__subcmd__set)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__var)
            opts="-h --help set delete list help"
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
        atuin__subcmd__dotfiles__subcmd__var__subcmd__delete)
            opts="-h --help <NAME>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__var__subcmd__help)
            opts="set delete list help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__var__subcmd__help__subcmd__delete)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__var__subcmd__help__subcmd__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__var__subcmd__help__subcmd__list)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__var__subcmd__help__subcmd__set)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__dotfiles__subcmd__var__subcmd__list)
            opts="-r -n -v -h --sort-by --reverse --name --value --exports-only --shell-only --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --sort-by)
                    COMPREPLY=($(compgen -W "name value" -- "${cur}"))
                    return 0
                    ;;
                --name)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -n)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --value)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -v)
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
        atuin__subcmd__dotfiles__subcmd__var__subcmd__set)
            opts="-n -h --no-export --help <NAME> <VALUE>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__gen__subcmd__completions)
            opts="-s -o -h --shell --out-dir --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --shell)
                    COMPREPLY=($(compgen -W "bash elvish fish nushell powershell zsh" -- "${cur}"))
                    return 0
                    ;;
                -s)
                    COMPREPLY=($(compgen -W "bash elvish fish nushell powershell zsh" -- "${cur}"))
                    return 0
                    ;;
                --out-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -o)
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
        atuin__subcmd__help)
            opts="setup history hook import stats search sync login logout register key status account kv store dotfiles scripts init info doctor wrapped daemon default-config config ai pty-proxy uuid contributors gen-completions help"
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
        atuin__subcmd__help__subcmd__account)
            opts="login register logout delete change-password link"
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
        atuin__subcmd__help__subcmd__account__subcmd__change__subcmd__password)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__account__subcmd__delete)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__account__subcmd__link)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__account__subcmd__login)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__account__subcmd__logout)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__account__subcmd__register)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__ai)
            opts="init inline"
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
        atuin__subcmd__help__subcmd__ai__subcmd__init)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__ai__subcmd__inline)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__config)
            opts="get set print"
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
        atuin__subcmd__help__subcmd__config__subcmd__get)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__config__subcmd__print)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__config__subcmd__set)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__contributors)
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
        atuin__subcmd__help__subcmd__daemon)
            opts="start status stop restart"
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
        atuin__subcmd__help__subcmd__daemon__subcmd__restart)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__daemon__subcmd__start)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__daemon__subcmd__status)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__daemon__subcmd__stop)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__default__subcmd__config)
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
        atuin__subcmd__help__subcmd__doctor)
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
        atuin__subcmd__help__subcmd__dotfiles)
            opts="alias var"
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
        atuin__subcmd__help__subcmd__dotfiles__subcmd__alias)
            opts="set delete list clear"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__dotfiles__subcmd__alias__subcmd__clear)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__help__subcmd__dotfiles__subcmd__alias__subcmd__delete)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__help__subcmd__dotfiles__subcmd__alias__subcmd__list)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__help__subcmd__dotfiles__subcmd__alias__subcmd__set)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__help__subcmd__dotfiles__subcmd__var)
            opts="set delete list"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__dotfiles__subcmd__var__subcmd__delete)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__help__subcmd__dotfiles__subcmd__var__subcmd__list)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__help__subcmd__dotfiles__subcmd__var__subcmd__set)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 5 ]] ; then
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
        atuin__subcmd__help__subcmd__gen__subcmd__completions)
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
        atuin__subcmd__help__subcmd__help)
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
        atuin__subcmd__help__subcmd__history)
            opts="start end tail list last init-store prune dedup"
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
        atuin__subcmd__help__subcmd__history__subcmd__dedup)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__history__subcmd__end)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__history__subcmd__init__subcmd__store)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__history__subcmd__last)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__history__subcmd__list)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__history__subcmd__prune)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__history__subcmd__start)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__history__subcmd__tail)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__hook)
            opts="install"
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
        atuin__subcmd__help__subcmd__hook__subcmd__install)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__import)
            opts="auto zsh zsh-hist-db bash replxx resh fish nu nu-hist-db xonsh xonsh-sqlite powershell"
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
        atuin__subcmd__help__subcmd__import__subcmd__auto)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__import__subcmd__bash)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__import__subcmd__fish)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__import__subcmd__nu)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__import__subcmd__nu__subcmd__hist__subcmd__db)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__import__subcmd__powershell)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__import__subcmd__replxx)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__import__subcmd__resh)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__import__subcmd__xonsh)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__import__subcmd__xonsh__subcmd__sqlite)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__import__subcmd__zsh)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__import__subcmd__zsh__subcmd__hist__subcmd__db)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__info)
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
        atuin__subcmd__help__subcmd__init)
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
        atuin__subcmd__help__subcmd__key)
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
        atuin__subcmd__help__subcmd__kv)
            opts="set delete get list rebuild"
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
        atuin__subcmd__help__subcmd__kv__subcmd__delete)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__kv__subcmd__get)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__kv__subcmd__list)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__kv__subcmd__rebuild)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__kv__subcmd__set)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__login)
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
        atuin__subcmd__help__subcmd__logout)
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
        atuin__subcmd__help__subcmd__pty__subcmd__proxy)
            opts="init"
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
        atuin__subcmd__help__subcmd__pty__subcmd__proxy__subcmd__init)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__register)
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
        atuin__subcmd__help__subcmd__scripts)
            opts="new run list get edit delete"
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
        atuin__subcmd__help__subcmd__scripts__subcmd__delete)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__scripts__subcmd__edit)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__scripts__subcmd__get)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__scripts__subcmd__list)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__scripts__subcmd__new)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__scripts__subcmd__run)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__search)
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
        atuin__subcmd__help__subcmd__setup)
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
        atuin__subcmd__help__subcmd__stats)
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
        atuin__subcmd__help__subcmd__status)
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
        atuin__subcmd__help__subcmd__store)
            opts="status rebuild rekey purge verify push pull"
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
        atuin__subcmd__help__subcmd__store__subcmd__pull)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__store__subcmd__purge)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__store__subcmd__push)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__store__subcmd__rebuild)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__store__subcmd__rekey)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__store__subcmd__status)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__store__subcmd__verify)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__help__subcmd__sync)
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
        atuin__subcmd__help__subcmd__uuid)
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
        atuin__subcmd__help__subcmd__wrapped)
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
        atuin__subcmd__history)
            opts="-h --help start end tail list last init-store prune dedup help"
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
        atuin__subcmd__history__subcmd__dedup)
            opts="-n -b -h --dry-run --before --dupkeep --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --before)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -b)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --dupkeep)
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
        atuin__subcmd__history__subcmd__end)
            opts="-e -d -h --exit --duration --help <ID>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --exit)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -e)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --duration)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -d)
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
        atuin__subcmd__history__subcmd__help)
            opts="start end tail list last init-store prune dedup help"
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
        atuin__subcmd__history__subcmd__help__subcmd__dedup)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__history__subcmd__help__subcmd__end)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__history__subcmd__help__subcmd__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__history__subcmd__help__subcmd__init__subcmd__store)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__history__subcmd__help__subcmd__last)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__history__subcmd__help__subcmd__list)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__history__subcmd__help__subcmd__prune)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__history__subcmd__help__subcmd__start)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__history__subcmd__help__subcmd__tail)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__history__subcmd__init__subcmd__store)
            opts="-h --help"
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
        atuin__subcmd__history__subcmd__last)
            opts="-f -h --human --cmd-only --tz --timezone --format --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --timezone)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --tz)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --format)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
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
        atuin__subcmd__history__subcmd__list)
            opts="-c -s -r -f -h --cwd --session --human --cmd-only --print0 --reverse --tz --timezone --format --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --reverse)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --timezone)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --tz)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --format)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
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
        atuin__subcmd__history__subcmd__prune)
            opts="-n -h --dry-run --help"
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
        atuin__subcmd__history__subcmd__start)
            opts="-h --command-from-env --author --intent --help [COMMAND]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --author)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --intent)
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
        atuin__subcmd__history__subcmd__tail)
            opts="-h --help"
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
        atuin__subcmd__hook)
            opts="-h --help [AGENT] install help"
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
        atuin__subcmd__hook__subcmd__help)
            opts="install help"
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
        atuin__subcmd__hook__subcmd__help__subcmd__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__hook__subcmd__help__subcmd__install)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__hook__subcmd__install)
            opts="-h --help <AGENT>"
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
        atuin__subcmd__import)
            opts="-h --help auto zsh zsh-hist-db bash replxx resh fish nu nu-hist-db xonsh xonsh-sqlite powershell help"
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
        atuin__subcmd__import__subcmd__auto)
            opts="-h --help"
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
        atuin__subcmd__import__subcmd__bash)
            opts="-h --help"
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
        atuin__subcmd__import__subcmd__fish)
            opts="-h --help"
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
        atuin__subcmd__import__subcmd__help)
            opts="auto zsh zsh-hist-db bash replxx resh fish nu nu-hist-db xonsh xonsh-sqlite powershell help"
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
        atuin__subcmd__import__subcmd__help__subcmd__auto)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__import__subcmd__help__subcmd__bash)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__import__subcmd__help__subcmd__fish)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__import__subcmd__help__subcmd__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__import__subcmd__help__subcmd__nu)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__import__subcmd__help__subcmd__nu__subcmd__hist__subcmd__db)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__import__subcmd__help__subcmd__powershell)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__import__subcmd__help__subcmd__replxx)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__import__subcmd__help__subcmd__resh)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__import__subcmd__help__subcmd__xonsh)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__import__subcmd__help__subcmd__xonsh__subcmd__sqlite)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__import__subcmd__help__subcmd__zsh)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__import__subcmd__help__subcmd__zsh__subcmd__hist__subcmd__db)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__import__subcmd__nu)
            opts="-h --help"
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
        atuin__subcmd__import__subcmd__nu__subcmd__hist__subcmd__db)
            opts="-h --help"
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
        atuin__subcmd__import__subcmd__powershell)
            opts="-h --help"
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
        atuin__subcmd__import__subcmd__replxx)
            opts="-h --help"
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
        atuin__subcmd__import__subcmd__resh)
            opts="-h --help"
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
        atuin__subcmd__import__subcmd__xonsh)
            opts="-h --help"
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
        atuin__subcmd__import__subcmd__xonsh__subcmd__sqlite)
            opts="-h --help"
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
        atuin__subcmd__import__subcmd__zsh)
            opts="-h --help"
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
        atuin__subcmd__import__subcmd__zsh__subcmd__hist__subcmd__db)
            opts="-h --help"
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
        atuin__subcmd__info)
            opts="-h --help"
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
        atuin__subcmd__init)
            opts="-h --disable-ctrl-r --disable-up-arrow --disable-ai --help zsh bash fish nu xonsh powershell"
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
        atuin__subcmd__key)
            opts="-h --base64 --help"
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
        atuin__subcmd__kv)
            opts="-h --help set delete get list rebuild help"
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
        atuin__subcmd__kv__subcmd__delete)
            opts="-n -h --namespace --help <KEYS>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --namespace)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -n)
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
        atuin__subcmd__kv__subcmd__get)
            opts="-n -h --namespace --help <KEY>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --namespace)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -n)
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
        atuin__subcmd__kv__subcmd__help)
            opts="set delete get list rebuild help"
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
        atuin__subcmd__kv__subcmd__help__subcmd__delete)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__kv__subcmd__help__subcmd__get)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__kv__subcmd__help__subcmd__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__kv__subcmd__help__subcmd__list)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__kv__subcmd__help__subcmd__rebuild)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__kv__subcmd__help__subcmd__set)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__kv__subcmd__list)
            opts="-n -a -h --namespace --all-namespaces --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --namespace)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -n)
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
        atuin__subcmd__kv__subcmd__rebuild)
            opts="-h --help"
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
        atuin__subcmd__kv__subcmd__set)
            opts="-k -n -h --key --namespace --help [VALUE]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --key)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -k)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --namespace)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -n)
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
        atuin__subcmd__login)
            opts="-u -p -k -t -h --username --password --key --totp-code --from-registration --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --username)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -u)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --password)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --key)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -k)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --totp-code)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -t)
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
        atuin__subcmd__logout)
            opts="-h --help"
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
        atuin__subcmd__pty__subcmd__proxy)
            opts="-h --help init help"
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
        atuin__subcmd__pty__subcmd__proxy__subcmd__help)
            opts="init help"
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
        atuin__subcmd__pty__subcmd__proxy__subcmd__help__subcmd__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__pty__subcmd__proxy__subcmd__help__subcmd__init)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__pty__subcmd__proxy__subcmd__init)
            opts="-h --help zsh bash fish nu"
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
        atuin__subcmd__register)
            opts="-u -p -e -h --username --password --email --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --username)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -u)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --password)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --email)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -e)
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
        atuin__subcmd__scripts)
            opts="-h --help new run list get edit delete help"
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
        atuin__subcmd__scripts__subcmd__delete)
            opts="-f -h --force --help <NAME>"
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
        atuin__subcmd__scripts__subcmd__edit)
            opts="-d -t -s -h --description --tags --no-tags --rename --shebang --script --no-edit --help <NAME>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --description)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -d)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --tags)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -t)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --rename)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --shebang)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -s)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --script)
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
        atuin__subcmd__scripts__subcmd__get)
            opts="-s -h --script --help <NAME>"
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
        atuin__subcmd__scripts__subcmd__help)
            opts="new run list get edit delete help"
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
        atuin__subcmd__scripts__subcmd__help__subcmd__delete)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__scripts__subcmd__help__subcmd__edit)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__scripts__subcmd__help__subcmd__get)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__scripts__subcmd__help__subcmd__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__scripts__subcmd__help__subcmd__list)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__scripts__subcmd__help__subcmd__new)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__scripts__subcmd__help__subcmd__run)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__scripts__subcmd__list)
            opts="-h --help"
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
        atuin__subcmd__scripts__subcmd__new)
            opts="-d -t -s -h --description --tags --shebang --script --last --no-edit --help <NAME>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --description)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -d)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --tags)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -t)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --shebang)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -s)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --script)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --last)
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
        atuin__subcmd__scripts__subcmd__run)
            opts="-v -h --var --help <NAME>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --var)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -v)
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
        atuin__subcmd__search)
            opts="-c -e -b -i -r -f -h --cwd --exclude-cwd --exit --exclude-exit --before --after --limit --offset --interactive --filter-mode --search-mode --shell-up-key-binding --keymap-mode --human --cmd-only --print0 --delete --delete-it-all --reverse --tz --timezone --format --inline-height --author --include-duplicates --result-file --help [QUERY]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cwd)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --exclude-cwd)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --exit)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -e)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --exclude-exit)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --before)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -b)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --after)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --limit)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --offset)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --filter-mode)
                    COMPREPLY=($(compgen -W "global host session directory workspace session-preload" -- "${cur}"))
                    return 0
                    ;;
                --search-mode)
                    COMPREPLY=($(compgen -W "prefix full-text fuzzy skim daemon-fuzzy" -- "${cur}"))
                    return 0
                    ;;
                --keymap-mode)
                    COMPREPLY=($(compgen -W "emacs vim-normal vim-insert auto" -- "${cur}"))
                    return 0
                    ;;
                --timezone)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --tz)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --format)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inline-height)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --author)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --result-file)
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
        atuin__subcmd__setup)
            opts="-h --help"
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
        atuin__subcmd__stats)
            opts="-c -n -h --count --ngram-size --help [PERIOD]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --count)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --ngram-size)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -n)
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
        atuin__subcmd__status)
            opts="-h --help"
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
        atuin__subcmd__store)
            opts="-h --help status rebuild rekey purge verify push pull help"
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
        atuin__subcmd__store__subcmd__help)
            opts="status rebuild rekey purge verify push pull help"
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
        atuin__subcmd__store__subcmd__help__subcmd__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__store__subcmd__help__subcmd__pull)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__store__subcmd__help__subcmd__purge)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__store__subcmd__help__subcmd__push)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__store__subcmd__help__subcmd__rebuild)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__store__subcmd__help__subcmd__rekey)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__store__subcmd__help__subcmd__status)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__store__subcmd__help__subcmd__verify)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
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
        atuin__subcmd__store__subcmd__pull)
            opts="-t -h --tag --force --page --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --tag)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -t)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --page)
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
        atuin__subcmd__store__subcmd__purge)
            opts="-h --help"
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
        atuin__subcmd__store__subcmd__push)
            opts="-t -h --tag --host --force --page --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --tag)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -t)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --page)
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
        atuin__subcmd__store__subcmd__rebuild)
            opts="-h --help <TAG>"
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
        atuin__subcmd__store__subcmd__rekey)
            opts="-h --help [KEY]"
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
        atuin__subcmd__store__subcmd__status)
            opts="-h --help"
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
        atuin__subcmd__store__subcmd__verify)
            opts="-h --help"
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
        atuin__subcmd__sync)
            opts="-f -h --force --help"
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
        atuin__subcmd__uuid)
            opts="-h --help"
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
        atuin__subcmd__wrapped)
            opts="-h --help [YEAR]"
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
    esac
}

if [[ "${BASH_VERSINFO[0]}" -eq 4 && "${BASH_VERSINFO[1]}" -ge 4 || "${BASH_VERSINFO[0]}" -gt 4 ]]; then
    complete -F _atuin -o nosort -o bashdefault -o default atuin
else
    complete -F _atuin -o bashdefault -o default atuin
fi
