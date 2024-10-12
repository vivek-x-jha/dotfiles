# Powerlevel10k Theme configuration

# Load base theme file
[ -f "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" ] || brew install powerlevel10k
source "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme"

# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Unset all configuration options
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Zsh >= 5.1 is required
  [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

  # Prompt colors
  local black='0'
  local red='1'
  local yellow='3'
  local blue='4'
  local magenta='5'
  local cyan='6'
  local white='7'

  # Prompt segments
  declare -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    context                # user@host
    virtualenv             # python virtual environment
    pyenv                  # python virtual environment
    dir                    # current directory
    vcs                    # git status
    command_execution_time # previous command duration
    status                 # previous command exit code
    newline                # \n
    prompt_char            # prompt symbol
  )
  declare -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=

  # Prompt options
  declare -g POWERLEVEL9K_BACKGROUND=                            # transparent background
  declare -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=  # no surrounding whitespace
  declare -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '  # separate segments with a space
  declare -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=        # no end-of-line symbol
  declare -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION=           # no segment icons

  declare -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true                # Add an empty line before each prompt except the first

  declare -g POWERLEVEL9K_TRANSIENT_PROMPT=always                # enable transient prompt
  declare -g POWERLEVEL9K_INSTANT_PROMPT=quiet                   # supress instant prompt errors
  declare -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true                # prevent option editing on the fly

  # Configure context:
  declare -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION= # hide unless running w/ privileges or ssh
  declare -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE="%F{$white}%n%f%F{$yellow}@%m%f"        # running ssh with privileges
  declare -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_TEMPLATE="%F{$green}%n@%m%f"     # running ssh w/o privileges

  # Configure dir
  declare -g POWERLEVEL9K_DIR_FOREGROUND=$blue

  # Configure vcs
  declare -g POWERLEVEL9K_VCS_LOADING_TEXT=              # disable async loading indicator
  declare -g POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS=0 # updates asynchronously continuously
  declare -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

  my_git_formatter() {
    # Example output: main WIP  42  42 *42 merge !42 +42 ~42 ?42
    # VCS_STATUS_* parameters are set by gitstatus plugin:
    # https://github.com/romkatv/gitstatus/blob/master/gitstatus.plugin.zsh

    emulate -L zsh

    # Format with P9K_CONTENT when set - VCS_STATUS_* params will be unavailable
    [[ -n $P9K_CONTENT ]] && declare -g my_git_format=$P9K_CONTENT && return

    if (( $1 )); then
      # Styling for up-to-date Git status.
      local meta='%f'
      local clean='%5F'
      local diverged='%12F'
      local stashed='%248F'
      local modified='%3F'
      local staged='%2F'
      local untracked='%1F'
      local conflicted='%9F'

    else
      # Styling for incomplete and stale Git status.
      local meta='%f'
      local clean='%f'
      local modified='%f'
      local staged='%f'
      local untracked='%f'
      local conflicted='%f'
    fi

    local res

    # Truncate branch name to 'first 12 … last 12' if longer than 32 chars
    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      local branch=${(V)VCS_STATUS_LOCAL_BRANCH}
      (( $#branch > 32 )) && branch[13,-13]="…"
      res+="${clean}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${branch//\%/%%}"
    fi

    # Show tag if not on a branch
    # Truncate tag name to 'first 12 … last 12' if longer than 32 chars
    if [[ -n $VCS_STATUS_TAG && -z $VCS_STATUS_LOCAL_BRANCH ]]; then
      local tag=${(V)VCS_STATUS_TAG}
      (( $#tag > 32 )) && tag[13,-13]="…"
      res+="${meta}#${clean}${tag//\%/%%}"
    fi

    # Display current Git commit if there is no branch or tag
    [[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] && res+="${meta}@${clean}${VCS_STATUS_COMMIT[1,8]}"

    # Show tracking branch name if it differs from local branch
    [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]] && res+="${meta}:${clean}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"

    # Display "WIP" if the latest commit's summary contains "wip" or "WIP"
    [[ $VCS_STATUS_COMMIT_SUMMARY == (|*[^[:alnum:]])(wip|WIP)(|[^[:alnum:]]*) ]] && res+=" ${modified}WIP"

    #  42 if behind the remote.
    (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${diverged} ${VCS_STATUS_COMMITS_BEHIND}"

    #  42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42
    (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
    (( VCS_STATUS_COMMITS_AHEAD )) && res+="${diverged} ${VCS_STATUS_COMMITS_AHEAD}"

    #  42 if behind the push remote.
    (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" ${diverged} ${VCS_STATUS_PUSH_COMMITS_BEHIND}"
    (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" "

    #  42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42
    (( VCS_STATUS_PUSH_COMMITS_AHEAD )) && res+="${diverged} ${VCS_STATUS_PUSH_COMMITS_AHEAD}"

    # 'merge' if the repo is in an unusual state
    [[ -n $VCS_STATUS_ACTION ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}"

    # !42 if have merge conflicts
    (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}!${VCS_STATUS_NUM_CONFLICTED}"

    # +42 if have staged changes
    (( VCS_STATUS_NUM_STAGED )) && res+=" ${staged}+${VCS_STATUS_NUM_STAGED}"

    # ~42 if have unstaged changes
    (( VCS_STATUS_NUM_UNSTAGED )) && res+=" ${modified}~${VCS_STATUS_NUM_UNSTAGED}"

    # *42 if have stashes.
    (( VCS_STATUS_STASHES )) && res+=" ${stashed}*${VCS_STATUS_STASHES}"

    # ?42 if have untracked files
    (( VCS_STATUS_NUM_UNTRACKED )) && res+=" ${untracked}${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}"

    # "─" if number of unstaged files is unknown - can happen due to:
    # POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY >= 0 and < number of files in Git repo
    # bash.showDirtyState = false in the repository config - the number of staged and untracked files may also be unknown
    (( VCS_STATUS_HAS_UNSTAGED == -1 )) && res+=" ${modified}─"

    declare -g my_git_format=$res
  }
  functions -M my_git_formatter 2>/dev/null

  declare -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1 # count all files in the index
  declare -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true  # disable default Git status formatting
  declare -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter(1)))+${my_git_format}}'  # Install our own Git status formatter
  declare -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION='${$((my_git_formatter(0)))+${my_git_format}}'
  declare -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1 # Enable counters for staged, unstaged, etc
  declare -g POWERLEVEL9K_VCS_BACKENDS=(git) # Show status of repositories of these types

  # Configure command_execution_time
  declare -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$black
  declare -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  declare -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0       # Always show
  declare -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=2       # Use 2 decimals

  # Configure status
  declare -g POWERLEVEL9K_STATUS_OK=false                                     # Hide when prompt_char enabled
  declare -g POWERLEVEL9K_STATUS_ERROR=false                                  # Hide when prompt_char enabled
  declare -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true                         # Allow OK_PIPE, ERROR_PIPE and ERROR_SIGNAL

  declare -g POWERLEVEL9K_STATUS_OK_PIPE=true                                 # Show when piped last command succeeds: i.e. 0|1|0
  declare -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=$green
  declare -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION='✔'
  
  declare -g POWERLEVEL9K_STATUS_ERROR_PIPE=true                              # Show when piped last command fails: i.e. 1|0|0|1 
  declare -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=$red
  declare -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION='✘'
  
  declare -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true                            # Show when last command terminated by a signal
  declare -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false                        # Use terse signal names: "INT" instead of "SIGINT(2)"
  declare -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=$red
  declare -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION='✘'
  
  # Configure virtualenv
  declare -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=$yellow
  declare -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false      # hide version number
  declare -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=
  declare -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=false          # hide when pyenv active
  declare -g POWERLEVEL9K_VIRTUALENV_VISUAL_IDENTIFIER_EXPANSION='' # no icon
  
  # Configure pyenv
  declare -g POWERLEVEL9K_PYENV_FOREGROUND=$yellow
  declare -g POWERLEVEL9K_PYENV_SOURCES=(shell local global) # hide python version if not from given sources
  declare -g POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW=false     # hide python version if same as global
  declare -g POWERLEVEL9K_PYENV_SHOW_SYSTEM=true             # hide python version if same as system

  # Current pyenv environment: P9K_CONTENT="$(pyenv version-name)"
  # Current python version:    P9K_PYENV_PYTHON_VERSION="$(python --version)"
  #
  # 1. Display just "$P9K_CONTENT" if it's equal to "$P9K_PYENV_PYTHON_VERSION" or starts with "$P9K_PYENV_PYTHON_VERSION/"
  # 2. Otherwise display "$P9K_CONTENT $P9K_PYENV_PYTHON_VERSION"
  declare -g POWERLEVEL9K_PYENV_CONTENT_EXPANSION='${P9K_CONTENT}${${P9K_CONTENT:#$P9K_PYENV_PYTHON_VERSION(|/*)}:+ $P9K_PYENV_PYTHON_VERSION}'
 
  # Configure prompt_char
  declare -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION=''              # Default Prompt Symbol
  declare -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$white      # Last Command Success Color
  declare -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$red     # Last Command Fail Color

  declare -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='%F{12}%f'      # Vim Command Mode Symbol
  declare -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='%F{14}%f'      # Vim Visual Mode Symbol
  declare -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'              # Vim Overwrite Mode Symbol
  declare -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true

  # If p10k is already loaded, reload configuration.
  (( ! $+functions[p10k] )) || p10k reload
}

# Tell `p10k configure` which file it should overwrite.
declare -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
