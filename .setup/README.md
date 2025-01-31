# Dotfiles Setup Checklist

## Check 1Password SSH Agent Running

## Resync Dotfiles GitHub Repo

- [ ] Delete: [Ari dotfiles](https://github.com/arig07/dotfiles)

- [ ] Fork: [Vivek dotfiles](https://github.com/vivek-x-jha/dotfiles)

## Edit Files in GitHub

### `git/config`

```ini
[user]
name = Ari Ganapathi
email = ariganapathi7@gmail.com
signingkey = ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICWIS35ryEKaOq1XmBr9NoDlS9TeWcb10YsrLJ3m35e5
```

### `ssh/allowed_signers`

```plaintext
ariganapathi7@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICWIS35ryEKaOq1XmBr9NoDlS9TeWcb10YsrLJ3m35e5
```

## Open WezTerm and Install

```sh
cd && git clone arig07/dotfiles.git .dotfiles
./.dotfiles/.setup/bootstrap_no_brew.sh
```

## Restart WezTerm & Verify Shell Changes

## Test Dotfiles Git Protocol Changed to SSH

```sh
cd "$HOME/.dotfiles" && ssh -T git@github.com
```

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
