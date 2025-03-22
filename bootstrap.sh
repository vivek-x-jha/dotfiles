#!/usr/bin/env bash

# Ensure Xcode installed
command -v xcode-select &>/dev/null || { echo Please run: xcode-select --install; exit 1; }

echo 󰓒 INSTALLATION START 󰓒
step=0

((step++)); echo 󰓒 [$step/13] INSTALLING PACKAGE MANAGER 󰓒

# Install Homebrew
[[ -x /opt/homebrew/bin/brew || -x /usr/local/bin/brew ]] || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"

((step++)); echo "󰓒 [$step/13] INSTALLING COMMANDS & APPS 󰓒"

# Ensure bootstrap requirements installed
echo 'INSTALLING REQUIRED PACKAGES & APPS'

binaries=(
  1password 1password-cli alfred alt-tab arc atuin bash bat btop chatgpt cleanshot commitizen \
  coreutils cursor discord docker doll dust eza fd figma fileicon firefox fzf gawk gh git glow \
  google-chrome hammerspoon iterm2 jq karabiner-elements keycastr less llm mycli mysql neovim node \
  pam-reattach pandoc perl pkgconf postman protobuf rainfrog rename ripgrep skim spotify starship \
  switchaudio-osx tealdeer tmux tokei tree uv visual-studio-code vlc wezterm wget yazi zoxide zsh
)

for bin in "${binaries[@]}"; do brew list "$bin" &>/dev/null || brew reinstall "$bin"; done

# Install optional casks
optional=(dropbox image2icon mimestream notion-calendar slack thinkorswim whatsapp)

while true; do
  echo 'OPTIONAL CASKS TO DOWNLOAD:'
  for bin in "${optional[@]}"; do echo "$bin"; done
  read -rp 'INSTALL OPTIONAL APPS? (all/some/<Enter> TO SKIP): '
  case $REPLY in
        all) for bin in "${optional[@]}"; do brew reinstall "$bin"; done; break ;;
       some) read -rp 'ENTER SPACE-SEPARATED CASKS TO INSTALL: '
             for bin in $REPLY; do brew reinstall "$bin"; done; break ;;
         '') break ;;
          *) echo "[ERROR] INVALID INPUT! PLEASE ENTER 'all', 'some', OR <Enter> TO SKIP." ;;
  esac
done

echo "COMMANDS SUCCESSFULLY INSTALLED: $(brew --prefix)"

# Run Homebrew utility functions
while true; do
  read -rp 'CHECK HOMEBREW HEALTH? (<Enter> TO SKIP): '
  case $REPLY in
    [Yy]*) brew cleanup; brew doctor; break ;;
       '') break ;;
        *) echo "[ERROR] INVALID INPUT! PLEASE ENTER 'y' OR <Enter> TO SKIP." ;;
  esac
done

# Upgrade commands & applications managed by Homebrew
nikitabobko/tap
brew tap buo/cask-upgrade
while true; do
  read -rp 'UPDATE HOMEBREW COMMANDS & APPS? (<Enter> TO SKIP): '
  case $REPLY in
    [Yy]*) brew upgrade; brew cu -af; break ;;
       '') break ;;
        *) echo "[ERROR] INVALID INPUT! PLEASE ENTER 'y' OR <Enter> TO SKIP." ;;
  esac
done

((step++)); echo "󰓒 [$step/13] SET ENVIRONMENT 󰓒"

# XDG directory structure
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Authenticate 1password-cli
op signin

