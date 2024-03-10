# *******************************************************************************
# Author: Vivek Jha
# Last Modified: Mar 10, 2024
# 
# ================================================================================
# I - Directory Navigation
# ================================================================================
alias -- -="z -"
alias ~="cd $HOME"
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
# ================================================================================
# II - Git
# ================================================================================
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
alias gst='git status'
alias glg='git lg'
alias gss='git ss'
alias grs='git rs'
alias grst='git rst'
alias gcmsg='git cmsg'
alias gcam='git cam'
alias gcl='git cl'
alias gd='git d'
alias gds='git ds'
alias gp='git p'
alias gl='git l'
alias gf='git f'
alias ga='git a'
alias gaa='git aa'
# ================================================================================
# II - Console Output
# ================================================================================
alias cat='bat -p'

alias list-aliases='alias'
alias list-colors='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+"\n"}; done'
alias list-env-vars='env'
alias list-fpath='print -l $fpath'
alias list-functions='print -l ${(ok)functions[(I)[^_]*]}'
alias list-path='print -l $path'
alias list-plugins='print -l $plugins'
# ================================================================================
# III - Miscellaneous
# ================================================================================
# TODO organize this
alias mycli='mycli --myclirc ~/.config/mycli/.myclirc'
alias rmdsstore='sudo find / -name ".DS_Store" -depth -exec rm {} &>/dev/null'
alias stable_diffusion="cd '$HOME/BuddyAI Dropbox/Vivek Jha/Developer/Repos3P/stable-diffusion-webui; ./webui.sh --no-half"
alias sysinfo='system_profiler SPSoftwareDataType SPHardwareDataType'
# =============================================================================================================================
# IV - LS
# =============================================================================================================================
alias l='ls -lh'       # List files as a long list, show size, type, human-readable
alias la='ls -lAh'     # List almost all files as a long list show size, type, human-readable
alias lr='ls -tRh'     # List files recursively sorted by date, show type, human-readable
alias lt='ls -lth'     # List files as a long list sorted by date, show type, human-readable
alias ll='ls -l'       # List files as a long list
alias ldot='ls -ld .*' # List dot files as a long list
alias lS='ls -1Ssh'    # List files showing only size and name sorted by size
alias lart='ls -1cart' # List all files sorted in reverse of create/modification time (oldest first
alias lrt='ls -1crt'   # List files sorted in reverse of create/modification time(oldest first)
alias lsr='ls -lARh'   # List all files and directories recursively
alias lsn='ls -1'      # List files and directories in a single column
# =============================================================================================================================
# V - File handling
# =============================================================================================================================
alias rm='rm -i'                              # Remove a file with permission
alias cp='cp -i'                              # Copy a file with permission
alias mv='mv -i'                              # Move a file with permission
alias zshrc='${=EDITOR} $ZDOTDIR/.zshrc'      # Quickly access the .zshrc file
alias dud='du -d 1 -h'                        # Display the size of files at depth 1 in current location in human-readable form
(( $+commands[duf] )) || alias duf='du -sh *' # Display the size of files in current location in human-readable form           
alias t='tail -f'                             # Shorthand for tail which outputs the last part of a file
# =============================================================================================================================
# VI - Find & Grep
# =============================================================================================================================
(( $+commands[fd] )) || alias fd='find . -type d -name'        # Find a directory with the given name
alias ff='find . -type f -name'                                # Find a file with the given name
alias grep='grep --color=auto'                                 # Searches for a query string
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS}' # Useful for searching within files
# =============================================================================================================================
# VII - Other Aliases
# =============================================================================================================================
alias h='history'             # Lists all recently used commands
alias hgrep="fc -El 0 | grep" # Searches for a word in the list of previously used commands
alias help='man'              # Opens up the man page for a command
alias p='ps -f'               # Displays currently executing processes
alias sortnr='sort -n -r'     # Used to sort the lines of a text file
alias unexport='unset'        # Used to unset an environment variable
# =============================================================================================================================
# VIII - Global Aliases
# =============================================================================================================================
alias -g H='| head'                   # Pipes output to head which outputs the first part of a file
alias -g T='| tail'                   # Pipes output to tail which outputs the last part of a file
alias -g G='| grep'                   # Pipes output to grep to search for some word
alias -g L="| less"                   # Pipes output to less, useful for paging   
alias -g M="| most"                   # Pipes output to more, useful for paging
alias -g LL="2>&1 | less"             # Writes stderr to stdout and passes it to less
alias -g CA="2>&1 | cat -A"           # Writes stderr to stdout and passes it to cat
alias -g NE="2> /dev/null"            # Silences stderr
alias -g NUL="&> /dev/null"           # Silences both stdout and stderr
alias -g P="2>&1| pygmentize -l pytb" # Writes stderr to stdout and passes it to pygmentize
# =============================================================================================================================
# IX - File Extension Aliases
# =============================================================================================================================
# These are special aliases that are triggered when a file name is passed as the command.
# Ex: if the pdf file extension is aliased to `acroread` (a popular Linux pdf reader),
# when running `file.pdf` that file will be open with `acroread`
autoload -Uz is-at-least
if is-at-least 4.2.0; then
    # Opens urls in terminal using browser specified by $BROWSER
    if [[ -n "$BROWSER" ]]; then
        _browser_fts=(htm html de org net com at cx nl se dk)
        for ft in $_browser_fts; do alias -s $ft='$BROWSER'; done
    fi

    # Opens C, C++, Tex and text files using editor specified by $EDITOR
    _editor_fts=(cpp cxx cc c hh h inl asc txt TXT tex)
    for ft in $_editor_fts; do alias -s $ft='$EDITOR'; done

    # Opens images using image viewer specified by $XIVIEWER
    if [[ -n "$XIVIEWER" ]]; then
        _image_fts=(jpg jpeg png gif mng tiff tif xpm)
        for ft in $_image_fts; do alias -s $ft='$XIVIEWER'; done
    fi

    # Opens videos and other media using mplayer
    _media_fts=(ape avi flv m4a mkv mov mp3 mpeg mpg ogg ogm rm wav webm)
    for ft in $_media_fts; do alias -s $ft=mplayer; done

    # Reading Docs
    alias -s pdf=acroread   # Opens up a document using acroread
    alias -s ps=gv          # Opens up a .ps file using gv
    alias -s dvi=xdvi       # Opens up a .dvi file using xdvi
    alias -s chm=xchm       # Opens up a .chm file using xchm
    alias -s djvu=djview    # Opens up a .djvu file using djview

    # Listing files inside a packed file
    alias -s zip="unzip -l" # Lists files inside a .zip file
    alias -s rar="unrar l"  # Lists files inside a .rar file
    alias -s tar="tar tf"   # Lists files inside a .tar file
    alias -s tar.gz="echo " # Lists files inside a .tar.gz file
    alias -s ace="unace l"  # Lists files inside a .ace file
fi
