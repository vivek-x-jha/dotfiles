# MacOS Terminal Development Environemnt

## Homebrew

### Installation

```sh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Essential Formulae

```sh
brew install coreutils
brew install bat
brew install btop
brew install eza
brew install fzf
brew install gh
brew install git
brew install gitmux
brew install lazygit
brew install lua
brew install mycli
brew install mysql
brew install neovim
brew install powerlevel10k
brew install ripgrep
brew install tree
brew install tmux
brew install z.lua
brew install zsh-autocomplete
brew install zsh-autopair
brew install zsh-autosuggestions
brew install zsh-completions
brew install zsh-syntax-highlighting
```

### Essential Apps & [Fonts](https://www.nerdfonts.com)

```sh
brew install --cask iterm2
brew install --cask visual-studio-code

brew tap homebrew/cask-fonts
brew install --cask font-symbols-only-nerd-font
brew install --cask font-comic-shanns-mono-nerd-font
```

## Shell Configuration

After downloading homebrew versions of bash and zsh, to use those we need to add them to /etc/shells

```sh
echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells
echo "$(brew --prefix)/bin/zsh" | sudo tee -a /etc/shells
chsh -s "$(brew --prefix)/bin/zsh"
```

To check if successful, quit and restart iTerm2 and enter

```sh
echo $SHELL
which zsh
```

Both of these commands should return `/opt/homebrew/bin/zsh`

## iTerm2 Configuration

```sh
# Specify the preferences directory
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$XDG_CONFIG_HOME/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

# Surpress Shell Last Login Message
ln -sF "$XDG_CONFIG_HOME/iterm2/.hushlogin" ~/.hushlogin
```

## MacOS Utilities

### Speedup Dock Animation

```sh
defaults write com.apple.dock autohide-time-modifier -float 0.6; killall Dock
defaults write com.apple.Dock autohide-delay -float 0; killall Dock
```