while true; do
  # Required 
  read -rp 'Please enter your Git Username: ' GIT_NAME
  read -rp 'Please enter your Git Email: '    GIT_EMAIL

  # Optional 
  read -rp "1Password Vault name (<Enter> to set to 'Private'): "
  OP_VAULT="${REPLY:-Private}"

  OP_GIT_SIGNKEY="$(op item get 'GitHub Signing Key' --vault "$OP_VAULT" --field 'public key')" &>/dev/null

  read -rp "Git Signing Key (<Enter> to set to '${OP_GIT_SIGNKEY:0:18} ... ${OP_GIT_SIGNKEY: -10}'): "
  GIT_SIGNINGKEY="${REPLY:-$OP_GIT_SIGNKEY}"

  read -rp "GitHub User (<Enter> to set to '${GIT_EMAIL%@*}'): "
  GITHUB_NAME="${REPLY:-${GIT_EMAIL%@*}}"

  read -rp "1Password Atuin Sync Title (<Enter> to set to 'Atuin Sync'): "
  ATUIN_OP_TITLE="${REPLY:-Atuin Sync}"

  read -rp "Atuin Username (<Enter> to set to '${GIT_EMAIL%@*}'): "
  ATUIN_USERNAME="${REPLY:-${GIT_EMAIL%@*}}"

  read -rp "Atuin Email (<Enter> to set to '$GIT_EMAIL'): "
  ATUIN_EMAIL="${REPLY:-$GIT_EMAIL}"

  read -rp "Media directory ~/\$MEDIA (<Enter> to skip): " MEDIA

  cat <<EOF
-------------- ENVIRONMENT ------------------
XDG_CONFIG_HOME=$XDG_CONFIG_HOME
XDG_CACHE_HOME=$XDG_CACHE_HOME
XDG_DATA_HOME=$XDG_DATA_HOME
XDG_STATE_HOME=$XDG_STATE_HOME

GIT_NAME=$GIT_NAME
GIT_EMAIL=$GIT_EMAIL
GIT_SIGNINGKEY=$GIT_SIGNINGKEY

GITHUB_NAME=$GITHUB_NAME
OP_VAULT=$OP_VAULT

ATUIN_USERNAME=$ATUIN_USERNAME
ATUIN_EMAIL=$ATUIN_EMAIL
ATUIN_OP_TITLE=$ATUIN_OP_TITLE

MEDIA=~/$MEDIA
---------------------------------------------
EOF

  read -rp "RE-ENTER ANY VARIABLES? (<Enter> TO CONTINUE): "
  [[ -z $REPLY || ! $REPLY =~ ^[Yy]$ ]] && break
done

((step++)); echo "󰓒 [$step/13] CREATE SYMLINKS & DIRECTORIES 󰓒"

symlink() {
  local src="$1"
  local cwd="$2"
  local tgt="$3"
  
  # Test: Valid Current Working Dir
  cd "$cwd" &>/dev/null || return 1

  # Test: Valid Source File/Folder
  [[ -e $src ]] || return 1

  # Link Source to Target - remove original if directory
  [[ -d $tgt ]] && rm -rf "$tgt"
  ln -sf "$src" "$tgt"

  echo "[+ Link: $src -> $cwd/$tgt]"
}

# Ensure base directories created before symlinking
directories=(
  "$XDG_CACHE_HOME"
  "$XDG_CONFIG_HOME/op"
  "$XDG_DATA_HOME/bash"
  "$XDG_DATA_HOME/zoxide"
  "$XDG_DATA_HOME/zsh"
  "$XDG_STATE_HOME/less"
  "$XDG_STATE_HOME/mycli"
  "$XDG_STATE_HOME/mysql"
  "$XDG_STATE_HOME/python"
)

mkdir -p "${directories[@]}"

