# WSL Setup

## 1. Create a GitHub Account
1. Browse to [https://github.com/signup](https://github.com/signup).
2. Enter **Andrew Labno** and the email `andrew.labno@gmail.com`.
3. Complete the verification puzzle, choose a password, and accept the terms.
4. Open the confirmation email from GitHub and click the verification link (this step is required before you can add SSH keys).

## 2. Start WSL and Prepare Ubuntu
1. On Windows, open **PowerShell** and run:
   ```powershell
   wsl
   ```
   This launches the Ubuntu shell.
2. Inside Ubuntu, update packages and install prerequisites (including the CLI tools referenced in your zsh config):
   ```bash
   sudo apt update && sudo apt upgrade -y
   sudo apt install -y \
     git curl unzip build-essential \
     atuin bat btop dust eza fzf gh glow mycli ripgrep tmux yazi zsh zoxide
   ```

## 3. Install Neovim (better version of vim editor)
1. Install Rust (programming language like Python)
- provides `cargo` package manager for rust tools (like sudo apt ... for Linux):
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
   source ~/.cargo/env
   ```
2. Install bob (Neovim version manager) via cargo:
   ```bash
   cargo install bob-nvim
   ```
3. Install Neovim
- stable is what you would typically download as a .zip or .exe from the website
- nightly is usually the latest but could have some bugs):
```bash
~/.local/share/bob/bin/bob install stable
~/.local/share/bob/bin/bob install nightly
~/.local/share/bob/bin/bob use nightly
```
This sets up bob under `~/.local/share/bob` and installs the nightly Neovim build matching your dotfiles.

## 4. Clone Vivek’s Dotfiles (HTTPS for now)
```bash
rm -rf ~/.dotfiles
git clone https://github.com/vivek-x-jha/dotfiles.git ~/.dotfiles
```

## 5. Create Required Directories
Make sure the XDG cache/state/data paths exist before linking anything:
```bash
mkdir -p ~/.cache
mkdir -p ~/.config
mkdir -p ~/.local/state/{bash,less,mycli,mysql,python,zsh}
mkdir -p ~/.local/share/zsh
```

## 6. Mirror Dotfiles into `~/.config`
- Instead of linking individual files into `$HOME`, mirror everything under `~/.config` so future updates stay in sync
- Remember a symlink is like a pointer where the first argument is "source" file/folder and second argument is the "target" name. most of these programs automatically look for their configuration in ~/.config so this is a way to "pretend" its there while managing it in our custom central location ~/.dotfiles
```bash
cd ~/.config
ln -sf ~/.dotfiles/atuin atuin
ln -sf ~/.dotfiles/bash bash
ln -sf ~/.dotfiles/bat bat
ln -sf ~/.dotfiles/blesh blesh
ln -sf ~/.dotfiles/btop btop
ln -sf ~/.dotfiles/dust dust
ln -sf ~/.dotfiles/eza eza
ln -sf ~/.dotfiles/fzf fzf
ln -sf ~/.dotfiles/gh gh
ln -sf ~/.dotfiles/git git
ln -sf ~/.dotfiles/glow glow
ln -sf ~/.dotfiles/mycli mycli
ln -sf ~/.dotfiles/nvim nvim
ln -sf ~/.dotfiles/ripgrep ripgrep
ln -sf ~/.dotfiles/ssh ssh
ln -sf ~/.dotfiles/tmux tmux
ln -sf ~/.dotfiles/wezterm wezterm
ln -sf ~/.dotfiles/yazi yazi
ln -sf ~/.dotfiles/zsh zsh
ln -sf ~/.dotfiles/starship/config.toml starship.toml
```

On WSL, remove the mac-only agent lines from `~/.config/ssh/config`:
```bash
sed -i '/UseKeychain/d;/IdentityAgent/d' ~/.config/ssh/config
```

## 7. Install Zap (Zsh plugin manager)
1. Run the Zap installer:
   ```bash
   zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 -k
   ```
   This installs Zap into `~/.local/share/zap`.
2. To update Zap/plugins later (no need to run this now but keep in mind for later):
   ```bash
   zap update all
   ```

## 8. Generate SSH Keys (these are like secret keys that are more secure than simple passwords - check out the video I posted in Slack in #resources)
```bash
ssh-keygen -t ed25519 -C "andrew.labno@gmail.com" -f ~/.config/ssh/id_ed25519
eval "$(ssh-agent -s)"
ssh-add ~/.config/ssh/id_ed25519
```

## 9. Add the Public Key to GitHub
```bash
cat ~/.config/ssh/id_ed25519.pub
```
Copy the entire output → GitHub → **Settings** → **SSH and GPG keys** → **New SSH key** → paste, name it “WSL Ubuntu,” and save.

## 10. Add github `known_hosts`
```bash
ssh-keyscan github.com > ~/.config/ssh/known_hosts
```
This avoids the first-time authenticity prompt.

## 11. Set Git Identity
```bash
git config --global user.name  "Andrew Labno"
git config --global user.email "andrew.labno@gmail.com"
git config --global core.autocrlf input
git config --global core.fileMode false
git config --global --unset user.signingkey || true
git config --global --unset gpg.format  || true
git config --global --unset gpg.ssh.program || true
git config --global --unset gpg.ssh.allowedSignersFile || true
git config --global --list
```
last command shows all your git settings

## 12. Switch the Dotfiles Remote to SSH
```bash
cd ~/.dotfiles
git remote set-url origin git@github.com:vivek-x-jha/dotfiles.git
```

## 13. Test GitHub SSH Access
```bash
ssh -T git@github.com
```
Type “yes” if asked to trust the host. You should see “Hi andrewlabno!” confirming that SSH auth works.

## 14. Restart Zsh to Load Zap Plugins
After SSH and Zap are configured, start a fresh zsh shell so Zap can pull the plugins defined in `~/.config/zsh/.zshrc`:
```bash
exec zsh -l
```
You should see the expected prompt (powerlevel10k, autocomplete, autosuggestions, etc.) once Zap finishes cloning.

## 15. Build bat (better version of cat) Theme Cache
If you want bat’s syntax theme caching to match this dotfiles setup:
```bash
bat cache --build
```
