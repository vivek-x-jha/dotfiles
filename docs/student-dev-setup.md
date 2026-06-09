# Student Development Setup

This guide updates Aarush's Mac from an older copy of these dotfiles to a fresh fork. It keeps the first clone on HTTPS because moving the old dotfiles can temporarily break SSH config symlinks.

## 1. Refresh The GitHub Fork

Delete the old fork:

- https://github.com/AEMahi/dotfiles

Then fork the upstream repo again:

- https://github.com/vivek-x-jha/dotfiles

Use this destination:

```text
AEMahi/dotfiles
```

## 2. Rename Old Local Dotfiles

```sh
mv "$HOME/.dotfiles" "$HOME/.dotfiles.bak"
```

If that errors because the path does not exist, continue.

## 3. Clone Fresh Fork Over HTTPS

Use HTTPS first because SSH may be broken after moving `~/.dotfiles`.

```sh
git clone https://github.com/AEMahi/dotfiles.git "$HOME/.dotfiles"
cd "$HOME/.dotfiles"

git remote add upstream https://github.com/vivek-x-jha/dotfiles.git
git remote -v
```

Leave remotes on HTTPS until SSH is verified later.

## 4. Set XDG Vars

```sh
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
```

## 5. Create Directories

```sh
mkdir -p \
  "$XDG_CONFIG_HOME" \
  "$XDG_CONFIG_HOME/claude" \
  "$XDG_CONFIG_HOME/jupyter" \
  "$XDG_CONFIG_HOME/npm" \
  "$XDG_CACHE_HOME/npm" \
  "$XDG_DATA_HOME/jupyter" \
  "$XDG_DATA_HOME/zsh" \
  "$XDG_DATA_HOME/vscode" \
  "$XDG_STATE_HOME/bash" \
  "$XDG_STATE_HOME/codex" \
  "$XDG_STATE_HOME/jupyter/runtime" \
  "$XDG_STATE_HOME/less" \
  "$XDG_STATE_HOME/mycli" \
  "$XDG_STATE_HOME/mysql" \
  "$XDG_STATE_HOME/python" \
  "$XDG_STATE_HOME/ipython" \
  "$XDG_STATE_HOME/zsh" \
  "$HOME/.local/bin" \
  "$HOME/Library/Application Support/eza" \
  "$HOME/Library/Application Support/Code/User"
```

## 6. Create Symlinks

```sh
cd "$XDG_CONFIG_HOME"

ln -sfn ../.dotfiles/cli/atuin
ln -sfn ../.dotfiles/cli/bat
ln -sfn ../.dotfiles/cli/btop
ln -sfn ../.dotfiles/cli/dust
ln -sfn ../.dotfiles/cli/eza
ln -sfn ../.dotfiles/cli/fzf
ln -sfn ../.dotfiles/cli/gh
ln -sfn ../.dotfiles/auth/git
ln -sfn ../.dotfiles/cli/glow
ln -sfn ../.dotfiles/apps/hammerspoon
ln -sfn ../.dotfiles/apps/karabiner
ln -sfn ../.dotfiles/cli/matplotlib
ln -sfn ../.dotfiles/cli/mycli
ln -sfn ../.dotfiles/cli/npm
ln -sfn ../.dotfiles/editors/nvim
ln -sfn ../.dotfiles/editors/vscode
ln -sfn ../.dotfiles/shells
ln -sfn ../.dotfiles/auth/ssh
ln -sfn ../.dotfiles/auth/1Password 1Password
ln -sfn ../.dotfiles/terminals/tmux
ln -sfn ../.dotfiles/terminals/wezterm
ln -sfn shells/starship.toml

cd "$XDG_CONFIG_HOME/claude"
ln -sfn ../../.dotfiles/ai/claude/settings.json

cd "$HOME"
ln -sfn .local/share/vscode .vscode
ln -sfn .config/shells/bash/.bash_profile
ln -sfn .config/shells/bash/.bashrc
ln -sfn .config/shells/env .zshenv

cd "$HOME/Library/Application Support"
ln -sfn ../../.dotfiles/cli/eza

cd "$HOME/Library/Application Support/Code/User"
ln -sfn ../../../../.dotfiles/editors/vscode/settings.json

cd "$HOME/.dotfiles"
```

## 7. Generate SSH Keys

