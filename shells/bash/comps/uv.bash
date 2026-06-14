# shellcheck shell=bash disable=SC2207

_uv() {
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
                cmd="uv"
                ;;
            uv,add)
                cmd="uv__subcmd__add"
                ;;
            uv,audit)
                cmd="uv__subcmd__audit"
                ;;
            uv,auth)
                cmd="uv__subcmd__auth"
                ;;
            uv,build)
                cmd="uv__subcmd__build"
                ;;
            uv,build-backend)
                cmd="uv__subcmd__build__subcmd__backend"
                ;;
            uv,cache)
                cmd="uv__subcmd__cache"
                ;;
            uv,check)
                cmd="uv__subcmd__check"
                ;;
            uv,clean)
                cmd="uv__subcmd__clean"
                ;;
            uv,export)
                cmd="uv__subcmd__export"
                ;;
            uv,format)
                cmd="uv__subcmd__format"
                ;;
            uv,generate-shell-completion)
                cmd="uv__subcmd__generate__subcmd__shell__subcmd__completion"
                ;;
            uv,help)
                cmd="uv__subcmd__help"
                ;;
            uv,init)
                cmd="uv__subcmd__init"
                ;;
            uv,lock)
                cmd="uv__subcmd__lock"
                ;;
            uv,pip)
                cmd="uv__subcmd__pip"
                ;;
            uv,publish)
                cmd="uv__subcmd__publish"
                ;;
            uv,python)
                cmd="uv__subcmd__python"
                ;;
            uv,remove)
                cmd="uv__subcmd__remove"
                ;;
            uv,run)
                cmd="uv__subcmd__run"
                ;;
            uv,self)
                cmd="uv__subcmd__self"
                ;;
            uv,sync)
                cmd="uv__subcmd__sync"
                ;;
            uv,tool)
                cmd="uv__subcmd__tool"
                ;;
            uv,tree)
                cmd="uv__subcmd__tree"
                ;;
            uv,venv)
                cmd="uv__subcmd__venv"
                ;;
            uv,version)
                cmd="uv__subcmd__version"
                ;;
            uv,workspace)
                cmd="uv__subcmd__workspace"
                ;;
            uv__subcmd__auth,dir)
                cmd="uv__subcmd__auth__subcmd__dir"
                ;;
            uv__subcmd__auth,helper)
                cmd="uv__subcmd__auth__subcmd__helper"
                ;;
            uv__subcmd__auth,login)
                cmd="uv__subcmd__auth__subcmd__login"
                ;;
            uv__subcmd__auth,logout)
                cmd="uv__subcmd__auth__subcmd__logout"
                ;;
            uv__subcmd__auth,token)
                cmd="uv__subcmd__auth__subcmd__token"
                ;;
            uv__subcmd__auth__subcmd__helper,get)
                cmd="uv__subcmd__auth__subcmd__helper__subcmd__get"
                ;;
            uv__subcmd__build__subcmd__backend,build-editable)
                cmd="uv__subcmd__build__subcmd__backend__subcmd__build__subcmd__editable"
                ;;
            uv__subcmd__build__subcmd__backend,build-sdist)
                cmd="uv__subcmd__build__subcmd__backend__subcmd__build__subcmd__sdist"
                ;;
            uv__subcmd__build__subcmd__backend,build-wheel)
                cmd="uv__subcmd__build__subcmd__backend__subcmd__build__subcmd__wheel"
                ;;
            uv__subcmd__build__subcmd__backend,get-requires-for-build-editable)
                cmd="uv__subcmd__build__subcmd__backend__subcmd__get__subcmd__requires__subcmd__for__subcmd__build__subcmd__editable"
                ;;
            uv__subcmd__build__subcmd__backend,get-requires-for-build-sdist)
                cmd="uv__subcmd__build__subcmd__backend__subcmd__get__subcmd__requires__subcmd__for__subcmd__build__subcmd__sdist"
                ;;
            uv__subcmd__build__subcmd__backend,get-requires-for-build-wheel)
                cmd="uv__subcmd__build__subcmd__backend__subcmd__get__subcmd__requires__subcmd__for__subcmd__build__subcmd__wheel"
                ;;
            uv__subcmd__build__subcmd__backend,prepare-metadata-for-build-editable)
                cmd="uv__subcmd__build__subcmd__backend__subcmd__prepare__subcmd__metadata__subcmd__for__subcmd__build__subcmd__editable"
                ;;
            uv__subcmd__build__subcmd__backend,prepare-metadata-for-build-wheel)
                cmd="uv__subcmd__build__subcmd__backend__subcmd__prepare__subcmd__metadata__subcmd__for__subcmd__build__subcmd__wheel"
                ;;
            uv__subcmd__cache,clean)
                cmd="uv__subcmd__cache__subcmd__clean"
                ;;
            uv__subcmd__cache,dir)
                cmd="uv__subcmd__cache__subcmd__dir"
                ;;
            uv__subcmd__cache,prune)
                cmd="uv__subcmd__cache__subcmd__prune"
                ;;
            uv__subcmd__cache,size)
                cmd="uv__subcmd__cache__subcmd__size"
                ;;
            uv__subcmd__pip,check)
                cmd="uv__subcmd__pip__subcmd__check"
                ;;
            uv__subcmd__pip,compile)
                cmd="uv__subcmd__pip__subcmd__compile"
                ;;
            uv__subcmd__pip,debug)
                cmd="uv__subcmd__pip__subcmd__debug"
                ;;
            uv__subcmd__pip,freeze)
                cmd="uv__subcmd__pip__subcmd__freeze"
                ;;
            uv__subcmd__pip,install)
                cmd="uv__subcmd__pip__subcmd__install"
                ;;
            uv__subcmd__pip,list)
                cmd="uv__subcmd__pip__subcmd__list"
                ;;
            uv__subcmd__pip,show)
                cmd="uv__subcmd__pip__subcmd__show"
                ;;
            uv__subcmd__pip,sync)
                cmd="uv__subcmd__pip__subcmd__sync"
                ;;
            uv__subcmd__pip,tree)
                cmd="uv__subcmd__pip__subcmd__tree"
                ;;
            uv__subcmd__pip,uninstall)
                cmd="uv__subcmd__pip__subcmd__uninstall"
                ;;
            uv__subcmd__python,dir)
                cmd="uv__subcmd__python__subcmd__dir"
                ;;
            uv__subcmd__python,find)
                cmd="uv__subcmd__python__subcmd__find"
                ;;
            uv__subcmd__python,install)
                cmd="uv__subcmd__python__subcmd__install"
                ;;
            uv__subcmd__python,list)
                cmd="uv__subcmd__python__subcmd__list"
                ;;
            uv__subcmd__python,pin)
                cmd="uv__subcmd__python__subcmd__pin"
                ;;
            uv__subcmd__python,uninstall)
                cmd="uv__subcmd__python__subcmd__uninstall"
                ;;
            uv__subcmd__python,update-shell)
                cmd="uv__subcmd__python__subcmd__update__subcmd__shell"
                ;;
            uv__subcmd__python,upgrade)
                cmd="uv__subcmd__python__subcmd__upgrade"
                ;;
            uv__subcmd__self,update)
                cmd="uv__subcmd__self__subcmd__update"
                ;;
            uv__subcmd__self,version)
                cmd="uv__subcmd__self__subcmd__version"
                ;;
            uv__subcmd__tool,dir)
                cmd="uv__subcmd__tool__subcmd__dir"
                ;;
            uv__subcmd__tool,install)
                cmd="uv__subcmd__tool__subcmd__install"
                ;;
            uv__subcmd__tool,list)
                cmd="uv__subcmd__tool__subcmd__list"
                ;;
            uv__subcmd__tool,run)
                cmd="uv__subcmd__tool__subcmd__run"
                ;;
            uv__subcmd__tool,uninstall)
                cmd="uv__subcmd__tool__subcmd__uninstall"
                ;;
            uv__subcmd__tool,update-shell)
                cmd="uv__subcmd__tool__subcmd__update__subcmd__shell"
                ;;
            uv__subcmd__tool,upgrade)
                cmd="uv__subcmd__tool__subcmd__upgrade"
                ;;
            uv__subcmd__tool,uvx)
                cmd="uv__subcmd__tool__subcmd__uvx"
                ;;
            uv__subcmd__workspace,dir)
                cmd="uv__subcmd__workspace__subcmd__dir"
                ;;
            uv__subcmd__workspace,list)
                cmd="uv__subcmd__workspace__subcmd__list"
                ;;
            uv__subcmd__workspace,metadata)
                cmd="uv__subcmd__workspace__subcmd__metadata"
                ;;
            *)
                ;;
        esac
    done

    case "${cmd}" in
        uv)
            opts="-n -q -v -h -V --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help --version auth run init add remove version sync lock export tree format check audit tool python pip venv build publish workspace build-backend cache self clean generate-shell-completion help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 1 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__add)
            opts="-r -c -m -i -f -U -P -C -p -n -q -v -h --requirements --constraints --marker --dev --optional --group --editable --no-editable --no-editable-package --raw --bounds --rev --tag --branch --lfs --extra --no-sync --locked --frozen --active --no-active --index --default-index --index-url --extra-index-url --find-links --no-index --upgrade --no-upgrade --upgrade-package --upgrade-group --reinstall --no-reinstall --reinstall-package --index-strategy --keyring-provider --resolution --prerelease --pre --fork-strategy --config-setting --config-settings-package --no-build-isolation --no-build-isolation-package --build-isolation --exclude-newer --exclude-newer-package --link-mode --compile-bytecode --no-compile-bytecode --no-sources --no-sources-package --no-build --build --no-build-package --no-binary --binary --no-binary-package --refresh --no-refresh --refresh-package --package --script --python --workspace --no-workspace --no-install-project --only-install-project --no-install-workspace --only-install-workspace --no-install-local --only-install-local --no-install-package --only-install-package --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help [PACKAGES]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --requirements)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                -r)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --constraints)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                -c)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --marker)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -m)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --optional)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --group)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-editable-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --bounds)
                    COMPREPLY=($(compgen -W "lower major minor exact" -- "${cur}"))
                    return 0
                    ;;
                --rev)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --tag)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --branch)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --extra)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -P)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --upgrade-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reinstall-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --resolution)
                    COMPREPLY=($(compgen -W "highest lowest lowest-direct" -- "${cur}"))
                    return 0
                    ;;
                --prerelease)
                    COMPREPLY=($(compgen -W "disallow allow if-necessary explicit if-necessary-or-explicit" -- "${cur}"))
                    return 0
                    ;;
                --fork-strategy)
                    COMPREPLY=($(compgen -W "fewest requires-python" -- "${cur}"))
                    return 0
                    ;;
                --config-setting)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -C)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --config-settings-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-build-isolation-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --link-mode)
                    COMPREPLY=($(compgen -W "clone copy hardlink symlink" -- "${cur}"))
                    return 0
                    ;;
                --no-sources-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-binary-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --refresh-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --script)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-install-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --only-install-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__audit)
            opts="-i -f -U -P -C -n -q -v -h --no-extra --no-dev --no-group --no-default-groups --only-group --only-dev --locked --frozen --output-format --no-build --build --no-build-package --no-binary --binary --no-binary-package --index --default-index --index-url --extra-index-url --find-links --no-index --upgrade --no-upgrade --upgrade-package --upgrade-group --index-strategy --keyring-provider --resolution --prerelease --pre --fork-strategy --config-setting --config-settings-package --no-build-isolation --no-build-isolation-package --build-isolation --exclude-newer --exclude-newer-package --link-mode --no-sources --no-sources-package --script --python-version --python-platform --ignore --ignore-until-fixed --service-format --service-url --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --no-extra)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-group)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --only-group)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --output-format)
                    COMPREPLY=($(compgen -W "text json" -- "${cur}"))
                    return 0
                    ;;
                --no-build-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-binary-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -P)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --resolution)
                    COMPREPLY=($(compgen -W "highest lowest lowest-direct" -- "${cur}"))
                    return 0
                    ;;
                --prerelease)
                    COMPREPLY=($(compgen -W "disallow allow if-necessary explicit if-necessary-or-explicit" -- "${cur}"))
                    return 0
                    ;;
                --fork-strategy)
                    COMPREPLY=($(compgen -W "fewest requires-python" -- "${cur}"))
                    return 0
                    ;;
                --config-setting)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -C)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config-settings-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-isolation-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --exclude-newer-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --link-mode)
                    COMPREPLY=($(compgen -W "clone copy hardlink symlink" -- "${cur}"))
                    return 0
                    ;;
                --no-sources-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --script)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --python-version)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --python-platform)
                    COMPREPLY=($(compgen -W "windows linux macos x86_64-pc-windows-msvc aarch64-pc-windows-msvc i686-pc-windows-msvc x86_64-unknown-linux-gnu aarch64-apple-darwin x86_64-apple-darwin aarch64-unknown-linux-gnu aarch64-unknown-linux-musl x86_64-unknown-linux-musl riscv64-unknown-linux x86_64-manylinux2014 x86_64-manylinux_2_17 x86_64-manylinux_2_28 x86_64-manylinux_2_31 x86_64-manylinux_2_32 x86_64-manylinux_2_33 x86_64-manylinux_2_34 x86_64-manylinux_2_35 x86_64-manylinux_2_36 x86_64-manylinux_2_37 x86_64-manylinux_2_38 x86_64-manylinux_2_39 x86_64-manylinux_2_40 aarch64-manylinux2014 aarch64-manylinux_2_17 aarch64-manylinux_2_28 aarch64-manylinux_2_31 aarch64-manylinux_2_32 aarch64-manylinux_2_33 aarch64-manylinux_2_34 aarch64-manylinux_2_35 aarch64-manylinux_2_36 aarch64-manylinux_2_37 aarch64-manylinux_2_38 aarch64-manylinux_2_39 aarch64-manylinux_2_40 aarch64-linux-android x86_64-linux-android wasm32-pyodide2024 wasm32-pyodide2025 arm64-apple-ios arm64-apple-ios-simulator x86_64-apple-ios-simulator" -- "${cur}"))
                    return 0
                    ;;
                --ignore)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --ignore-until-fixed)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --service-format)
                    COMPREPLY=($(compgen -W "osv" -- "${cur}"))
                    return 0
                    ;;
                --service-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__auth)
            opts="-n -q -v -h --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help login logout token dir helper"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__auth__subcmd__dir)
            opts="-n -q -v -h --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help [SERVICE]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__auth__subcmd__helper)
            opts="-n -q -v -h --protocol --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help get"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --protocol)
                    COMPREPLY=($(compgen -W "bazel" -- "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__auth__subcmd__helper__subcmd__get)
            opts="-n -q -v -h --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__auth__subcmd__login)
            opts="-u -t -n -q -v -h --username --password --token --keyring-provider --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help <SERVICE>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --username)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -u)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --password)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --token)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -t)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__auth__subcmd__logout)
            opts="-u -n -q -v -h --username --keyring-provider --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help <SERVICE>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --username)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -u)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__auth__subcmd__token)
            opts="-u -n -q -v -h --username --keyring-provider --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help <SERVICE>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --username)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -u)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__build)
            opts="-o -b -p -i -f -U -P -C -n -q -v -h --package --all-packages --out-dir --sdist --wheel --list --build-logs --no-build-logs --force-pep517 --clear --create-gitignore --no-create-gitignore --build-constraints --require-hashes --no-require-hashes --verify-hashes --no-verify-hashes --python --index --default-index --index-url --extra-index-url --find-links --no-index --upgrade --no-upgrade --upgrade-package --upgrade-group --index-strategy --keyring-provider --resolution --prerelease --pre --fork-strategy --config-setting --config-settings-package --no-build-isolation --no-build-isolation-package --build-isolation --exclude-newer --exclude-newer-package --link-mode --no-sources --no-sources-package --no-build --build --no-build-package --no-binary --binary --no-binary-package --refresh --no-refresh --refresh-package --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help [SRC]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --out-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                -o)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --build-constraints)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                -b)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -P)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --resolution)
                    COMPREPLY=($(compgen -W "highest lowest lowest-direct" -- "${cur}"))
                    return 0
                    ;;
                --prerelease)
                    COMPREPLY=($(compgen -W "disallow allow if-necessary explicit if-necessary-or-explicit" -- "${cur}"))
                    return 0
                    ;;
                --fork-strategy)
                    COMPREPLY=($(compgen -W "fewest requires-python" -- "${cur}"))
                    return 0
                    ;;
                --config-setting)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -C)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config-settings-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-isolation-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --exclude-newer-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --link-mode)
                    COMPREPLY=($(compgen -W "clone copy hardlink symlink" -- "${cur}"))
                    return 0
                    ;;
                --no-sources-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-binary-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --refresh-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__build__subcmd__backend)
            opts="-n -q -v -h --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help build-sdist build-wheel build-editable get-requires-for-build-sdist get-requires-for-build-wheel prepare-metadata-for-build-wheel get-requires-for-build-editable prepare-metadata-for-build-editable"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__build__subcmd__backend__subcmd__build__subcmd__editable)
            opts="-n -q -v -h --metadata-directory --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help <WHEEL_DIRECTORY>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --metadata-directory)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__build__subcmd__backend__subcmd__build__subcmd__sdist)
            opts="-n -q -v -h --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help <SDIST_DIRECTORY>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__build__subcmd__backend__subcmd__build__subcmd__wheel)
            opts="-n -q -v -h --metadata-directory --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help <WHEEL_DIRECTORY>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --metadata-directory)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__build__subcmd__backend__subcmd__get__subcmd__requires__subcmd__for__subcmd__build__subcmd__editable)
            opts="-n -q -v -h --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__build__subcmd__backend__subcmd__get__subcmd__requires__subcmd__for__subcmd__build__subcmd__sdist)
            opts="-n -q -v -h --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__build__subcmd__backend__subcmd__get__subcmd__requires__subcmd__for__subcmd__build__subcmd__wheel)
            opts="-n -q -v -h --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__build__subcmd__backend__subcmd__prepare__subcmd__metadata__subcmd__for__subcmd__build__subcmd__editable)
            opts="-n -q -v -h --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help <WHEEL_DIRECTORY>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__build__subcmd__backend__subcmd__prepare__subcmd__metadata__subcmd__for__subcmd__build__subcmd__wheel)
            opts="-n -q -v -h --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help <WHEEL_DIRECTORY>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__cache)
            opts="-n -q -v -h --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help clean prune dir size"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__cache__subcmd__clean)
            opts="-n -q -v -h --force --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help [PACKAGE]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__cache__subcmd__dir)
            opts="-n -q -v -h --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__cache__subcmd__prune)
            opts="-n -q -v -h --ci --force --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__cache__subcmd__size)
            opts="-H -n -q -v -h --human --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__check)
            opts="-p -i -f -U -P -C -n -q -v -h --extra --all-extras --no-extra --no-all-extras --dev --no-dev --only-dev --group --no-group --no-default-groups --only-group --all-groups --locked --frozen --no-sync --isolated --python --ty-version --no-project --index --default-index --index-url --extra-index-url --find-links --no-index --upgrade --no-upgrade --upgrade-package --upgrade-group --reinstall --no-reinstall --reinstall-package --index-strategy --keyring-provider --resolution --prerelease --pre --fork-strategy --config-setting --config-settings-package --no-build-isolation --no-build-isolation-package --build-isolation --exclude-newer --exclude-newer-package --link-mode --compile-bytecode --no-compile-bytecode --no-sources --no-sources-package --no-build --build --no-build-package --no-binary --binary --no-binary-package --refresh --no-refresh --refresh-package --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --extra)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-extra)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --group)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-group)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --only-group)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --ty-version)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -P)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --upgrade-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reinstall-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --resolution)
                    COMPREPLY=($(compgen -W "highest lowest lowest-direct" -- "${cur}"))
                    return 0
                    ;;
                --prerelease)
                    COMPREPLY=($(compgen -W "disallow allow if-necessary explicit if-necessary-or-explicit" -- "${cur}"))
                    return 0
                    ;;
                --fork-strategy)
                    COMPREPLY=($(compgen -W "fewest requires-python" -- "${cur}"))
                    return 0
                    ;;
                --config-setting)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -C)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --config-settings-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-build-isolation-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --link-mode)
                    COMPREPLY=($(compgen -W "clone copy hardlink symlink" -- "${cur}"))
                    return 0
                    ;;
                --no-sources-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-binary-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --refresh-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__clean)
            opts="-n -q -v -h --force --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help [PACKAGE]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__export)
            opts="-o -i -f -U -P -C -p -n -q -v -h --format --all-packages --package --prune --extra --all-extras --no-extra --no-all-extras --dev --no-dev --only-dev --group --no-group --no-default-groups --only-group --all-groups --no-annotate --annotate --no-header --header --editable --no-editable --no-editable-package --hashes --no-hashes --output-file --no-emit-project --only-emit-project --no-emit-workspace --only-emit-workspace --no-emit-local --only-emit-local --no-emit-package --only-emit-package --locked --frozen --index --default-index --index-url --extra-index-url --find-links --no-index --upgrade --no-upgrade --upgrade-package --upgrade-group --index-strategy --keyring-provider --resolution --prerelease --pre --fork-strategy --config-setting --config-settings-package --no-build-isolation --no-build-isolation-package --build-isolation --exclude-newer --exclude-newer-package --link-mode --no-sources --no-sources-package --no-build --build --no-build-package --no-binary --binary --no-binary-package --refresh --no-refresh --refresh-package --script --python --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --format)
                    COMPREPLY=($(compgen -W "requirements.txt pylock.toml cyclonedx1.5" -- "${cur}"))
                    return 0
                    ;;
                --package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --prune)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-extra)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --only-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-editable-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --output-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                -o)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --no-emit-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --only-emit-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -P)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --resolution)
                    COMPREPLY=($(compgen -W "highest lowest lowest-direct" -- "${cur}"))
                    return 0
                    ;;
                --prerelease)
                    COMPREPLY=($(compgen -W "disallow allow if-necessary explicit if-necessary-or-explicit" -- "${cur}"))
                    return 0
                    ;;
                --fork-strategy)
                    COMPREPLY=($(compgen -W "fewest requires-python" -- "${cur}"))
                    return 0
                    ;;
                --config-setting)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -C)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config-settings-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-isolation-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --exclude-newer-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --link-mode)
                    COMPREPLY=($(compgen -W "clone copy hardlink symlink" -- "${cur}"))
                    return 0
                    ;;
                --no-sources-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-binary-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --refresh-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --script)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__format)
            opts="-n -q -v -h --check --diff --version --exclude-newer --no-project --show-version --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help [EXTRA_ARGS]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --version)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__generate__subcmd__shell__subcmd__completion)
            opts="-n -q -v -h -V --no-cache --cache-dir --python-preference --no-python-downloads --quiet --verbose --color --native-tls --offline --no-progress --config-file --no-config --help --version --managed-python --no-managed-python --allow-python-downloads --python-fetch --no-color --no-native-tls --system-certs --no-system-certs --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-installer-metadata --directory --project bash elvish fish nushell powershell zsh"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --config-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__help)
            opts="-n -q -v -h --no-pager --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help [COMMAND]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__init)
            opts="-p -n -q -v -h --name --bare --virtual --package --no-package --app --lib --script --description --no-description --vcs --build-backend --backend --no-readme --author-from --no-pin-python --pin-python --no-workspace --python --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help [PATH]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --name)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --description)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --vcs)
                    COMPREPLY=($(compgen -W "git none" -- "${cur}"))
                    return 0
                    ;;
                --build-backend)
                    COMPREPLY=($(compgen -W "uv hatch flit pdm poetry setuptools maturin scikit" -- "${cur}"))
                    return 0
                    ;;
                --author-from)
                    COMPREPLY=($(compgen -W "auto git none" -- "${cur}"))
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__lock)
            opts="-i -f -U -P -C -p -n -q -v -h --check --locked --check-exists --dry-run --script --index --default-index --index-url --extra-index-url --find-links --no-index --upgrade --no-upgrade --upgrade-package --upgrade-group --index-strategy --keyring-provider --resolution --prerelease --pre --fork-strategy --config-setting --config-settings-package --no-build-isolation --no-build-isolation-package --build-isolation --exclude-newer --exclude-newer-package --link-mode --no-sources --no-sources-package --no-build --build --no-build-package --no-binary --binary --no-binary-package --refresh --no-refresh --refresh-package --python --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --script)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -P)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --resolution)
                    COMPREPLY=($(compgen -W "highest lowest lowest-direct" -- "${cur}"))
                    return 0
                    ;;
                --prerelease)
                    COMPREPLY=($(compgen -W "disallow allow if-necessary explicit if-necessary-or-explicit" -- "${cur}"))
                    return 0
                    ;;
                --fork-strategy)
                    COMPREPLY=($(compgen -W "fewest requires-python" -- "${cur}"))
                    return 0
                    ;;
                --config-setting)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -C)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config-settings-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-isolation-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --exclude-newer-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --link-mode)
                    COMPREPLY=($(compgen -W "clone copy hardlink symlink" -- "${cur}"))
                    return 0
                    ;;
                --no-sources-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-binary-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --refresh-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__pip)
            opts="-n -q -v -h --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help compile sync install uninstall freeze list show tree check debug"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__pip__subcmd__check)
            opts="-p -n -q -v -h --python --system --no-system --python-version --python-platform --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --python-version)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --python-platform)
                    COMPREPLY=($(compgen -W "windows linux macos x86_64-pc-windows-msvc aarch64-pc-windows-msvc i686-pc-windows-msvc x86_64-unknown-linux-gnu aarch64-apple-darwin x86_64-apple-darwin aarch64-unknown-linux-gnu aarch64-unknown-linux-musl x86_64-unknown-linux-musl riscv64-unknown-linux x86_64-manylinux2014 x86_64-manylinux_2_17 x86_64-manylinux_2_28 x86_64-manylinux_2_31 x86_64-manylinux_2_32 x86_64-manylinux_2_33 x86_64-manylinux_2_34 x86_64-manylinux_2_35 x86_64-manylinux_2_36 x86_64-manylinux_2_37 x86_64-manylinux_2_38 x86_64-manylinux_2_39 x86_64-manylinux_2_40 aarch64-manylinux2014 aarch64-manylinux_2_17 aarch64-manylinux_2_28 aarch64-manylinux_2_31 aarch64-manylinux_2_32 aarch64-manylinux_2_33 aarch64-manylinux_2_34 aarch64-manylinux_2_35 aarch64-manylinux_2_36 aarch64-manylinux_2_37 aarch64-manylinux_2_38 aarch64-manylinux_2_39 aarch64-manylinux_2_40 aarch64-linux-android x86_64-linux-android wasm32-pyodide2024 wasm32-pyodide2025 arm64-apple-ios arm64-apple-ios-simulator x86_64-apple-ios-simulator" -- "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__pip__subcmd__compile)
            opts="-c -b -i -f -U -P -C -o -p -n -q -v -h --constraints --overrides --excludes --build-constraints --extra --all-extras --no-all-extras --group --index --default-index --index-url --extra-index-url --find-links --no-index --upgrade --no-upgrade --upgrade-package --upgrade-group --index-strategy --keyring-provider --resolution --prerelease --pre --fork-strategy --config-setting --config-settings-package --no-build-isolation --no-build-isolation-package --build-isolation --exclude-newer --exclude-newer-package --link-mode --no-sources --no-sources-package --refresh --no-refresh --refresh-package --no-deps --deps --output-file --format --no-strip-extras --strip-extras --no-strip-markers --strip-markers --no-annotate --annotate --no-header --header --annotation-style --custom-compile-command --python --system --no-system --generate-hashes --no-generate-hashes --no-build --build --no-binary --only-binary --python-version --python-platform --universal --no-universal --no-emit-package --emit-index-url --no-emit-index-url --emit-find-links --no-emit-find-links --emit-build-options --no-emit-build-options --emit-marker-expression --no-emit-marker-expression --emit-index-annotation --no-emit-index-annotation --torch-backend --allow-unsafe --no-allow-unsafe --reuse-hashes --no-reuse-hashes --resolver --max-rounds --cert --client-cert --emit-trusted-host --no-emit-trusted-host --config --no-config --emit-options --no-emit-options --pip-args --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --help [SRC_FILE]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --constraints)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                -c)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --overrides)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --excludes)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --build-constraints)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                -b)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --extra)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -P)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --resolution)
                    COMPREPLY=($(compgen -W "highest lowest lowest-direct" -- "${cur}"))
                    return 0
                    ;;
                --prerelease)
                    COMPREPLY=($(compgen -W "disallow allow if-necessary explicit if-necessary-or-explicit" -- "${cur}"))
                    return 0
                    ;;
                --fork-strategy)
                    COMPREPLY=($(compgen -W "fewest requires-python" -- "${cur}"))
                    return 0
                    ;;
                --config-setting)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -C)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config-settings-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-isolation-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --exclude-newer-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --link-mode)
                    COMPREPLY=($(compgen -W "clone copy hardlink symlink" -- "${cur}"))
                    return 0
                    ;;
                --no-sources-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --refresh-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --output-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                -o)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --format)
                    COMPREPLY=($(compgen -W "requirements.txt pylock.toml" -- "${cur}"))
                    return 0
                    ;;
                --annotation-style)
                    COMPREPLY=($(compgen -W "line split" -- "${cur}"))
                    return 0
                    ;;
                --custom-compile-command)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-binary)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --only-binary)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --python-version)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --python-platform)
                    COMPREPLY=($(compgen -W "windows linux macos x86_64-pc-windows-msvc aarch64-pc-windows-msvc i686-pc-windows-msvc x86_64-unknown-linux-gnu aarch64-apple-darwin x86_64-apple-darwin aarch64-unknown-linux-gnu aarch64-unknown-linux-musl x86_64-unknown-linux-musl riscv64-unknown-linux x86_64-manylinux2014 x86_64-manylinux_2_17 x86_64-manylinux_2_28 x86_64-manylinux_2_31 x86_64-manylinux_2_32 x86_64-manylinux_2_33 x86_64-manylinux_2_34 x86_64-manylinux_2_35 x86_64-manylinux_2_36 x86_64-manylinux_2_37 x86_64-manylinux_2_38 x86_64-manylinux_2_39 x86_64-manylinux_2_40 aarch64-manylinux2014 aarch64-manylinux_2_17 aarch64-manylinux_2_28 aarch64-manylinux_2_31 aarch64-manylinux_2_32 aarch64-manylinux_2_33 aarch64-manylinux_2_34 aarch64-manylinux_2_35 aarch64-manylinux_2_36 aarch64-manylinux_2_37 aarch64-manylinux_2_38 aarch64-manylinux_2_39 aarch64-manylinux_2_40 aarch64-linux-android x86_64-linux-android wasm32-pyodide2024 wasm32-pyodide2025 arm64-apple-ios arm64-apple-ios-simulator x86_64-apple-ios-simulator" -- "${cur}"))
                    return 0
                    ;;
                --no-emit-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --torch-backend)
                    COMPREPLY=($(compgen -W "auto cpu cu130 cu129 cu128 cu126 cu125 cu124 cu123 cu122 cu121 cu120 cu118 cu117 cu116 cu115 cu114 cu113 cu112 cu111 cu110 cu102 cu101 cu100 cu92 cu91 cu90 cu80 rocm7.2 rocm7.1 rocm7.0 rocm6.4 rocm6.3 rocm6.2.4 rocm6.2 rocm6.1 rocm6.0 rocm5.7 rocm5.6 rocm5.5 rocm5.4.2 rocm5.4 rocm5.3 rocm5.2 rocm5.1.1 rocm4.2 rocm4.1 rocm4.0.1 xpu" -- "${cur}"))
                    return 0
                    ;;
                --resolver)
                    COMPREPLY=($(compgen -W "backtracking legacy" -- "${cur}"))
                    return 0
                    ;;
                --max-rounds)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --client-cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --pip-args)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__pip__subcmd__debug)
            opts="-n -q -v -h --platform --python-version --implementation --abi --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --platform)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --python-version)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --implementation)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --abi)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__pip__subcmd__freeze)
            opts="-p -t -n -q -v -h --exclude-editable --exclude --strict --no-strict --python --path --system --no-system --target --prefix --disable-pip-version-check --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --exclude)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --path)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --target)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                -t)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --prefix)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__pip__subcmd__install)
            opts="-r -e -c -b -i -f -U -P -C -p -t -n -q -v -h --requirements --editable --no-editable --no-editable-package --constraints --overrides --excludes --build-constraints --extra --all-extras --no-all-extras --group --index --default-index --index-url --extra-index-url --find-links --no-index --upgrade --no-upgrade --upgrade-package --upgrade-group --reinstall --no-reinstall --reinstall-package --index-strategy --keyring-provider --resolution --prerelease --pre --fork-strategy --config-setting --config-settings-package --no-build-isolation --no-build-isolation-package --build-isolation --exclude-newer --exclude-newer-package --link-mode --compile-bytecode --no-compile-bytecode --no-sources --no-sources-package --refresh --no-refresh --refresh-package --no-deps --deps --require-hashes --no-require-hashes --verify-hashes --no-verify-hashes --python --system --no-system --break-system-packages --no-break-system-packages --target --prefix --no-build --build --no-binary --only-binary --python-version --python-platform --inexact --exact --strict --no-strict --dry-run --torch-backend --disable-pip-version-check --user --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help [PACKAGE]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --requirements)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                -r)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --editable)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -e)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-editable-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --constraints)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                -c)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --overrides)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --excludes)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --build-constraints)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                -b)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --extra)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -P)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --upgrade-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reinstall-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --resolution)
                    COMPREPLY=($(compgen -W "highest lowest lowest-direct" -- "${cur}"))
                    return 0
                    ;;
                --prerelease)
                    COMPREPLY=($(compgen -W "disallow allow if-necessary explicit if-necessary-or-explicit" -- "${cur}"))
                    return 0
                    ;;
                --fork-strategy)
                    COMPREPLY=($(compgen -W "fewest requires-python" -- "${cur}"))
                    return 0
                    ;;
                --config-setting)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -C)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --config-settings-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-build-isolation-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --link-mode)
                    COMPREPLY=($(compgen -W "clone copy hardlink symlink" -- "${cur}"))
                    return 0
                    ;;
                --no-sources-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --refresh-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --target)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                -t)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --prefix)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --no-binary)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --only-binary)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --python-version)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --python-platform)
                    COMPREPLY=($(compgen -W "windows linux macos x86_64-pc-windows-msvc aarch64-pc-windows-msvc i686-pc-windows-msvc x86_64-unknown-linux-gnu aarch64-apple-darwin x86_64-apple-darwin aarch64-unknown-linux-gnu aarch64-unknown-linux-musl x86_64-unknown-linux-musl riscv64-unknown-linux x86_64-manylinux2014 x86_64-manylinux_2_17 x86_64-manylinux_2_28 x86_64-manylinux_2_31 x86_64-manylinux_2_32 x86_64-manylinux_2_33 x86_64-manylinux_2_34 x86_64-manylinux_2_35 x86_64-manylinux_2_36 x86_64-manylinux_2_37 x86_64-manylinux_2_38 x86_64-manylinux_2_39 x86_64-manylinux_2_40 aarch64-manylinux2014 aarch64-manylinux_2_17 aarch64-manylinux_2_28 aarch64-manylinux_2_31 aarch64-manylinux_2_32 aarch64-manylinux_2_33 aarch64-manylinux_2_34 aarch64-manylinux_2_35 aarch64-manylinux_2_36 aarch64-manylinux_2_37 aarch64-manylinux_2_38 aarch64-manylinux_2_39 aarch64-manylinux_2_40 aarch64-linux-android x86_64-linux-android wasm32-pyodide2024 wasm32-pyodide2025 arm64-apple-ios arm64-apple-ios-simulator x86_64-apple-ios-simulator" -- "${cur}"))
                    return 0
                    ;;
                --torch-backend)
                    COMPREPLY=($(compgen -W "auto cpu cu130 cu129 cu128 cu126 cu125 cu124 cu123 cu122 cu121 cu120 cu118 cu117 cu116 cu115 cu114 cu113 cu112 cu111 cu110 cu102 cu101 cu100 cu92 cu91 cu90 cu80 rocm7.2 rocm7.1 rocm7.0 rocm6.4 rocm6.3 rocm6.2.4 rocm6.2 rocm6.1 rocm6.0 rocm5.7 rocm5.6 rocm5.5 rocm5.4.2 rocm5.4 rocm5.3 rocm5.2 rocm5.1.1 rocm4.2 rocm4.1 rocm4.0.1 xpu" -- "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__pip__subcmd__list)
            opts="-e -i -f -p -t -n -q -v -h --editable --exclude-editable --exclude --format --outdated --no-outdated --strict --no-strict --index --default-index --index-url --extra-index-url --find-links --no-index --index-strategy --keyring-provider --exclude-newer --python --system --no-system --target --prefix --disable-pip-version-check --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --exclude)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --format)
                    COMPREPLY=($(compgen -W "columns freeze json" -- "${cur}"))
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --target)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                -t)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --prefix)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__pip__subcmd__show)
            opts="-f -p -t -n -q -v -h --strict --no-strict --files --python --system --no-system --target --prefix --disable-pip-version-check --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help [PACKAGE]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --target)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                -t)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --prefix)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__pip__subcmd__sync)
            opts="-c -b -i -f -C -p -t -a -n -q -v -h --constraints --build-constraints --extra --all-extras --no-all-extras --group --index --default-index --index-url --extra-index-url --find-links --no-index --reinstall --no-reinstall --reinstall-package --index-strategy --keyring-provider --config-setting --config-settings-package --no-build-isolation --build-isolation --exclude-newer --exclude-newer-package --link-mode --compile-bytecode --no-compile-bytecode --no-sources --no-sources-package --refresh --no-refresh --refresh-package --require-hashes --no-require-hashes --verify-hashes --no-verify-hashes --python --system --no-system --break-system-packages --no-break-system-packages --target --prefix --no-build --build --no-binary --only-binary --allow-empty-requirements --no-allow-empty-requirements --python-version --python-platform --strict --no-strict --dry-run --torch-backend --ask --python-executable --user --cert --client-cert --config --no-config --pip-args --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --help <SRC_FILE>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --constraints)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                -c)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --build-constraints)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                -b)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --extra)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reinstall-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --config-setting)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -C)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config-settings-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --exclude-newer-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --link-mode)
                    COMPREPLY=($(compgen -W "clone copy hardlink symlink" -- "${cur}"))
                    return 0
                    ;;
                --no-sources-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --refresh-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --target)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                -t)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --prefix)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --no-binary)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --only-binary)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --python-version)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --python-platform)
                    COMPREPLY=($(compgen -W "windows linux macos x86_64-pc-windows-msvc aarch64-pc-windows-msvc i686-pc-windows-msvc x86_64-unknown-linux-gnu aarch64-apple-darwin x86_64-apple-darwin aarch64-unknown-linux-gnu aarch64-unknown-linux-musl x86_64-unknown-linux-musl riscv64-unknown-linux x86_64-manylinux2014 x86_64-manylinux_2_17 x86_64-manylinux_2_28 x86_64-manylinux_2_31 x86_64-manylinux_2_32 x86_64-manylinux_2_33 x86_64-manylinux_2_34 x86_64-manylinux_2_35 x86_64-manylinux_2_36 x86_64-manylinux_2_37 x86_64-manylinux_2_38 x86_64-manylinux_2_39 x86_64-manylinux_2_40 aarch64-manylinux2014 aarch64-manylinux_2_17 aarch64-manylinux_2_28 aarch64-manylinux_2_31 aarch64-manylinux_2_32 aarch64-manylinux_2_33 aarch64-manylinux_2_34 aarch64-manylinux_2_35 aarch64-manylinux_2_36 aarch64-manylinux_2_37 aarch64-manylinux_2_38 aarch64-manylinux_2_39 aarch64-manylinux_2_40 aarch64-linux-android x86_64-linux-android wasm32-pyodide2024 wasm32-pyodide2025 arm64-apple-ios arm64-apple-ios-simulator x86_64-apple-ios-simulator" -- "${cur}"))
                    return 0
                    ;;
                --torch-backend)
                    COMPREPLY=($(compgen -W "auto cpu cu130 cu129 cu128 cu126 cu125 cu124 cu123 cu122 cu121 cu120 cu118 cu117 cu116 cu115 cu114 cu113 cu112 cu111 cu110 cu102 cu101 cu100 cu92 cu91 cu90 cu80 rocm7.2 rocm7.1 rocm7.0 rocm6.4 rocm6.3 rocm6.2.4 rocm6.2 rocm6.1 rocm6.0 rocm5.7 rocm5.6 rocm5.5 rocm5.4.2 rocm5.4 rocm5.3 rocm5.2 rocm5.1.1 rocm4.2 rocm4.1 rocm4.0.1 xpu" -- "${cur}"))
                    return 0
                    ;;
                --python-executable)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --client-cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --pip-args)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__pip__subcmd__tree)
            opts="-d -i -f -p -n -q -v -h --show-version-specifiers --depth --prune --package --no-dedupe --invert --outdated --show-sizes --strict --no-strict --index --default-index --index-url --extra-index-url --find-links --no-index --index-strategy --keyring-provider --exclude-newer --python --system --no-system --disable-pip-version-check --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --depth)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -d)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --prune)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__pip__subcmd__uninstall)
            opts="-r -p -t -y -n -q -v -h --requirements --python --keyring-provider --system --no-system --break-system-packages --no-break-system-packages --target --prefix --dry-run --yes --disable-pip-version-check --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help [PACKAGE]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --requirements)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                -r)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --target)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                -t)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --prefix)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__publish)
            opts="-u -p -t -n -q -v -h --index --username --password --token --trusted-publishing --keyring-provider --publish-url --check-url --skip-existing --dry-run --no-attestations --direct --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help [FILES]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --index)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --username)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -u)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --password)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --token)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -t)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --trusted-publishing)
                    COMPREPLY=($(compgen -W "automatic always never" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --publish-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --check-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__python)
            opts="-n -q -v -h --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help list install upgrade find pin dir uninstall update-shell"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__python__subcmd__dir)
            opts="-n -q -v -h --bin --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__python__subcmd__find)
            opts="-n -q -v -h --no-project --system --no-system --script --show-version --resolve-links --python-downloads-json-url --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help [REQUEST]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --script)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --python-downloads-json-url)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__python__subcmd__install)
            opts="-i -r -f -U -n -q -v -h --install-dir --bin --no-bin --registry --no-registry --mirror --pypy-mirror --python-downloads-json-url --reinstall --force --upgrade --default --compile-bytecode --no-compile-bytecode --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help [TARGETS]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --install-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                -i)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --mirror)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --pypy-mirror)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --python-downloads-json-url)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__python__subcmd__list)
            opts="-n -q -v -h --all-versions --all-platforms --all-arches --only-installed --only-downloads --show-urls --output-format --python-downloads-json-url --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help [REQUEST]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --output-format)
                    COMPREPLY=($(compgen -W "text json" -- "${cur}"))
                    return 0
                    ;;
                --python-downloads-json-url)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__python__subcmd__pin)
            opts="-n -q -v -h --resolved --no-resolved --no-project --global --rm --python-downloads-json-url --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help [REQUEST]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --python-downloads-json-url)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__python__subcmd__uninstall)
            opts="-i -n -q -v -h --install-dir --all --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help <TARGETS>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --install-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                -i)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__python__subcmd__update__subcmd__shell)
            opts="-n -q -v -h --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__python__subcmd__upgrade)
            opts="-i -r -n -q -v -h --install-dir --mirror --pypy-mirror --reinstall --python-downloads-json-url --compile-bytecode --no-compile-bytecode --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help [TARGETS]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --install-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                -i)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --mirror)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --pypy-mirror)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --python-downloads-json-url)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__remove)
            opts="-i -f -U -P -C -p -n -q -v -h --dev --optional --group --no-sync --active --no-active --locked --frozen --index --default-index --index-url --extra-index-url --find-links --no-index --upgrade --no-upgrade --upgrade-package --upgrade-group --reinstall --no-reinstall --reinstall-package --index-strategy --keyring-provider --resolution --prerelease --pre --fork-strategy --config-setting --config-settings-package --no-build-isolation --no-build-isolation-package --build-isolation --exclude-newer --exclude-newer-package --link-mode --compile-bytecode --no-compile-bytecode --no-sources --no-sources-package --no-build --build --no-build-package --no-binary --binary --no-binary-package --refresh --no-refresh --refresh-package --package --script --python --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help <PACKAGES>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --optional)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --group)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -P)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --upgrade-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reinstall-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --resolution)
                    COMPREPLY=($(compgen -W "highest lowest lowest-direct" -- "${cur}"))
                    return 0
                    ;;
                --prerelease)
                    COMPREPLY=($(compgen -W "disallow allow if-necessary explicit if-necessary-or-explicit" -- "${cur}"))
                    return 0
                    ;;
                --fork-strategy)
                    COMPREPLY=($(compgen -W "fewest requires-python" -- "${cur}"))
                    return 0
                    ;;
                --config-setting)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -C)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --config-settings-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-build-isolation-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --link-mode)
                    COMPREPLY=($(compgen -W "clone copy hardlink symlink" -- "${cur}"))
                    return 0
                    ;;
                --no-sources-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-binary-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --refresh-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --script)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__run)
            opts="-m -w -s -i -f -U -P -C -p -n -q -v -h --extra --all-extras --no-extra --no-all-extras --dev --no-dev --group --no-group --no-default-groups --only-group --all-groups --module --only-dev --editable --no-editable --no-editable-package --inexact --exact --env-file --no-env-file --with --with-editable --with-requirements --isolated --active --no-active --no-sync --locked --frozen --script --gui-script --index --default-index --index-url --extra-index-url --find-links --no-index --upgrade --no-upgrade --upgrade-package --upgrade-group --reinstall --no-reinstall --reinstall-package --index-strategy --keyring-provider --resolution --prerelease --pre --fork-strategy --config-setting --config-settings-package --no-build-isolation --no-build-isolation-package --build-isolation --exclude-newer --exclude-newer-package --link-mode --compile-bytecode --no-compile-bytecode --no-sources --no-sources-package --no-build --build --no-build-package --no-binary --binary --no-binary-package --refresh --no-refresh --refresh-package --all-packages --package --no-project --python --show-resolution --max-recursion-depth --python-platform --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --extra)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-extra)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --group)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-group)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --only-group)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-editable-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --env-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --with)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -w)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --with-editable)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --with-requirements)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -P)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --upgrade-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reinstall-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --resolution)
                    COMPREPLY=($(compgen -W "highest lowest lowest-direct" -- "${cur}"))
                    return 0
                    ;;
                --prerelease)
                    COMPREPLY=($(compgen -W "disallow allow if-necessary explicit if-necessary-or-explicit" -- "${cur}"))
                    return 0
                    ;;
                --fork-strategy)
                    COMPREPLY=($(compgen -W "fewest requires-python" -- "${cur}"))
                    return 0
                    ;;
                --config-setting)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -C)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --config-settings-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-build-isolation-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --link-mode)
                    COMPREPLY=($(compgen -W "clone copy hardlink symlink" -- "${cur}"))
                    return 0
                    ;;
                --no-sources-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-binary-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --refresh-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --max-recursion-depth)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --python-platform)
                    COMPREPLY=($(compgen -W "windows linux macos x86_64-pc-windows-msvc aarch64-pc-windows-msvc i686-pc-windows-msvc x86_64-unknown-linux-gnu aarch64-apple-darwin x86_64-apple-darwin aarch64-unknown-linux-gnu aarch64-unknown-linux-musl x86_64-unknown-linux-musl riscv64-unknown-linux x86_64-manylinux2014 x86_64-manylinux_2_17 x86_64-manylinux_2_28 x86_64-manylinux_2_31 x86_64-manylinux_2_32 x86_64-manylinux_2_33 x86_64-manylinux_2_34 x86_64-manylinux_2_35 x86_64-manylinux_2_36 x86_64-manylinux_2_37 x86_64-manylinux_2_38 x86_64-manylinux_2_39 x86_64-manylinux_2_40 aarch64-manylinux2014 aarch64-manylinux_2_17 aarch64-manylinux_2_28 aarch64-manylinux_2_31 aarch64-manylinux_2_32 aarch64-manylinux_2_33 aarch64-manylinux_2_34 aarch64-manylinux_2_35 aarch64-manylinux_2_36 aarch64-manylinux_2_37 aarch64-manylinux_2_38 aarch64-manylinux_2_39 aarch64-manylinux_2_40 aarch64-linux-android x86_64-linux-android wasm32-pyodide2024 wasm32-pyodide2025 arm64-apple-ios arm64-apple-ios-simulator x86_64-apple-ios-simulator" -- "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__self)
            opts="-n -q -v -h --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help update version"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__self__subcmd__update)
            opts="-n -q -v -h --token --dry-run --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help [TARGET_VERSION]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --token)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__self__subcmd__version)
            opts="-n -q -v -h --short --output-format --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --output-format)
                    COMPREPLY=($(compgen -W "text json" -- "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__sync)
            opts="-i -f -U -P -C -p -n -q -v -h --extra --output-format --all-extras --no-extra --no-all-extras --dev --no-dev --only-dev --group --no-group --no-default-groups --only-group --all-groups --editable --no-editable --no-editable-package --inexact --exact --active --no-active --no-install-project --only-install-project --no-install-workspace --only-install-workspace --no-install-local --only-install-local --no-install-package --only-install-package --locked --frozen --dry-run --index --default-index --index-url --extra-index-url --find-links --no-index --upgrade --no-upgrade --upgrade-package --upgrade-group --reinstall --no-reinstall --reinstall-package --index-strategy --keyring-provider --resolution --prerelease --pre --fork-strategy --config-setting --config-settings-package --no-build-isolation --no-build-isolation-package --build-isolation --exclude-newer --exclude-newer-package --link-mode --compile-bytecode --no-compile-bytecode --no-sources --no-sources-package --no-build --build --no-build-package --no-binary --binary --no-binary-package --refresh --no-refresh --refresh-package --all-packages --package --script --python --python-platform --check --no-check --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --extra)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --output-format)
                    COMPREPLY=($(compgen -W "text json" -- "${cur}"))
                    return 0
                    ;;
                --no-extra)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --group)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-group)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --only-group)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-editable-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-install-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --only-install-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -P)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --upgrade-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reinstall-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --resolution)
                    COMPREPLY=($(compgen -W "highest lowest lowest-direct" -- "${cur}"))
                    return 0
                    ;;
                --prerelease)
                    COMPREPLY=($(compgen -W "disallow allow if-necessary explicit if-necessary-or-explicit" -- "${cur}"))
                    return 0
                    ;;
                --fork-strategy)
                    COMPREPLY=($(compgen -W "fewest requires-python" -- "${cur}"))
                    return 0
                    ;;
                --config-setting)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -C)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --config-settings-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-build-isolation-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --link-mode)
                    COMPREPLY=($(compgen -W "clone copy hardlink symlink" -- "${cur}"))
                    return 0
                    ;;
                --no-sources-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-binary-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --refresh-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --script)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --python-platform)
                    COMPREPLY=($(compgen -W "windows linux macos x86_64-pc-windows-msvc aarch64-pc-windows-msvc i686-pc-windows-msvc x86_64-unknown-linux-gnu aarch64-apple-darwin x86_64-apple-darwin aarch64-unknown-linux-gnu aarch64-unknown-linux-musl x86_64-unknown-linux-musl riscv64-unknown-linux x86_64-manylinux2014 x86_64-manylinux_2_17 x86_64-manylinux_2_28 x86_64-manylinux_2_31 x86_64-manylinux_2_32 x86_64-manylinux_2_33 x86_64-manylinux_2_34 x86_64-manylinux_2_35 x86_64-manylinux_2_36 x86_64-manylinux_2_37 x86_64-manylinux_2_38 x86_64-manylinux_2_39 x86_64-manylinux_2_40 aarch64-manylinux2014 aarch64-manylinux_2_17 aarch64-manylinux_2_28 aarch64-manylinux_2_31 aarch64-manylinux_2_32 aarch64-manylinux_2_33 aarch64-manylinux_2_34 aarch64-manylinux_2_35 aarch64-manylinux_2_36 aarch64-manylinux_2_37 aarch64-manylinux_2_38 aarch64-manylinux_2_39 aarch64-manylinux_2_40 aarch64-linux-android x86_64-linux-android wasm32-pyodide2024 wasm32-pyodide2025 arm64-apple-ios arm64-apple-ios-simulator x86_64-apple-ios-simulator" -- "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__tool)
            opts="-n -q -v -h --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help run uvx install upgrade list uninstall update-shell dir"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__tool__subcmd__dir)
            opts="-n -q -v -h --bin --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__tool__subcmd__install)
            opts="-w -e -c -b -i -f -U -P -C -p -n -q -v -h --from --with --with-requirements --editable --with-editable --with-executables-from --constraints --overrides --excludes --build-constraints --index --default-index --index-url --extra-index-url --find-links --no-index --upgrade --no-upgrade --upgrade-package --upgrade-group --reinstall --no-reinstall --reinstall-package --index-strategy --keyring-provider --resolution --prerelease --pre --fork-strategy --config-setting --config-settings-package --no-build-isolation --no-build-isolation-package --build-isolation --exclude-newer --exclude-newer-package --link-mode --compile-bytecode --no-compile-bytecode --no-sources --no-sources-package --no-build --build --no-build-package --no-binary --binary --no-binary-package --refresh --no-refresh --refresh-package --force --lfs --python --python-platform --torch-backend --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help <PACKAGE>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --from)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --with)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -w)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --with-requirements)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --with-editable)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --with-executables-from)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --constraints)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                -c)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --overrides)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --excludes)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --build-constraints)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                -b)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -P)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --upgrade-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reinstall-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --resolution)
                    COMPREPLY=($(compgen -W "highest lowest lowest-direct" -- "${cur}"))
                    return 0
                    ;;
                --prerelease)
                    COMPREPLY=($(compgen -W "disallow allow if-necessary explicit if-necessary-or-explicit" -- "${cur}"))
                    return 0
                    ;;
                --fork-strategy)
                    COMPREPLY=($(compgen -W "fewest requires-python" -- "${cur}"))
                    return 0
                    ;;
                --config-setting)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -C)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --config-settings-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-build-isolation-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --link-mode)
                    COMPREPLY=($(compgen -W "clone copy hardlink symlink" -- "${cur}"))
                    return 0
                    ;;
                --no-sources-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-binary-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --refresh-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --python-platform)
                    COMPREPLY=($(compgen -W "windows linux macos x86_64-pc-windows-msvc aarch64-pc-windows-msvc i686-pc-windows-msvc x86_64-unknown-linux-gnu aarch64-apple-darwin x86_64-apple-darwin aarch64-unknown-linux-gnu aarch64-unknown-linux-musl x86_64-unknown-linux-musl riscv64-unknown-linux x86_64-manylinux2014 x86_64-manylinux_2_17 x86_64-manylinux_2_28 x86_64-manylinux_2_31 x86_64-manylinux_2_32 x86_64-manylinux_2_33 x86_64-manylinux_2_34 x86_64-manylinux_2_35 x86_64-manylinux_2_36 x86_64-manylinux_2_37 x86_64-manylinux_2_38 x86_64-manylinux_2_39 x86_64-manylinux_2_40 aarch64-manylinux2014 aarch64-manylinux_2_17 aarch64-manylinux_2_28 aarch64-manylinux_2_31 aarch64-manylinux_2_32 aarch64-manylinux_2_33 aarch64-manylinux_2_34 aarch64-manylinux_2_35 aarch64-manylinux_2_36 aarch64-manylinux_2_37 aarch64-manylinux_2_38 aarch64-manylinux_2_39 aarch64-manylinux_2_40 aarch64-linux-android x86_64-linux-android wasm32-pyodide2024 wasm32-pyodide2025 arm64-apple-ios arm64-apple-ios-simulator x86_64-apple-ios-simulator" -- "${cur}"))
                    return 0
                    ;;
                --torch-backend)
                    COMPREPLY=($(compgen -W "auto cpu cu130 cu129 cu128 cu126 cu125 cu124 cu123 cu122 cu121 cu120 cu118 cu117 cu116 cu115 cu114 cu113 cu112 cu111 cu110 cu102 cu101 cu100 cu92 cu91 cu90 cu80 rocm7.2 rocm7.1 rocm7.0 rocm6.4 rocm6.3 rocm6.2.4 rocm6.2 rocm6.1 rocm6.0 rocm5.7 rocm5.6 rocm5.5 rocm5.4.2 rocm5.4 rocm5.3 rocm5.2 rocm5.1.1 rocm4.2 rocm4.1 rocm4.0.1 xpu" -- "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__tool__subcmd__list)
            opts="-n -q -v -h --show-paths --show-version-specifiers --show-with --show-extras --show-python --outdated --no-outdated --exclude-newer --python-preference --no-python-downloads --no-cache --cache-dir --managed-python --no-managed-python --allow-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --exclude-newer)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__tool__subcmd__run)
            opts="-w -c -b -i -f -U -P -C -p -n -q -v -h --from --with --with-editable --with-requirements --constraints --build-constraints --overrides --isolated --env-file --no-env-file --index --default-index --index-url --extra-index-url --find-links --no-index --upgrade --no-upgrade --upgrade-package --upgrade-group --reinstall --no-reinstall --reinstall-package --index-strategy --keyring-provider --resolution --prerelease --pre --fork-strategy --config-setting --config-settings-package --no-build-isolation --no-build-isolation-package --build-isolation --exclude-newer --exclude-newer-package --link-mode --compile-bytecode --no-compile-bytecode --no-sources --no-sources-package --no-build --build --no-build-package --no-binary --binary --no-binary-package --refresh --no-refresh --refresh-package --lfs --python --show-resolution --python-platform --torch-backend --generate-shell-completion --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --from)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --with)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -w)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --with-editable)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --with-requirements)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --constraints)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                -c)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --build-constraints)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                -b)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --overrides)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --env-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -P)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --upgrade-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reinstall-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --resolution)
                    COMPREPLY=($(compgen -W "highest lowest lowest-direct" -- "${cur}"))
                    return 0
                    ;;
                --prerelease)
                    COMPREPLY=($(compgen -W "disallow allow if-necessary explicit if-necessary-or-explicit" -- "${cur}"))
                    return 0
                    ;;
                --fork-strategy)
                    COMPREPLY=($(compgen -W "fewest requires-python" -- "${cur}"))
                    return 0
                    ;;
                --config-setting)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -C)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --config-settings-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-build-isolation-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --link-mode)
                    COMPREPLY=($(compgen -W "clone copy hardlink symlink" -- "${cur}"))
                    return 0
                    ;;
                --no-sources-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-binary-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --refresh-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --python-platform)
                    COMPREPLY=($(compgen -W "windows linux macos x86_64-pc-windows-msvc aarch64-pc-windows-msvc i686-pc-windows-msvc x86_64-unknown-linux-gnu aarch64-apple-darwin x86_64-apple-darwin aarch64-unknown-linux-gnu aarch64-unknown-linux-musl x86_64-unknown-linux-musl riscv64-unknown-linux x86_64-manylinux2014 x86_64-manylinux_2_17 x86_64-manylinux_2_28 x86_64-manylinux_2_31 x86_64-manylinux_2_32 x86_64-manylinux_2_33 x86_64-manylinux_2_34 x86_64-manylinux_2_35 x86_64-manylinux_2_36 x86_64-manylinux_2_37 x86_64-manylinux_2_38 x86_64-manylinux_2_39 x86_64-manylinux_2_40 aarch64-manylinux2014 aarch64-manylinux_2_17 aarch64-manylinux_2_28 aarch64-manylinux_2_31 aarch64-manylinux_2_32 aarch64-manylinux_2_33 aarch64-manylinux_2_34 aarch64-manylinux_2_35 aarch64-manylinux_2_36 aarch64-manylinux_2_37 aarch64-manylinux_2_38 aarch64-manylinux_2_39 aarch64-manylinux_2_40 aarch64-linux-android x86_64-linux-android wasm32-pyodide2024 wasm32-pyodide2025 arm64-apple-ios arm64-apple-ios-simulator x86_64-apple-ios-simulator" -- "${cur}"))
                    return 0
                    ;;
                --torch-backend)
                    COMPREPLY=($(compgen -W "auto cpu cu130 cu129 cu128 cu126 cu125 cu124 cu123 cu122 cu121 cu120 cu118 cu117 cu116 cu115 cu114 cu113 cu112 cu111 cu110 cu102 cu101 cu100 cu92 cu91 cu90 cu80 rocm7.2 rocm7.1 rocm7.0 rocm6.4 rocm6.3 rocm6.2.4 rocm6.2 rocm6.1 rocm6.0 rocm5.7 rocm5.6 rocm5.5 rocm5.4.2 rocm5.4 rocm5.3 rocm5.2 rocm5.1.1 rocm4.2 rocm4.1 rocm4.0.1 xpu" -- "${cur}"))
                    return 0
                    ;;
                --generate-shell-completion)
                    COMPREPLY=($(compgen -W "bash elvish fish nushell powershell zsh" -- "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__tool__subcmd__uninstall)
            opts="-n -q -v -h --all --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help <NAME>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__tool__subcmd__update__subcmd__shell)
            opts="-n -q -v -h --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__tool__subcmd__upgrade)
            opts="-p -U -P -i -f -C -n -q -v -h --all --python --python-platform --upgrade --upgrade-package --upgrade-group --index --default-index --index-url --extra-index-url --find-links --no-index --reinstall --no-reinstall --reinstall-package --index-strategy --keyring-provider --resolution --prerelease --pre --fork-strategy --config-setting --config-setting-package --no-build-isolation --no-build-isolation-package --build-isolation --exclude-newer --exclude-newer-package --link-mode --compile-bytecode --no-compile-bytecode --no-sources --no-sources-package --no-build --build --no-build-package --no-binary --binary --no-binary-package --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help <NAME>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --python-platform)
                    COMPREPLY=($(compgen -W "windows linux macos x86_64-pc-windows-msvc aarch64-pc-windows-msvc i686-pc-windows-msvc x86_64-unknown-linux-gnu aarch64-apple-darwin x86_64-apple-darwin aarch64-unknown-linux-gnu aarch64-unknown-linux-musl x86_64-unknown-linux-musl riscv64-unknown-linux x86_64-manylinux2014 x86_64-manylinux_2_17 x86_64-manylinux_2_28 x86_64-manylinux_2_31 x86_64-manylinux_2_32 x86_64-manylinux_2_33 x86_64-manylinux_2_34 x86_64-manylinux_2_35 x86_64-manylinux_2_36 x86_64-manylinux_2_37 x86_64-manylinux_2_38 x86_64-manylinux_2_39 x86_64-manylinux_2_40 aarch64-manylinux2014 aarch64-manylinux_2_17 aarch64-manylinux_2_28 aarch64-manylinux_2_31 aarch64-manylinux_2_32 aarch64-manylinux_2_33 aarch64-manylinux_2_34 aarch64-manylinux_2_35 aarch64-manylinux_2_36 aarch64-manylinux_2_37 aarch64-manylinux_2_38 aarch64-manylinux_2_39 aarch64-manylinux_2_40 aarch64-linux-android x86_64-linux-android wasm32-pyodide2024 wasm32-pyodide2025 arm64-apple-ios arm64-apple-ios-simulator x86_64-apple-ios-simulator" -- "${cur}"))
                    return 0
                    ;;
                --upgrade-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -P)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reinstall-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --resolution)
                    COMPREPLY=($(compgen -W "highest lowest lowest-direct" -- "${cur}"))
                    return 0
                    ;;
                --prerelease)
                    COMPREPLY=($(compgen -W "disallow allow if-necessary explicit if-necessary-or-explicit" -- "${cur}"))
                    return 0
                    ;;
                --fork-strategy)
                    COMPREPLY=($(compgen -W "fewest requires-python" -- "${cur}"))
                    return 0
                    ;;
                --config-setting)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -C)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config-setting-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-isolation-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --exclude-newer-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --link-mode)
                    COMPREPLY=($(compgen -W "clone copy hardlink symlink" -- "${cur}"))
                    return 0
                    ;;
                --no-sources-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-binary-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__tool__subcmd__uvx)
            opts="-w -c -b -i -f -U -P -C -p -V -n -q -v -h --from --with --with-editable --with-requirements --constraints --build-constraints --overrides --isolated --env-file --no-env-file --index --default-index --index-url --extra-index-url --find-links --no-index --upgrade --no-upgrade --upgrade-package --upgrade-group --reinstall --no-reinstall --reinstall-package --index-strategy --keyring-provider --resolution --prerelease --pre --fork-strategy --config-setting --config-settings-package --no-build-isolation --no-build-isolation-package --build-isolation --exclude-newer --exclude-newer-package --link-mode --compile-bytecode --no-compile-bytecode --no-sources --no-sources-package --no-build --build --no-build-package --no-binary --binary --no-binary-package --refresh --no-refresh --refresh-package --lfs --python --show-resolution --python-platform --torch-backend --generate-shell-completion --version --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --from)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --with)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -w)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --with-editable)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --with-requirements)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --constraints)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                -c)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --build-constraints)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                -b)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --overrides)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --env-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -P)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --upgrade-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reinstall-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --resolution)
                    COMPREPLY=($(compgen -W "highest lowest lowest-direct" -- "${cur}"))
                    return 0
                    ;;
                --prerelease)
                    COMPREPLY=($(compgen -W "disallow allow if-necessary explicit if-necessary-or-explicit" -- "${cur}"))
                    return 0
                    ;;
                --fork-strategy)
                    COMPREPLY=($(compgen -W "fewest requires-python" -- "${cur}"))
                    return 0
                    ;;
                --config-setting)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -C)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --config-settings-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-build-isolation-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --link-mode)
                    COMPREPLY=($(compgen -W "clone copy hardlink symlink" -- "${cur}"))
                    return 0
                    ;;
                --no-sources-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-binary-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --refresh-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --python-platform)
                    COMPREPLY=($(compgen -W "windows linux macos x86_64-pc-windows-msvc aarch64-pc-windows-msvc i686-pc-windows-msvc x86_64-unknown-linux-gnu aarch64-apple-darwin x86_64-apple-darwin aarch64-unknown-linux-gnu aarch64-unknown-linux-musl x86_64-unknown-linux-musl riscv64-unknown-linux x86_64-manylinux2014 x86_64-manylinux_2_17 x86_64-manylinux_2_28 x86_64-manylinux_2_31 x86_64-manylinux_2_32 x86_64-manylinux_2_33 x86_64-manylinux_2_34 x86_64-manylinux_2_35 x86_64-manylinux_2_36 x86_64-manylinux_2_37 x86_64-manylinux_2_38 x86_64-manylinux_2_39 x86_64-manylinux_2_40 aarch64-manylinux2014 aarch64-manylinux_2_17 aarch64-manylinux_2_28 aarch64-manylinux_2_31 aarch64-manylinux_2_32 aarch64-manylinux_2_33 aarch64-manylinux_2_34 aarch64-manylinux_2_35 aarch64-manylinux_2_36 aarch64-manylinux_2_37 aarch64-manylinux_2_38 aarch64-manylinux_2_39 aarch64-manylinux_2_40 aarch64-linux-android x86_64-linux-android wasm32-pyodide2024 wasm32-pyodide2025 arm64-apple-ios arm64-apple-ios-simulator x86_64-apple-ios-simulator" -- "${cur}"))
                    return 0
                    ;;
                --torch-backend)
                    COMPREPLY=($(compgen -W "auto cpu cu130 cu129 cu128 cu126 cu125 cu124 cu123 cu122 cu121 cu120 cu118 cu117 cu116 cu115 cu114 cu113 cu112 cu111 cu110 cu102 cu101 cu100 cu92 cu91 cu90 cu80 rocm7.2 rocm7.1 rocm7.0 rocm6.4 rocm6.3 rocm6.2.4 rocm6.2 rocm6.1 rocm6.0 rocm5.7 rocm5.6 rocm5.5 rocm5.4.2 rocm5.4 rocm5.3 rocm5.2 rocm5.1.1 rocm4.2 rocm4.1 rocm4.0.1 xpu" -- "${cur}"))
                    return 0
                    ;;
                --generate-shell-completion)
                    COMPREPLY=($(compgen -W "bash elvish fish nushell powershell zsh" -- "${cur}"))
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__tree)
            opts="-d -i -f -U -P -C -p -n -q -v -h --universal --depth --prune --package --no-dedupe --invert --outdated --show-sizes --dev --only-dev --no-dev --group --no-group --no-default-groups --only-group --all-groups --locked --frozen --no-build --build --no-build-package --no-binary --binary --no-binary-package --index --default-index --index-url --extra-index-url --find-links --no-index --upgrade --no-upgrade --upgrade-package --upgrade-group --index-strategy --keyring-provider --resolution --prerelease --pre --fork-strategy --config-setting --config-settings-package --no-build-isolation --no-build-isolation-package --build-isolation --exclude-newer --exclude-newer-package --link-mode --no-sources --no-sources-package --script --python-version --python-platform --python --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --depth)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -d)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --prune)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --only-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-binary-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -P)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --resolution)
                    COMPREPLY=($(compgen -W "highest lowest lowest-direct" -- "${cur}"))
                    return 0
                    ;;
                --prerelease)
                    COMPREPLY=($(compgen -W "disallow allow if-necessary explicit if-necessary-or-explicit" -- "${cur}"))
                    return 0
                    ;;
                --fork-strategy)
                    COMPREPLY=($(compgen -W "fewest requires-python" -- "${cur}"))
                    return 0
                    ;;
                --config-setting)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -C)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config-settings-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-isolation-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --exclude-newer-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --link-mode)
                    COMPREPLY=($(compgen -W "clone copy hardlink symlink" -- "${cur}"))
                    return 0
                    ;;
                --no-sources-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --script)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                --python-version)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --python-platform)
                    COMPREPLY=($(compgen -W "windows linux macos x86_64-pc-windows-msvc aarch64-pc-windows-msvc i686-pc-windows-msvc x86_64-unknown-linux-gnu aarch64-apple-darwin x86_64-apple-darwin aarch64-unknown-linux-gnu aarch64-unknown-linux-musl x86_64-unknown-linux-musl riscv64-unknown-linux x86_64-manylinux2014 x86_64-manylinux_2_17 x86_64-manylinux_2_28 x86_64-manylinux_2_31 x86_64-manylinux_2_32 x86_64-manylinux_2_33 x86_64-manylinux_2_34 x86_64-manylinux_2_35 x86_64-manylinux_2_36 x86_64-manylinux_2_37 x86_64-manylinux_2_38 x86_64-manylinux_2_39 x86_64-manylinux_2_40 aarch64-manylinux2014 aarch64-manylinux_2_17 aarch64-manylinux_2_28 aarch64-manylinux_2_31 aarch64-manylinux_2_32 aarch64-manylinux_2_33 aarch64-manylinux_2_34 aarch64-manylinux_2_35 aarch64-manylinux_2_36 aarch64-manylinux_2_37 aarch64-manylinux_2_38 aarch64-manylinux_2_39 aarch64-manylinux_2_40 aarch64-linux-android x86_64-linux-android wasm32-pyodide2024 wasm32-pyodide2025 arm64-apple-ios arm64-apple-ios-simulator x86_64-apple-ios-simulator" -- "${cur}"))
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__venv)
            opts="-p -c -i -f -n -q -v -h --python --system --no-system --no-project --seed --clear --force --no-clear --allow-existing --prompt --system-site-packages --relocatable --no-relocatable --index --default-index --index-url --extra-index-url --find-links --no-index --index-strategy --keyring-provider --exclude-newer --exclude-newer-package --link-mode --refresh --no-refresh --refresh-package --no-seed --no-pip --no-setuptools --no-wheel --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help [PATH]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --prompt)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --exclude-newer-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --link-mode)
                    COMPREPLY=($(compgen -W "clone copy hardlink symlink" -- "${cur}"))
                    return 0
                    ;;
                --refresh-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__version)
            opts="-i -f -U -P -C -p -n -q -v -h --bump --dry-run --short --output-format --no-sync --active --no-active --locked --frozen --index --default-index --index-url --extra-index-url --find-links --no-index --upgrade --no-upgrade --upgrade-package --upgrade-group --reinstall --no-reinstall --reinstall-package --index-strategy --keyring-provider --resolution --prerelease --pre --fork-strategy --config-setting --config-settings-package --no-build-isolation --no-build-isolation-package --build-isolation --exclude-newer --exclude-newer-package --link-mode --compile-bytecode --no-compile-bytecode --no-sources --no-sources-package --no-build --build --no-build-package --no-binary --binary --no-binary-package --refresh --no-refresh --refresh-package --package --python --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help [VALUE]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --bump)
                    COMPREPLY=($(compgen -W "major minor patch stable alpha beta rc post dev" -- "${cur}"))
                    return 0
                    ;;
                --output-format)
                    COMPREPLY=($(compgen -W "text json" -- "${cur}"))
                    return 0
                    ;;
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -P)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --upgrade-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reinstall-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --resolution)
                    COMPREPLY=($(compgen -W "highest lowest lowest-direct" -- "${cur}"))
                    return 0
                    ;;
                --prerelease)
                    COMPREPLY=($(compgen -W "disallow allow if-necessary explicit if-necessary-or-explicit" -- "${cur}"))
                    return 0
                    ;;
                --fork-strategy)
                    COMPREPLY=($(compgen -W "fewest requires-python" -- "${cur}"))
                    return 0
                    ;;
                --config-setting)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -C)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --config-settings-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-build-isolation-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --link-mode)
                    COMPREPLY=($(compgen -W "clone copy hardlink symlink" -- "${cur}"))
                    return 0
                    ;;
                --no-sources-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-binary-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --refresh-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__workspace)
            opts="-n -q -v -h --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help metadata dir list"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__workspace__subcmd__dir)
            opts="-n -q -v -h --package --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__workspace__subcmd__list)
            opts="-n -q -v -h --paths --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        uv__subcmd__workspace__subcmd__metadata)
            opts="-i -f -U -P -C -p -n -q -v -h --locked --frozen --dry-run --index --default-index --index-url --extra-index-url --find-links --no-index --upgrade --no-upgrade --upgrade-package --upgrade-group --index-strategy --keyring-provider --resolution --prerelease --pre --fork-strategy --config-setting --config-settings-package --no-build-isolation --no-build-isolation-package --build-isolation --exclude-newer --exclude-newer-package --link-mode --no-sources --no-sources-package --no-build --build --no-build-package --no-binary --binary --no-binary-package --refresh --no-refresh --refresh-package --sync --python --no-cache --cache-dir --python-preference --managed-python --no-managed-python --allow-python-downloads --no-python-downloads --python-fetch --quiet --verbose --no-color --color --native-tls --no-native-tls --system-certs --no-system-certs --offline --no-offline --allow-insecure-host --preview --no-preview --preview-features --isolated --show-settings --no-progress --no-installer-metadata --directory --project --config-file --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-index)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --extra-index-url)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --find-links)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -P)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --upgrade-group)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --index-strategy)
                    COMPREPLY=($(compgen -W "first-index unsafe-first-match unsafe-best-match" -- "${cur}"))
                    return 0
                    ;;
                --keyring-provider)
                    COMPREPLY=($(compgen -W "disabled subprocess" -- "${cur}"))
                    return 0
                    ;;
                --resolution)
                    COMPREPLY=($(compgen -W "highest lowest lowest-direct" -- "${cur}"))
                    return 0
                    ;;
                --prerelease)
                    COMPREPLY=($(compgen -W "disallow allow if-necessary explicit if-necessary-or-explicit" -- "${cur}"))
                    return 0
                    ;;
                --fork-strategy)
                    COMPREPLY=($(compgen -W "fewest requires-python" -- "${cur}"))
                    return 0
                    ;;
                --config-setting)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -C)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config-settings-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-isolation-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --exclude-newer)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --exclude-newer-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --link-mode)
                    COMPREPLY=($(compgen -W "clone copy hardlink symlink" -- "${cur}"))
                    return 0
                    ;;
                --no-sources-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-build-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --no-binary-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --refresh-package)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --python)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                -p)
                    COMPREPLY=("${cur}")
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o nospace
                    fi
                    return 0
                    ;;
                --cache-dir)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --python-preference)
                    COMPREPLY=($(compgen -W "only-managed managed system only-system" -- "${cur}"))
                    return 0
                    ;;
                --python-fetch)
                    COMPREPLY=($(compgen -W "automatic manual never" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --allow-insecure-host)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preview-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --directory)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --project)
                    COMPREPLY=()
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o plusdirs
                    fi
                    return 0
                    ;;
                --config-file)
                    local oldifs
                    if [ -n "${IFS+x}" ]; then
                        oldifs="$IFS"
                    fi
                    IFS=$'\n'
                    COMPREPLY=($(compgen -f "${cur}"))
                    if [ -n "${oldifs+x}" ]; then
                        IFS="$oldifs"
                    fi
                    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
                        compopt -o filenames
                    fi
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
    complete -F _uv -o nosort -o bashdefault -o default uv
else
    complete -F _uv -o bashdefault -o default uv
fi
