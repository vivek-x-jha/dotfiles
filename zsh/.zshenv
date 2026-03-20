# XDG: https://specifications.freedesktop.org/basedir-spec/latest/#variables
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Zsh: https://zsh.sourceforge.io/Intro/intro_3.html
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Zsh/Bash: https://superuser.com/q/1610587/930403
export SHELL_SESSIONS_DISABLE=1

# Zap: https://github.com/zap-zsh/zap?tab=readme-ov-file#example-usage
export ZAP_GIT_PREFIX='git@github.com:'

# Editor: https://wiki.archlinux.org/title/Environment_variables#Default_programs
export EDITOR=nvim
export VISUAL="$EDITOR"
export NVIM_LOG_FILE="$XDG_STATE_HOME/nvim/.nvimlog"

# Pager: https://github.com/sharkdp/bat?tab=readme-ov-file#man
[[ -f $XDG_CONFIG_HOME/bat/config ]] && {
  export PAGER='bat -p'
  export MANPAGER="sh -c 'col -bx | bat -pl man --paging=always --theme=sourdiesel'"
}

# Less: # https://man7.org/linux/man-pages/man1/less.1.html
export LESSHISTFILE="$XDG_STATE_HOME/less/.lesshst"

# MySQL: # https://dev.mysql.com/doc/refman/9.5/en/environment-variables.html
export MYSQL_HISTFILE="$XDG_STATE_HOME/mysql/.mysql_history"

# MyCLI: https://www.mycli.net/config
export MYCLI_HISTFILE="$XDG_STATE_HOME/mycli/.mycli_history"

# Python: https://docs.python.org/3/using/cmdline.html#envvar-PYTHON_HISTORY
export PYTHON_HISTORY="$XDG_STATE_HOME/python/.python_history"

# Rust toolchain
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# TPM: https://github.com/tmux-plugins/tpm/blob/master/docs/changing_plugins_install_dir.md#changing-plugins-install-dir
export TMUX_PLUGIN_MANAGER_PATH="$XDG_DATA_HOME/tmux/plugins"

# Tmux fzf: https://github.com/sainnhe/tmux-fzf?tab=readme-ov-file#key-binding
export TMUX_FZF_LAUNCH_KEY='f'
export TMUX_FZF_OPTIONS="-p -w 75% -h 50% -m"

# 1password: https://developer.1password.com/docs/cli/shell-plugins
export OP_PLUGIN_ALIASES_SOURCED=1

# Eza: https://man.archlinux.org/man/eza_colors.5.en
export EZA_COLORS="nb=00;38;5;0:nk=00;38;5;7:nm=00;38;5;3:ng=00;38;5;1:nt=00;38;5;6:lp=00;38;5;4:"

# Ripgrep: https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

# Zoxide: https://github.com/ajeetdsouza/zoxide#environment-variables
export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"

# Codex: https://github.com/openai/codex/pull/4414
export CODEX_HOME="$XDG_STATE_HOME/codex"

# Shell color palette
source "$ZDOTDIR/themes/sourdiesel.sh"

# Homebrew (MacOS only)
[[ $(uname) == Darwin ]] && {
  export HOMEBREW_NO_ENV_HINTS=1
  export HOMEBREW_INSTALL_BADGE='📦'
  export HOMEBREW_BUNDLE_FILE="$HOME/.dotfiles/manifests/Brewfile"
}

# Fzf: https://junegunn.github.io/fzf/
showdir="$(command -v tree &>/dev/null && echo 'tree -aCI \".git|.github\" {}' || echo 'ls -lAh {}')"
showfile="$(command -v bat &>/dev/null && echo 'bat --color=always --style=changes {}' || echo 'cat {}')"
findfile="$(command -v fd &>/dev/null && echo 'fd --type f' || echo 'find . -type f')"

# https://github.com/junegunn/fzf?tab=readme-ov-file#environment-variables
export FZF_DEFAULT_COMMAND="$findfile"

export FZF_DEFAULT_OPTS="
  --style full
  --layout reverse
  --tmux center
  --border
  --header-first
  --padding 1,2
  --walker-skip .git,node_modules,target
  --no-bold

  --border-label '  fuzzy search '
  --color border:$BRIGHTBLACK_HEX
  --color label:$MAGENTA_HEX

  --header-label ' command '
  --header '$FZF_DEFAULT_COMMAND'
  --color header:$GREEN_HEX
  --color header-border:$BRIGHTBLACK_HEX
  --color header-label:$RED_HEX

  --preview-label ' preview '
  --preview '[[ -d {} ]] && $showdir || $showfile'
  --bind 'ctrl-/:change-preview-window(hidden|)'
  --color preview-border:$BRIGHTBLACK_HEX
  --color preview-label:$CYAN_HEX

  --input-label ' query '
  --color query:$WHITE_HEX
  --color input-border:$BRIGHTBLACK_HEX
  --color input-label:$BLUE_HEX
  --color prompt:$BRIGHTYELLOW_HEX
  --color spinner:$CYAN_HEX
  --color info:$BRIGHTMAGENTA_HEX
  --prompt '  '

  --list-label ' results '
  --color list-border:$BRIGHTBLACK_HEX
  --color list-label:$YELLOW_HEX
  --color marker:$CYAN_HEX
  --color pointer:$MAGENTA_HEX
  --color fg:$BRIGHTBLACK_HEX
  --color fg+:$WHITE_HEX
  --color bg+:-1
  --color hl:$BLACK_HEX
  --color hl+:$RED_HEX:bold
  --gutter ' '
  --marker '* '
  --pointer '󰶻'
"

# https://junegunn.github.io/fzf/shell-integration/#alt-c
export FZF_ALT_C_OPTS="
  --header 'builtin cd --'
  --border-label ' 󰉖 jump subdir '
"

# https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#environment-variables
export _ZO_FZF_OPTS="
  $FZF_DEFAULT_OPTS
  --header 'zoxide query --interactive'
  --border-label ' 󰉖 jump list '
  --preview 'echo {} | cut -f2- | xargs -I{} $showdir'
"