# NOTE manage all links - provides fine-grained control over GNU stow
symlinks=(
  .dotfiles/bash/.bash_profile "$HOME" .bash_profile
  .dotfiles/bash/.bashrc       "$HOME" .bashrc
  .dotfiles/zsh/.zshenv        "$HOME" .zshenv

  ../.dotfiles/1Password   "$XDG_CONFIG_HOME" 1Password
  ../.dotfiles/atuin       "$XDG_CONFIG_HOME" atuin
  ../.dotfiles/bash        "$XDG_CONFIG_HOME" bash
  ../.dotfiles/bat         "$XDG_CONFIG_HOME" bat
  ../.dotfiles/blesh       "$XDG_CONFIG_HOME" blesh
  ../.dotfiles/brew        "$XDG_CONFIG_HOME" brew
  ../.dotfiles/btop        "$XDG_CONFIG_HOME" btop
  ../.dotfiles/dust        "$XDG_CONFIG_HOME" dust
  ../.dotfiles/eza         "$XDG_CONFIG_HOME" eza
  ../.dotfiles/fzf         "$XDG_CONFIG_HOME" fzf
  ../.dotfiles/gh          "$XDG_CONFIG_HOME" gh
  ../.dotfiles/git         "$XDG_CONFIG_HOME" git
  ../.dotfiles/glow        "$XDG_CONFIG_HOME" glow
  ../.dotfiles/hammerspoon "$XDG_CONFIG_HOME" hammerspoon
  ../.dotfiles/karabiner   "$XDG_CONFIG_HOME" karabiner
  ../.dotfiles/mycli       "$XDG_CONFIG_HOME" mycli
  ../.dotfiles/nvim        "$XDG_CONFIG_HOME" nvim
  ../.dotfiles/ssh         "$XDG_CONFIG_HOME" ssh
  ../.dotfiles/tmux        "$XDG_CONFIG_HOME" tmux
  ../.dotfiles/wezterm     "$XDG_CONFIG_HOME" wezterm
  ../.dotfiles/yazi        "$XDG_CONFIG_HOME" yazi
  ../.dotfiles/youtube     "$XDG_CONFIG_HOME" youtube
  ../.dotfiles/zsh         "$XDG_CONFIG_HOME" zsh

  ../.dotfiles/starship/config.toml "$XDG_CONFIG_HOME"    starship.toml
  ../../.dotfiles/op/plugins.sh     "$XDG_CONFIG_HOME/op" plugins.sh
  ../../.dotfiles/eza "$HOME/Library/Application Support" eza

  "$MEDIA/developer"      "$HOME"           Developer
  "../$MEDIA/content"     "$HOME/Movies"    content
  "../$MEDIA/icons"       "$HOME/Pictures"  icons
  "../$MEDIA/screenshots" "$HOME/Pictures"  screenshots
  "../$MEDIA/wallpapers"  "$HOME/Pictures"  wallpapers
  "../$MEDIA/education"   "$HOME/Documents" education
  "../$MEDIA/finances"    "$HOME/Documents" finances
)

