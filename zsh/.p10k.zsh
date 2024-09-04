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

  # Unset all configuration options. This allows you to apply configuration changes without
  # restarting zsh. Edit ~/.p10k.zsh and type `source ~/.p10k.zsh`.
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Zsh >= 5.1 is required.
  [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

  # Load PROMPT-ELEMENT (search below for details on each)
  declare -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    virtualenv              # python virtual environment (https://docs.python.org/3/library/venv.html)
    anaconda                # conda environment (https://conda.io/)
    pyenv                   # python environment (https://github.com/pyenv/pyenv)
    context                 # user@hostname
    dir                     # current directory
    vcs                     # git status
    command_execution_time  # duration of the last command
    status                  # exit code of the last command
    prompt_char             # prompt symbol
  )
  declare -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

  # Define character set
  declare -g POWERLEVEL9K_MODE=powerline
  declare -g POWERLEVEL9K_ICON_PADDING=none

  # Define macro styling options
  declare -g POWERLEVEL9K_BACKGROUND=''                            # transparent background
  declare -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=''  # no surrounding whitespace
  declare -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '    # separate segments with a space

  # Add an empty line before each prompt.
  declare -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

  # Configurations related to transient and instant prompt and reloading
  declare -g POWERLEVEL9K_TRANSIENT_PROMPT=always
  declare -g POWERLEVEL9K_INSTANT_PROMPT=quiet
  declare -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  # ····································································································
  # PROMPT-ELEMENT virtualenv: python virtual environment (https://docs.python.org/3/library/venv.html)
  # ····································································································
  # Python virtual environment color.
  declare -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=$bright_blue
  # Don't show Python version next to the virtual environment name.
  declare -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  # If set to "false", won't show virtualenv if pyenv is already shown.
  # If set to "if-different", won't show virtualenv if it's the same as pyenv.
  declare -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=false
  # Separate environment name from Python version only with a space.
  declare -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=
  declare -g POWERLEVEL9K_VIRTUALENV_VISUAL_IDENTIFIER_EXPANSION=''

  # ····································································································
  # PROMPT-ELEMENT anaconda: conda environment (https://conda.io/)
  # ····································································································
  declare -g POWERLEVEL9K_ANACONDA_FOREGROUND=$bright_blue
  # Anaconda segment format. The following parameters are available within the expansion.
  #
  # - CONDA_PREFIX                 Absolute path to the active Anaconda/Miniconda environment.
  # - CONDA_DEFAULT_ENV            Name of the active Anaconda/Miniconda environment.
  # - CONDA_PROMPT_MODIFIER        Configurable prompt modifier (see below).
  # - P9K_ANACONDA_PYTHON_VERSION  Current python version (python --version).
  #
  # CONDA_PROMPT_MODIFIER can be configured with the following command:
  #
  #   conda config --set env_prompt '({default_env}) '
  #
  # The last argument is a Python format string that can use the following variables:
  #
  # - prefix       The same as CONDA_PREFIX.
  # - default_env  The same as CONDA_DEFAULT_ENV.
  # - name         The last segment of CONDA_PREFIX.
  # - stacked_env  Comma-separated list of names in the environment stack. The first element is
  #                always the same as default_env.
  #
  # Note: '({default_env}) ' is the default value of env_prompt.
  #
  # The default value of POWERLEVEL9K_ANACONDA_CONTENT_EXPANSION expands to $CONDA_PROMPT_MODIFIER
  # without the surrounding parentheses, or to the last path component of CONDA_PREFIX if the former
  # is empty.
  declare -g POWERLEVEL9K_ANACONDA_CONTENT_EXPANSION='${${${${CONDA_PROMPT_MODIFIER#\(}% }%\)}:-${CONDA_PREFIX:t}}'
  declare -g POWERLEVEL9K_ANACONDA_VISUAL_IDENTIFIER_EXPANSION=''
  
  # ····································································································
  # PROMPT-ELEMENT pyenv: python environment (https://github.com/pyenv/pyenv)
  # ····································································································
  declare -g POWERLEVEL9K_PYENV_FOREGROUND=$bright_blue
  # Hide python version if it doesn't come from one of these sources.
  declare -g POWERLEVEL9K_PYENV_SOURCES=(shell local global)
  # If set to false, hide python version if it's the same as global:
  # $(pyenv version-name) == $(pyenv global).
  declare -g POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW=false
  # If set to false, hide python version if it's equal to "system".
  declare -g POWERLEVEL9K_PYENV_SHOW_SYSTEM=true

  # Pyenv segment format. The following parameters are available within the expansion.
  #
  # - P9K_CONTENT                Current pyenv environment (pyenv version-name).
  # - P9K_PYENV_PYTHON_VERSION   Current python version (python --version).
  #
  # The default format has the following logic:
  #
  # 1. Display just "$P9K_CONTENT" if it's equal to "$P9K_PYENV_PYTHON_VERSION" or
  #    starts with "$P9K_PYENV_PYTHON_VERSION/".
  # 2. Otherwise display "$P9K_CONTENT $P9K_PYENV_PYTHON_VERSION".
  declare -g POWERLEVEL9K_PYENV_CONTENT_EXPANSION='${P9K_CONTENT}${${P9K_CONTENT:#$P9K_PYENV_PYTHON_VERSION(|/*)}:+ $P9K_PYENV_PYTHON_VERSION}'
 
  # ····································································································
  # PROMPT-ELEMENT context: user@hostname
  # ····································································································
  # Context format when running with privileges: user@hostname.
  declare -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=$red
  declare -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%n%7F@%1F%m'
  # Context format when in SSH without privileges: user@hostname.
  declare -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND=$yellow
  declare -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_TEMPLATE='%n%7F@%3F%m'
  # Default context format (no privileges, no SSH): user@hostname.
  declare -g POWERLEVEL9K_CONTEXT_FOREGROUND=$green
  declare -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n%7F@%2F%m'

  # Don't show context unless running with privileges or in SSH.
  # Comment below to always show context.
  declare -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=

  # ····································································································
  # PROMPT-ELEMENT dir: current directory
  # ····································································································
  declare -g POWERLEVEL9K_DIR_FOREGROUND=$magenta
  declare -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
  # Enable special styling for non-writable or non-existent directories
  declare -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v2 # non-writable
  declare -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3 # non-writable and non-existent
  declare -g POWERLEVEL9K_LOCK_ICON='%F{$red}∅%f'
  # ····································································································
  # PROMPT-ELEMENT vcs: git status 
  # ····································································································
  # declare -g POWERLEVEL9K_VCS_BRANCH_ICON='\UE0A0 '

  declare -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

  # Formatter for Git status.
  #
  # Example output: main wip ⇣42⇡42 *42 merge ~42 +42 !42 ?42.
  #
  # VCS_STATUS_* parameters are set by gitstatus plugin. See reference:
  # https://github.com/romkatv/gitstatus/blob/master/gitstatus.plugin.zsh.
  my_git_formatter() {
    emulate -L zsh

    if [[ -n $P9K_CONTENT ]]; then
      # If P9K_CONTENT is not empty, use it. It's either "loading" or from vcs_info (not from
      # gitstatus plugin). VCS_STATUS_* parameters are not available in this case.
      declare -g my_git_format=$P9K_CONTENT
      return
    fi

    if (( $1 )); then
      # Styling for up-to-date Git status.
      local meta='%f'
      local clean='%4F'
      local diverged='%6F'
      local modified='%3F'
      local staged='%2F'
      local untracked='%1F'
      local conflicted='%1F'
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

    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      local branch=${(V)VCS_STATUS_LOCAL_BRANCH}
      # If local branch name is at most 32 characters long, show it in full.
      # Otherwise show the first 12 … the last 12.
      # Tip: To always show local branch name in full without truncation, delete the next line.
      (( $#branch > 32 )) && branch[13,-13]="…"  # <-- this line
      res+="${clean}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${branch//\%/%%}"
    fi

    if [[ -n $VCS_STATUS_TAG
          # Show tag only if not on a branch.
          # Tip: To always show tag, delete the next line.
          && -z $VCS_STATUS_LOCAL_BRANCH  # <-- this line
        ]]; then
      local tag=${(V)VCS_STATUS_TAG}
      # If tag name is at most 32 characters long, show it in full.
      # Otherwise show the first 12 … the last 12.
      # Tip: To always show tag name in full without truncation, delete the next line.
      (( $#tag > 32 )) && tag[13,-13]="…"  # <-- this line
      res+="${meta}#${clean}${tag//\%/%%}"
    fi

    # Display the current Git commit if there is no branch and no tag.
    # Tip: To always display the current Git commit, delete the next line.
    [[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] &&  # <-- this line
      res+="${meta}@${clean}${VCS_STATUS_COMMIT[1,8]}"

    # Show tracking branch name if it differs from local branch.
    if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
      res+="${meta}:${clean}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"
    fi

    # Display "wip" if the latest commit's summary contains "wip" or "WIP".
    if [[ $VCS_STATUS_COMMIT_SUMMARY == (|*[^[:alnum:]])(wip|WIP)(|[^[:alnum:]]*) ]]; then
      res+=" ${modified}wip"
    fi

    # ⇣42 if behind the remote.
    (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${diverged} ${VCS_STATUS_COMMITS_BEHIND}"
    # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
    (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
    (( VCS_STATUS_COMMITS_AHEAD  )) && res+="${diverged} ${VCS_STATUS_COMMITS_AHEAD}"
    # ⇠42 if behind the push remote.
    (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" ${diverged} ${VCS_STATUS_PUSH_COMMITS_BEHIND}"
    (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" "
    # ⇢42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42.
    (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && res+="${diverged} ${VCS_STATUS_PUSH_COMMITS_AHEAD}"
    # *42 if have stashes.
    (( VCS_STATUS_STASHES        )) && res+=" ${diverged}⚑${VCS_STATUS_STASHES}"
    # 'merge' if the repo is in an unusual state.
    [[ -n $VCS_STATUS_ACTION     ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}"
    # ~42 if have merge conflicts.
    (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}x${VCS_STATUS_NUM_CONFLICTED}"
    # +42 if have staged changes.
    (( VCS_STATUS_NUM_STAGED     )) && res+=" ${staged}+${VCS_STATUS_NUM_STAGED}"
    # !42 if have unstaged changes.
    (( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${modified}~${VCS_STATUS_NUM_UNSTAGED}"
    # ?42 if have untracked files. It's really a question mark, your font isn't broken.
    # See POWERLEVEL9K_VCS_UNTRACKED_ICON above if you want to use a different icon.
    # Remove the next line if you don't want to see untracked files at all.
    (( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}"
    # "─" if the number of unstaged files is unknown. This can happen due to
    # POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY (see below) being set to a non-negative number lower
    # than the number of files in the Git index, or due to bash.showDirtyState being set to false
    # in the repository config. The number of staged and untracked files may also be unknown
    # in this case.
    (( VCS_STATUS_HAS_UNSTAGED == -1 )) && res+=" ${modified}─"

    declare -g my_git_format=$res
  }
  functions -M my_git_formatter 2>/dev/null

  # Don't count the number of unstaged, untracked and conflicted files in Git repositories with
  # more than this many files in the index. Negative value means infinity.
  #
  # If you are working in Git repositories with tens of millions of files and seeing performance
  # sagging, try setting POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY to a number lower than the output
  # of `git ls-files | wc -l`. Alternatively, add `bash.showDirtyState = false` to the repository's
  # config: `git config bash.showDirtyState false`.
  declare -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1

  # Don't show Git status in prompt for repositories whose workdir matches this pattern.
  # For example, if set to '~', the Git repository at $HOME/.git will be ignored.
  # Multiple patterns can be combined with '|': '~(|/foo)|/bar/baz/*'.
  declare -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'

  # Disable the default Git status formatting.
  declare -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  # Install our own Git status formatter.
  declare -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter(1)))+${my_git_format}}'
  declare -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION='${$((my_git_formatter(0)))+${my_git_format}}'
  # Enable counters for staged, unstaged, etc.
  declare -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1

  # Icon color.
  declare -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR=$green
  declare -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR=
  # Custom icon.
  declare -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=
  # Custom prefix.
  # declare -g POWERLEVEL9K_VCS_PREFIX='%fon '

  # Show status of repositories of these types. You can add svn and/or hg if you are
  # using them. If you do, your prompt may become slow even when your current directory
  # isn't in an svn or hg repository.
  declare -g POWERLEVEL9K_VCS_BACKENDS=(git)

  # These settings are used for repositories other than Git or when gitstatusd fails and
  # Powerlevel10k has to fall back to using vcs_info.
  declare -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=$green
  declare -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=$red
  declare -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=$yellow

  # ····································································································
  # PROMPT-ELEMENT command_execution_time: duration of the last command
  # ····································································································
  # Show duration of the last command if takes at least this many seconds.
  declare -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
  # Show this many fractional digits. Zero means round to seconds.
  declare -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
  # Execution time color.
  declare -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$black
  # Duration format: 1d 2h 3m 4s.
  declare -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'

  # ····································································································
  # PROMPT-ELEMENT status: exit code of the last command
  # ····································································································
  # Enable OK_PIPE, ERROR_PIPE and ERROR_SIGNAL status states to allow us to enable, disable and style them independently from the regular OK and ERROR state.
  declare -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true

  # Status on success. No content, just an icon. No need to show it if prompt_char is enabled as it will signify success by turning green.
  declare -g POWERLEVEL9K_STATUS_OK=false
  declare -g POWERLEVEL9K_STATUS_OK_FOREGROUND=$green
  declare -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='✔'

  # Status when some part of a pipe command fails but the overall exit status is zero. It may look
  # like this: 1|0.
  declare -g POWERLEVEL9K_STATUS_OK_PIPE=true
  declare -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=$green
  declare -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION='✔'

  # Status when it's just an error code (e.g., '1'). No need to show it if prompt_char is enabled as it will signify error by turning red.
  declare -g POWERLEVEL9K_STATUS_ERROR=false
  declare -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=$red
  declare -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'

  # Status when the last command was terminated by a signal.
  declare -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
  declare -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=$red
  # Use terse signal names: "INT" instead of "SIGINT(2)".
  declare -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false
  declare -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION='✘'

  # Status when some part of a pipe command fails and the overall exit status is also non-zero: i.e 1|1|0
  declare -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
  declare -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=$red
  declare -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION='✘'
  
  # ····································································································
  # PROMPT-ELEMENT prompt_char: prompt symbol
  # ····································································································
  # White prompt symbol if the last command succeeded.
  declare -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$white
  # Red prompt symbol if the last command failed.
  declare -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$bright_red
  # Default prompt symbol.
  declare -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='ᐷ'
  # Prompt symbol in command vi mode.
  declare -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='%F{$yellow}%f'
  # Prompt symbol in visual vi mode.
  declare -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
  # Prompt symbol in overwrite vi mode.
  declare -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
  declare -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
  # No line terminator if prompt_char is the last segment.
  declare -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  # No line introducer if prompt_char is the first segment.
  declare -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=


  # If p10k is already loaded, reload configuration.
  (( ! $+functions[p10k] )) || p10k reload
}

# Tell `p10k configure` which file it should overwrite.
declare -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
