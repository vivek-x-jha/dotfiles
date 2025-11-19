# WSL Git + SSH Setup for Andrew Labno

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
2. Inside Ubuntu, update packages and install prerequisites:
   ```bash
   sudo apt update && sudo apt upgrade -y
   sudo apt install -y git curl unzip build-essential
   ```

## 3. Clone Vivek’s Dotfiles (HTTPS for now)
```bash
git clone https://github.com/vivek-x-jha/dotfiles.git ~/.dotfiles
```

## 4. Mirror Dotfiles into `~/.config`
Instead of linking individual files into `$HOME`, mirror the directories under `~/.config` (add or remove entries based on what you use):
```bash
mkdir -p ~/.config
cd ~/.config
ln -snf ~/.dotfiles/git git
ln -snf ~/.dotfiles/ssh ssh
ln -snf ~/.dotfiles/zsh zsh
ln -snf ~/.dotfiles/nvim nvim
ln -snf ~/.dotfiles/wezterm wezterm
```

## 5. Generate SSH Keys (stored inside dotfiles)
```bash
ssh-keygen -t ed25519 -C "andrew.labno@gmail.com" -f ~/.dotfiles/ssh/id_ed25519
eval "$(ssh-agent -s)"
ssh-add ~/.dotfiles/ssh/id_ed25519
```

## 6. Add the Public Key to GitHub
```bash
cat ~/.dotfiles/ssh/id_ed25519.pub
```
Copy the entire output → GitHub → **Settings** → **SSH and GPG keys** → **New SSH key** → paste, name it “WSL Ubuntu,” and save.

## 7. (Optional) Prime `known_hosts`
```bash
ssh-keyscan github.com >> ~/.dotfiles/ssh/known_hosts
```
This avoids the first-time authenticity prompt.

## 8. Set Git Identity
```bash
git config --global user.name  "Andrew Labno"
git config --global user.email "andrew.labno@gmail.com"
git config --global core.autocrlf input
git config --global core.fileMode false
git config --global --list
```
(These settings live in `~/.config/git/config` because the entire directory is symlinked.)

## 9. Switch the Dotfiles Remote to SSH
```bash
cd ~/.dotfiles
git remote set-url origin git@github.com:vivek-x-jha/dotfiles.git
```

## 10. Test GitHub SSH Access
```bash
ssh -T git@github.com
```
Type “yes” if asked to trust the host. You should see “Hi andrewlabno!” confirming that SSH auth works.
