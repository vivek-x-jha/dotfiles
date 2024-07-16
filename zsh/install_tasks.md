# Terminal Development Environemnt

## Homebrew

### Installation

```sh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Essential apps 

```sh
brew install --cask iterm2
brew install --cask visual-studio-code
brew install --cask vlc
```

### [Nerd Fonts](https://www.nerdfonts.com)

```sh
brew install --cask font-comic-shanns-mono-nerd-font
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-sauce-code-pro-nerd-font
brew install --cask font-sf-mono-nerd-font-ligaturized
brew install --cask font-symbols-only-nerd-font
```

### Essential Formulae

```sh
brew install coreutils
brew install eza
brew install fzf
brew install git
brew install gitmux
brew install lua
brew install mycli
brew install mysql
brew install nvim
brew install powerlevel10k
brew install tmux
brew install z.lua
brew install zsh-autocomplete
brew install zsh-autopair
brew install zsh-autosuggestions
brew install zsh-completions
brew install zsh-syntax-highlighting
```

## MacOS Utilities

### Speedup Dock Animation

```sh
defaults write com.apple.dock autohide-time-modifier -float 0.6; killall Dock
defaults write com.apple.Dock autohide-delay -float 0; killall Dock
```