```sh
mkdir -p "$XDG_CONFIG_HOME/ssh/keys/github"
chmod 700 "$XDG_CONFIG_HOME/ssh" "$XDG_CONFIG_HOME/ssh/keys" "$XDG_CONFIG_HOME/ssh/keys/github"

ssh-keygen -t ed25519 -f "$XDG_CONFIG_HOME/ssh/keys/github/auth.key" -C "amahimainathan@gmail.com auth"
ssh-keygen -t ed25519 -f "$XDG_CONFIG_HOME/ssh/keys/github/signing.key" -C "amahimainathan@gmail.com signing"

chmod 600 "$XDG_CONFIG_HOME/ssh/keys/github/auth.key" "$XDG_CONFIG_HOME/ssh/keys/github/signing.key"
chmod 644 "$XDG_CONFIG_HOME/ssh/keys/github/auth.key.pub" "$XDG_CONFIG_HOME/ssh/keys/github/signing.key.pub"

ssh-add --apple-use-keychain "$XDG_CONFIG_HOME/ssh/keys/github/auth.key"
ssh-add --apple-use-keychain "$XDG_CONFIG_HOME/ssh/keys/github/signing.key"
```

Add the auth key to GitHub:

```sh
pbcopy < "$XDG_CONFIG_HOME/ssh/keys/github/auth.key.pub"
```

GitHub: **Settings -> SSH and GPG keys -> New SSH key -> Authentication Key**

Add the signing key to GitHub:

```sh
pbcopy < "$XDG_CONFIG_HOME/ssh/keys/github/signing.key.pub"
```

GitHub: **Settings -> SSH and GPG keys -> New SSH key -> Signing Key**

## 8. Replace SSH Config Files

```sh
cat > "$HOME/.dotfiles/auth/ssh/config" <<'EOF'
# Include ~/.config/ssh/identities/1password
Include ~/.config/ssh/identities/ssh-agent

Host github.com
  HostName           github.com
  User               git

Host *
  UserKnownHostsFile ~/.config/ssh/known_hosts
  SendEnv            LANG LC_*
EOF

cat > "$HOME/.dotfiles/auth/ssh/identities/ssh-agent" <<'EOF'
Host github.com
  IdentityFile ~/.config/ssh/keys/github/auth.key
  AddKeysToAgent yes
  IdentitiesOnly yes

Host *
  IgnoreUnknown UseKeychain
  UseKeychain yes
EOF
```

## 9. Replace Git Config

```sh
signing_key="$(cat "$XDG_CONFIG_HOME/ssh/keys/github/signing.key.pub")"

cat > "$HOME/.dotfiles/auth/git/config" <<EOF
[init]
	defaultBranch = main

[user]
	name = AEMahi
	email = amahimainathan@gmail.com
	signingkey = $signing_key

[core]
	sshCommand = ssh -F ~/.config/ssh/config

[gpg]
	format = ssh

[gpg "ssh"]
	allowedSignersFile = ~/.config/ssh/allowed_signers
	program = ssh-keygen

[commit]
	gpgsign = true

[include]
	path = ~/.config/git/themes/sourdiesel
EOF

echo "amahimainathan@gmail.com $signing_key" > "$HOME/.dotfiles/auth/ssh/allowed_signers"
```

## 10. Verify SSH, Then Switch Remotes To SSH

```sh
ssh -T git@github.com
```

After that succeeds:

```sh
git remote set-url origin git@github.com:AEMahi/dotfiles.git
git remote set-url upstream git@github.com:vivek-x-jha/dotfiles.git
git remote -v
```

## 11. Run Bootstrap

```sh
cd "$HOME/.dotfiles"

./bootstrap.sh --check
./bootstrap.sh --dry-run
./bootstrap.sh
```

If asked about 1Password, choose no.

## 12. Verify Final Setup

```sh
ssh-add -l
ssh -T git@github.com

git config --global --list --show-origin | grep -E 'user|signing|sshCommand|gpg'

git commit --allow-empty -m "test: verify signing"
git log --show-signature -1
git reset --soft HEAD~1
```

Check symlinks:

```sh
ls -l "$HOME/.zshenv"
ls -l "$XDG_CONFIG_HOME/git"
ls -l "$XDG_CONFIG_HOME/ssh"
ls -l "$XDG_CONFIG_HOME/nvim"
ls -l "$XDG_CONFIG_HOME/1Password"
ls -l "$HOME/.vscode"
ls -l "$HOME/Library/Application Support/eza"
ls -l "$HOME/Library/Application Support/Code/User/settings.json"
```

Search for personal leftovers:

```sh
cd "$HOME/.dotfiles"
rg "Vivek|vivek|mubuntu|op-ssh-sign"
```
