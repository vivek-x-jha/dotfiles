#!/usr/bin/env zsh

alias cl='clear'

# File Navigation
alias -- -="z -"
alias ~="cd $HOME"
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

alias tree='tree -aI .git'

# Editor
alias v='nvim'
alias vim='vim -i $XDG_STATE_HOME/vim/viminfo'
alias vi='vim'

# Unix Replacements
alias grep='grep --color=auto'
alias l='eza --all --long --git --icons=always'
alias ls='gls --color=auto'
alias cat='bat -p'

# CLI Tools
alias mycli='mycli --myclirc ~/.config/mycli/.myclirc'
alias weather='curl wttr.in'
alias chatgpt='python ~/Developer/chatgpt-cli/chatgpt.py --key=$(python ~/Developer/chatgpt-cli/auth-chatgpt-cli.py)'

# System Monitoring
alias sysinfo='system_profiler SPSoftwareDataType SPHardwareDataType'

# TODO delete below: setup cron job that does this after OS Update
alias touchid-sudo='sudo cp -f ~/.config/pam/sudo /etc/pam.d/sudo'
