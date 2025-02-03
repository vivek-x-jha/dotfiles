# Dotfiles Setup Checklist

## Resync Dotfiles GitHub Repo

### Delete: [Ari dotfiles](https://github.com/arig07/dotfiles)

### Fork: [Vivek dotfiles](https://github.com/vivek-x-jha/dotfiles)

## Check [1Password SSH Agent](https://developer.1password.com/docs/ssh/get-started#step-3-turn-on-the-1password-ssh-agent)

## Open WezTerm and Install

```sh
git clone https://github.com/arig07/dotfiles.git ~/.dotfiles && ~/.dotfiles/.setup/bootstrap_arig07.sh
```

## Restart WezTerm & Verify Shell Changes

## Install Neovim Language Servers

```vim
:MasonInstall lua-language-server basedpyright
```

## Link Apps to Brew
- Delete manually downloaded versions from `/Applications/` - some app downloads may require sudo authentication

```sh
brew install --cask 1password alfred alt-tab chatgpt discord font-jetbrains-mono-nerd-font google-chrome hammerspoon iterm2 karabiner-elements postman skim spotify visual-studio-code vlc wezterm zoom
```
