# Terminal Developement

Welcome to my take on a power user Terminal. 
The philosophy of this terminal should always be **Functional - Fast - Fun**. 
This is obviosuly a WIP, so if you think something is dogshit, send me a PR.

## Shell Plugins

Below is a list of all the 3rd party plugins I use for my shell. I do not use the bloatware that is `oh-my-zsh`. Instead I manage the plugins with `plug`:

```zsh
plug() {
    # Loads plugin and appends it to plugins array

    local plugin="$ZDOTDIR/zsh-plugins/$1/$1.plugin.zsh"

    if [[ -f $plugin ]]; then
        source $plugin
        declare -ag plugins
        plugins+=( $1 )
    else
        return 0
    fi
}
```

To view active plugins in order of loading: `print -l $plugins` (also set to alias `list-plugins`)

My current plugins are:

```zsh
$ list-plugins
z.lua
zsh-autocomplete
zsh-autosuggestions
zsh-colored-man-pages
zsh-sudo
zsh-vscode
zsh-you-should-use
zsh-history-substring-search
zsh-syntax-highlighting
```

### [Fast Directory Switching - Z](https://github.com/vivek-x-jha/z.lua)

- [ ] optimize frecency list
- [ ] learn fundamentals: watch `zoxide` [tutorial](https://youtu.be/aghxkpyRVDY?si=jBZuI3aLJf1nl_po)

### [Autocompletion](https://github.com/marlonrichert/zsh-autocomplete)

To change color, use 
```zsh
zstyle ':completion:*:*:descriptions' format '<prompt escape codes>'
```

- [ ] configure results color: black 
- [ ] configure results selection color: magenta? green? try a few out...
- [ ] configure results header color: token dependent
- [ ] configure common substring color: no background
- [ ] configure keybindings: tab
- [ ] configure keybindings: right arrow
- [ ] configure keybindings: up/down arrow
- [ ] test menu_complete independence
- [ ] test autosuggestions independence
- [ ] remap history-substring keybinding
- [ ] debug p10k truncating directory name to '~autocomplete'
- [ ] learn fundamentals: [zsh completions](https://thevaluable.dev/zsh-completion-guide-examples/)

### [Autosuggestions](https://github.com/vivek-x-jha/zsh-autosuggestions)

- [x] configure color: black

### [Colored Man Pages](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/colored-man-pages)

- [x] configure bold & blinking: magenta
- [x] configure standout: magenta
- [x] configure underlining: blue
- [x] refactor `zsh-colored-man-pages.plugin.zsh`
- [ ] learn fundamentals: MANPATH
- [ ] learn fundamentals: example of standout mode
- [ ] debug subcommand not being recognized: i.e. `man git merge`

### [Sudo Toggle](https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/sudo)

- [x] update with original repo link
- [x] configure touch id for sudo password

```zsh
sudo sed -i.'' '1s/^/auth       sufficient     pam_tid.so\n/' /etc/pam.d/sudo
```

### [VS Code Launcher](https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/vscode)

- [x] refactor `vsc()` as single-line function
- [ ] debug vscode font looking different: configure `anti-aliasing: true`

### [You Should Use Alias Hinter](https://github.com/vivek-x-jha/zsh-you-should-use)

- [ ] debug `check_alias_usage`: frequency counts are all 0
- [ ] refactor `zsh-you-should-use.plugin.zsh`

### [History Substring Search](https://github.com/vivek-x-jha/zsh-history-substring-search)

- [x] configure initialization with `shift + up` and `shift + down`

### [Syntax Highlighting](https://github.com/vivek-x-jha/zsh-syntax-highlighting)

- [x] refactor project
- [x] update precommand color: bright green
- [x] update current directory color: bright green
- [x] update known token command color: magenta

## Shell Features & Other Tools 

### Homebrew

Install [Homebrew Package Manager](https://brew.sh/)

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Autoload

- [ ] learn fundamentals: lazy loading
- [ ] learn fundamentals: [define and load shell functions](https://unix.
  4 stackexchange.com/questions/33255/how-to-define-and-load-your-own-shell-function-in-zsh)

### Caching & History

- [x] debug `.mycli-history` not populating in cache
- [ ] configure `.zsh_sessions` path to `$XDG_CACHE_HOME/zsh`
- [ ] configure `.zcompdump` path to `$XDG_CACHE_HOME/zsh` ([Stack Overflow Solution](https://superuser.com/a/1785259/930403))
- [ ] debug `.bash_history` not populating in `$XDG_CACHE_HOME/bash` (works normally for `exec bash`)
- [ ] debug `.lesshst` reappearing in `$HOME`

### Git

- [x] configure [githb ssh connection](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [ ] update submodule urls to use `ssh` links
- [ ] learn fundamentals: `git merge`
- [ ] learn fundamentals: `git stash`
- [ ] learn fundamentals: tracking
- [ ] debug `git <log/status/diff>` not invoking `less` unless piped into: `git diff | less`
- [ ] learn fundamentals: [more vs. less vs. most](https://www.baeldung.com/linux/more-less-most-commands)

### FZF

- [ ] build [file explorer](https://thevaluable.dev/practical-guide-fzf-example/)

### Btop

- [x] configure theme: [catppuccin-mocha](https://github.com/catppuccin/btop)
### Mycli


### VS Code

- [ ] configure `$HOME/.vscode` -> `$XDG_CONFIG_HOME/vscode/.vscode`
- [ ] debug `code` not working when renaming app

### Alfred

- [ ] configure old workflows
- [ ] configure new colorscheme

### Think or Swim

- [ ] learn fundamentals: configuration file(s) to track

### Iterm

- [ ] debug [symlink issue](https://stackoverflow.com/questions/78105340/iterm2-keeps-recreating-symlink)

### Stable Diffusion

- [ ] debug CLI launcher not initializing

### [Anaconda](https://www.anaconda.com/download#downloads)

Install: `sudo bash ~/.config/conda/Anaconda3-2023.03-1-MacOSX-arm64.sh`

## Other Notes


