source "${0:A:h}/common-aliases.zsh"
source "${0:A:h}/git-aliases.zsh"

alias -- -="z -"
alias ~="cd $HOME"
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

alias cat='bat -p'
alias emptytrash='rm -rf "$HOME/.Trash/*"'
alias list-aliases='alias'
alias list-colors='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+"\n"}; done'
alias list-env-vars='env'
alias list-fpath='print -l $fpath'
alias list-functions='print -l ${(ok)functions[(I)[^_]*]}'
alias list-path='print -l $path'
alias list-plugins='print -l $plugins'
alias mycli='mycli --myclirc ~/.config/mycli/.myclirc'
alias rmdsstore='sudo find / -name ".DS_Store" -depth -exec rm {} &>/dev/null'
alias rmgdrive='rm -rf "$HOME/Google Drive"'
# alias stable_diffusion="cd $HOME/BuddyAI Dropbox/Vivek Jha/Developer/Repos3P/stable-diffusion-webui; ./webui.sh --no-half"
alias sysinfo='system_profiler SPSoftwareDataType SPHardwareDataType'
