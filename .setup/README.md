# Dotfiles Setup Checklist

## Resync Dotfiles GitHub Repo

### Delete: [Ari dotfiles](https://github.com/arig07/dotfiles)

### Fork: [Vivek dotfiles](https://github.com/vivek-x-jha/dotfiles)

## Check [1Password SSH Agent](https://developer.1password.com/docs/ssh/get-started#step-3-turn-on-the-1password-ssh-agent)

## Open WezTerm and Install

```sh
cd && git clone arig07/dotfiles.git .dotfiles
./.dotfiles/.setup/bootstrap_ari.sh
```

## Check Git protocol changed to ssh

```sh
git -C "$HOME/.dotfiles" remote -v
```

```sh
origin  git@github.com:arig07/dotfiles.git (fetch)
origin  git@github.com:arig07/dotfiles.git (push)
```

## Check `git config` updated:

```sh
sed -n '3,6p' "$XDG_CONFIG_HOME/git/config"
```

```ini
[user]
    name = Ari Ganapathi
    email = ariganapathi7@gmail.com
    signingkey = ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICWIS35ryEKaOq1XmBr9NoDlS9TeWcb10YsrLJ3m35e5
```

## Check `ssh allowed_signers` updated:

```sh
cat "$XDG_CONFIG_HOME/ssh/allowed_signers"
```

```plaintext
ariganapathi7@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICWIS35ryEKaOq1XmBr9NoDlS9TeWcb10YsrLJ3m35e5
```

## Restart WezTerm & Verify Shell Changes

## Authenticate GitHub CLI

```sh
gh auth login
```

## Setup Neovim

```sh
nvim
```
### Restart after initial install

```vim
:qa
```

```sh
nvim
```

### Install Language Servers

```vim
:MasonInstall pyright
:MasonInstall lua-language-server
```

## Test Python Installed

```sh
python3
```

## Setup Atuin

### Create "Atuin Sync" 1Password Login Item

- **Fields:** `<USERNAME>`, password, `<EMAIL>`

### Register Atuin to Sync Across Machines

```sh
atuin register -u <USERNAME> -e <EMAIL>
```

### Add Key to 1Password Item

```sh
op item update --title="Atuin Sync" "key=<KEY>"
```

### Check If Logged In Automatically

```sh
atuin login -u <USERNAME>
```

### Sync Atuin with Current Shell History

```sh
atuin import auto && atuin sync
```

### Initialize Atuin Shell Integration

```sh
exec zsh
```

### Test Integrations

- **Global history search:** `Ctrl + e`
- **Directory history search:** `Up Arrow`
- **Toggle search scopes:** `Ctrl + r`
- **Exit search mode:** `Esc`

## Link Apps to Brew
- Delete manually downloaded versions from `/Applications/` - some app downloads may require sudo authentication

```sh
brew install --cask 1password alfred alt-tab chatgpt discord font-jetbrains-mono-nerd-font google-chrome hammerspoon iterm2 karabiner-elements postman skim spotify visual-studio-code vlc wezterm zoom
```
