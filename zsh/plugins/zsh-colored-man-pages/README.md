# Colored Man Pages Plugin

This plugin adds colors to man pages. Forked from [oh-my-zsh colored-man-pages plugin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/colored-man-pages).

## Setup

### [plug](https://github.com/update-this-later)

`colored-man-pages` can be activated by calling it with `plug`. To keep activated after the current session, add the following to your zshrc file:

```zsh
plug zsh-colored-man-pages
```

### [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)

`colored-man-pages` comes bundled with oh-my-zsh! To use, add it to the plugins array in your zshrc file:

```zsh
plugins=(... colored-man-pages)
```

It will also automatically colorize man pages displayed by `dman` or `debman`,
from [`debian-goodies`](https://packages.debian.org/stable/debian-goodies).

You can also try to color other pages by prefixing the respective command with `colored`:

```zsh
colored git help clone
```

## Customization

The plugin declares global associative array `less_termcap`, which maps termcap capabilities to escape
sequences for the `less` pager. This mapping can be further customized by the user after the plugin is
loaded. Check out sources for more.

For example: `less_termcap[md]` maps to `LESS_TERMCAP_md` which is the escape sequence that tells `less`
how to print something in bold. It's currently shown in bold red, but if you want to change it, you
can redefine `less_termcap[md]` in your zshrc file, after OMZ is sourced:

```zsh
less_termcap[md]="${fg_bold[blue]}" # this tells less to print bold text in bold blue
```