# Safely create links - skips over broken paths
for ((i=0; i<${#symlinks[@]}; i+=3)); do symlink "${symlinks[i]}" "${symlinks[i+1]}" "${symlinks[i+2]}"; done

((step++)); echo "󰓒 [$step/13] CONFIGURE MACOS OPTIONS 󰓒"
num=0

((num++)); echo "opt${num}: Change default screenshots location to ~/Pictures/screenshots/"
[[ -d $HOME/Pictures/screenshots ]] || mkdir "$HOME/Pictures/screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/screenshots"

((num++)); echo "opt${num}: Speed up dock animation"
defaults write com.apple.dock autohide-delay -float 0.1

((num++)); echo "opt${num}: Speed up dock animation"
defaults write com.apple.dock autohide -bool true

((num++)); echo "opt${num}: Remove dock autohide animation"
defaults write com.apple.dock autohide-time-modifier -int 0

((num++)); echo "opt${num}: Show app switcher on all screens"
defaults write com.apple.dock appswitcher-all-displays -bool true

((num++)); echo "opt${num}: Shorten Mission Control animation"
defaults write com.apple.dock expose-animation-duration -float 0.1

((num++)); echo "opt${num}: Use list view in Finder"
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

((num++)); echo "opt${num}: Enable quitting Finder via ⌘ + Q"
defaults write com.apple.finder QuitMenuItem -bool true

((num++)); echo "opt${num}: Show hidden files in Finder"
defaults write com.apple.finder AppleShowAllFiles -bool true

((num++)); echo "opt${num}: Disable file extension change warning"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

killall Dock

((step++)); echo "󰓒 [$step/13] CONFIGURE GIT AND GITHUB CLI 󰓒"

# Update git credentials
git config --global user.name       "$GIT_NAME"
git config --global user.email      "$GIT_EMAIL"
git config --global user.signingkey "$GIT_SIGNINGKEY"

# Update git authentication to ssh and show fetch/push urls
git -C "$HOME/.dotfiles" remote set-url origin "git@github.com:$GITHUB_NAME/dotfiles.git"
git -C "$HOME/.dotfiles" remote --verbose

# Update ssh allowed signers
echo "$GIT_EMAIL $GIT_SIGNINGKEY" > "$XDG_CONFIG_HOME/ssh/allowed_signers"

# Update 1password ssh agent: https://developer.1password.com/docs/ssh/agent/config
perl -pi -e "s/vault = \"Private\"/vault = \"$OP_VAULT\"/g" "$XDG_CONFIG_HOME/1Password/ssh/agent.toml"

# Authenticate GitHub CLI
cd "$HOME/.dotfiles" || return 1

gh auth login
gh repo set-default "$GITHUB_NAME/dotfiles"

rm -f "$HOME/.dotfiles/gh/hosts.yml"
git add --all

((step++)); echo "󰓒 [$step/13] INSTALL SHELL PLUGINS 󰓒"

# Install zsh plugin manager zap
[[ -f $XDG_DATA_HOME/zap/zap.zsh ]] || zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 -k

# Build blesh
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX="$HOME/.local"
rm -rf ble.sh

((step++)); echo "󰓒 [$step/13] SETUP ATUIN SYNC 󰓒"

# Create atuin login
op item get "$ATUIN_OP_TITLE" --vault "$OP_VAULT" &>/dev/null || op item create \
  --vault "$OP_VAULT" \
  --category login \
  --title "$ATUIN_OP_TITLE" \
  --generate-password='letters,digits,symbols,32' \
  "username=$ATUIN_USERNAME" \
  "email[text]=$ATUIN_EMAIL" \
  "key[password]=<Update with \$(atuin key)>" &>/dev/null

op_fetch() { op item get "$ATUIN_OP_TITLE" --vault "$OP_VAULT" --fields "$1" --reveal; }

atuin register -u "$ATUIN_USERNAME" -e "$ATUIN_EMAIL" -p "$(op_fetch password)"

# Update Atuin Sync with generated key
op item edit "$ATUIN_OP_TITLE" --vault "$OP_VAULT" key="$(atuin key)"

# Ensure authenticated as atuin user - NOTE is idempotent
atuin status | grep -q "$ATUIN_USERNAME" || (
  atuin logout
  atuin login -u "$ATUIN_USERNAME" -p "$(op_fetch password)" -k "$(op_fetch key)"
) >/dev/null

# Sync shell history & integrate with Atuin history
atuin import auto
atuin sync

((step++)); echo "󰓒 [$step/13] LOAD BAT THEMES 󰓒"

# Rebuild bat cache any time theme folder changes
bat cache --build

((step++)); echo "󰓒 [$step/13] SETUP TOUCHID SUDO 󰓒"

# Ensure touchid possible in interactive mode or tmux
echo "# Authenticate with Touch ID - even in tmux
auth  optional    $(brew --prefix)/lib/pam/pam_reattach.so ignore_ssh
auth  sufficient  pam_tid.so" | sudo tee /etc/pam.d/sudo_local >/dev/null

# Show changes to sudo_local
bat /etc/pam.d/sudo_local

# Hide tty login message for iterm
((step++)); echo "󰓒 [$step/13] SURPRESS ITERM2 LOGIN 󰓒"
echo 'CREATED ~/.hushlogin'
touch "$HOME/.hushlogin" 

((step++)); echo "󰓒 [$step/13] CHANGE SHELL 󰓒"
for shell in bash zsh; do
  shell_path="$(brew --prefix)/bin/$shell"
  grep -qxF "$shell_path" /etc/shells || echo "$shell_path" | sudo tee -a /etc/shells
done

chsh -s "$shell_path"
echo "CURRENT SHELL IS $(basename "$SHELL")"
echo "SHELL=$shell_path"

((step++)); echo "󰓒 [$step/13] HAMMERSPOON SETUP 󰓒"
defaults write org.hammerspoon.Hammerspoon MJConfigFile "$XDG_CONFIG_HOME/hammerspoon/init.lua"
echo 'GO TO System Settings > Privacy & Security > Accessibility: ENSURE HAMMERSPOON IS LISTED AND ENABLED'

cd || exit

cat <<EOF
--------------- POST INSTALLATION ---------------

1 Restart terminal emulator

2 Setup Neovim
- Install plugins:         nvim
- Quit Lazy installer:     :q
- Install language servers :MasonInstall basedpyright bash-language-server lua-language-server shellcheck stylua
- Quit Neovim:             :qa

3 Setup Karabiner Elements
EOF
