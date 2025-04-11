#!/usr/bin/env bash

clear

# Set color vars
RED='\e[0;31m'
YELLOW='\e[0;33m'
CYAN='\e[0;36m'
WHITE='\e[0;37m'
PURPLE='\e[0;95m'

RESET='\e[0m'

# Ensure Xcode installed
command -v xcode-select &>/dev/null || {
  echo -e "${RED}Please run: xcode-select --install${RESET}"
  exit 1
}

echo -e "${CYAN}󰓒 INSTALLATION START 󰓒${RESET}"
echo -e "${CYAN}󰓒 [$((++step))/12] INSTALLING COMMANDS & APPS 󰓒${RESET}"

# Install Homebrew
echo -e "${CYAN}󰓒 [${step}.1/12] INSTALLING PACKAGE MANAGER 󰓒${RESET}"
[[ -x /opt/homebrew/bin/brew || -x /usr/local/bin/brew ]] || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
echo 'HOMEBREW INSTALLED!'

# Install all formulae and casks
while true; do
  read -rp "${CYAN}󰓒 [${step}.2/12] INSTALL PACKAGES & APPS FROM BREWFILE? (<Enter> TO SKIP): ${RESET}"
  case $REPLY in
  [Yy]*)
    read -rp "${CYAN}󰓒 [${step}.2.1/12] ENTER BREWFILE PATH OR URL (<Enter> TO USE DEFAULT): ${RESET}" brewfile
    [[ -z $brewfile ]] && brewfile='https://raw.githubusercontent.com/vivek-x-jha/dotfiles/refs/heads/main/Brewfile'
    echo "USING BREWFILE: $brewfile"

    # Expand ~ or $HOME if present
    [[ $brewfile =~ ^~ ]] && brewfile="${HOME}${brewfile:1}"
    brewfile="${brewfile/#\~/$HOME}"

    # Handle URLs
    [[ $brewfile =~ ^https?:// ]] && {
      curl -fsSL "$brewfile" | brew bundle --file=-
      break
    }

    # Check for local file existence after path expansion
    [[ -f $brewfile ]] && {
      brew bundle --file="$brewfile"
      break
    }

    echo -e "${RED}[ERROR] INVALID PATH OR URL: ${YELLOW}$brewfile${RESET}"
    break
    ;;
  '') break ;;
  *) echo -e "${RED}[ERROR] INVALID INPUT! ${YELLOW}PLEASE ENTER 'y' OR <Enter> TO SKIP.${RESET}" ;;
  esac
done

# Update Brewfile
brew bundle dump --force --file="$HOME/.dotfiles/Brewfile"

# Run Homebrew utility functions
while true; do
  read -rp "${CYAN}󰓒 [${step}.3/12] CHECK HOMEBREW HEALTH? (<Enter> TO SKIP): ${RESET}"
  case $REPLY in
  [Yy]*)
    brew cleanup
    brew doctor
    break
    ;;
  '') break ;;
  *) echo -e "${RED}[ERROR] INVALID INPUT! ${YELLOW}PLEASE ENTER 'y' OR <Enter> TO SKIP.${RESET}" ;;
  esac
done

# Upgrade commands & applications managed by Homebrew
while true; do
  read -rp "${CYAN}󰓒 [${step}.4/12] UPDATE HOMEBREW COMMANDS & APPS? (<Enter> TO SKIP): ${RESET}"
  case $REPLY in
  [Yy]*)
    brew upgrade
    brew cu -af
    break
    ;;
  '') break ;;
  *) echo -e "${RED}[ERROR] INVALID INPUT! ${YELLOW}PLEASE ENTER 'y' OR <Enter> TO SKIP.${RESET}" ;;
  esac
done

echo -e "${CYAN}󰓒 [$((++step))/12] SET ENVIRONMENT 󰓒${RESET}"

# XDG directory structure
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Authenticate 1password-cli
op signin

while true; do
  # Required
  read -rp "${WHITE}Please enter your Git Username: ${RESET}" GIT_NAME
  read -rp "${WHITE}Please enter your Git Email: ${RESET}" GIT_EMAIL

  # Optional
  read -rp "${WHITE}1Password Vault name (<Enter> to set to 'Private'): ${RESET}"
  OP_VAULT="${REPLY:-Private}"

  OP_GIT_SIGNKEY="$(op item get 'GitHub Signing Key' --vault "$OP_VAULT" --field 'public key')" &>/dev/null

  read -rp "${WHITE}Git Signing Key (<Enter> to set to '${OP_GIT_SIGNKEY:0:18} ... ${OP_GIT_SIGNKEY: -10}'): ${RESET}"
  GIT_SIGNINGKEY="${REPLY:-$OP_GIT_SIGNKEY}"

  read -rp "${WHITE}GitHub User (<Enter> to set to '${GIT_EMAIL%@*}'): ${RESET}"
  GITHUB_NAME="${REPLY:-${GIT_EMAIL%@*}}"

  read -rp "${WHITE}1Password Atuin Sync Title (<Enter> to set to 'Atuin Sync'): ${RESET}"
  ATUIN_OP_TITLE="${REPLY:-Atuin Sync}"

  read -rp "${WHITE}Atuin Username (<Enter> to set to '${GIT_EMAIL%@*}'): ${RESET}"
  ATUIN_USERNAME="${REPLY:-${GIT_EMAIL%@*}}"

  read -rp "${WHITE}Atuin Email (<Enter> to set to '$GIT_EMAIL'): ${RESET}"
  ATUIN_EMAIL="${REPLY:-$GIT_EMAIL}"

  read -rp "${WHITE}Media directory ~/\$MEDIA (<Enter> to skip): ${RESET}" MEDIA

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

  read -rp "${YELLOW}RE-ENTER ANY VARIABLES? (<Enter> TO CONTINUE): ${RESET}"
  [[ -z $REPLY || ! $REPLY =~ ^[Yy]$ ]] && break
done

echo -e "${CYAN}󰓒 [$((++step))/12] CREATE SYMLINKS & DIRECTORIES 󰓒${RESET}"

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
  .dotfiles/bash/.bashrc "$HOME" .bashrc
  .dotfiles/zsh/.zshenv "$HOME" .zshenv

  ../.dotfiles/1Password "$XDG_CONFIG_HOME" 1Password
  ../.dotfiles/atuin "$XDG_CONFIG_HOME" atuin
  ../.dotfiles/bash "$XDG_CONFIG_HOME" bash
  ../.dotfiles/bat "$XDG_CONFIG_HOME" bat
  ../.dotfiles/blesh "$XDG_CONFIG_HOME" blesh
  ../.dotfiles/btop "$XDG_CONFIG_HOME" btop
  ../.dotfiles/dust "$XDG_CONFIG_HOME" dust
  ../.dotfiles/eza "$XDG_CONFIG_HOME" eza
  ../.dotfiles/fzf "$XDG_CONFIG_HOME" fzf
  ../.dotfiles/gh "$XDG_CONFIG_HOME" gh
  ../.dotfiles/git "$XDG_CONFIG_HOME" git
  ../.dotfiles/glow "$XDG_CONFIG_HOME" glow
  ../.dotfiles/hammerspoon "$XDG_CONFIG_HOME" hammerspoon
  ../.dotfiles/karabiner "$XDG_CONFIG_HOME" karabiner
  ../.dotfiles/mycli "$XDG_CONFIG_HOME" mycli
  ../.dotfiles/nvim "$XDG_CONFIG_HOME" nvim
  ../.dotfiles/ssh "$XDG_CONFIG_HOME" ssh
  ../.dotfiles/tmux "$XDG_CONFIG_HOME" tmux
  ../.dotfiles/wezterm "$XDG_CONFIG_HOME" wezterm
  ../.dotfiles/yazi "$XDG_CONFIG_HOME" yazi
  ../.dotfiles/youtube "$XDG_CONFIG_HOME" youtube
  ../.dotfiles/zsh "$XDG_CONFIG_HOME" zsh

  ../.dotfiles/starship/config.toml "$XDG_CONFIG_HOME" starship.toml
  ../../.dotfiles/op/plugins.sh "$XDG_CONFIG_HOME/op" plugins.sh
  ../../.dotfiles/eza "$HOME/Library/Application Support" eza

  "$MEDIA/developer" "$HOME" Developer
  "../$MEDIA/content" "$HOME/Movies" content
  "../$MEDIA/icons" "$HOME/Pictures" icons
  "../$MEDIA/screenshots" "$HOME/Pictures" screenshots
  "../$MEDIA/wallpapers" "$HOME/Pictures" wallpapers
  "../$MEDIA/education" "$HOME/Documents" education
  "../$MEDIA/finances" "$HOME/Documents" finances
)

# Safely create links - skips over broken paths
for ((i = 0; i < ${#symlinks[@]}; i += 3)); do symlink "${symlinks[i]}" "${symlinks[i + 1]}" "${symlinks[i + 2]}"; done

echo -e "${CYAN}󰓒 [$((++step))/12] CONFIGURE MACOS OPTIONS 󰓒${RESET}"

echo -e "${PURPLE}opt$((++num)): Change default screenshots location to ~/Pictures/screenshots/"
[[ -d $HOME/Pictures/screenshots ]] || mkdir "$HOME/Pictures/screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/screenshots"

echo -e "${PURPLE}opt$((++num)): Speed up dock animation"
defaults write com.apple.dock autohide-delay -float 0.1

echo -e "${PURPLE}opt$((++num)): Speed up dock animation"
defaults write com.apple.dock autohide -bool true

echo -e "${PURPLE}opt$((++num)): Remove dock autohide animation"
defaults write com.apple.dock autohide-time-modifier -int 0

echo -e "${PURPLE}opt$((++num)): Show app switcher on all screens"
defaults write com.apple.dock appswitcher-all-displays -bool true

echo -e "${PURPLE}opt$((++num)): Shorten Mission Control animation"
defaults write com.apple.dock expose-animation-duration -float 0.1

echo -e "${PURPLE}opt$((++num)): Use list view in Finder"
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

echo -e "${PURPLE}opt$((++num)): Enable quitting Finder via ⌘ + Q"
defaults write com.apple.finder QuitMenuItem -bool true

echo -e "${PURPLE}opt$((++num)): Show hidden files in Finder"
defaults write com.apple.finder AppleShowAllFiles -bool true

echo -e "${PURPLE}opt$((++num)): Disable file extension change warning"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

killall Dock

echo -e "${CYAN}󰓒 [$((++step))/12] CONFIGURE GIT AND GITHUB CLI 󰓒${RESET}"

# Update git credentials
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global user.signingkey "$GIT_SIGNINGKEY"

# Update git authentication to ssh and show fetch/push urls
git -C "$HOME/.dotfiles" remote set-url origin "git@github.com:$GITHUB_NAME/dotfiles.git"
git -C "$HOME/.dotfiles" remote add upstream git@github.com:vivek-x-jha/dotfiles.git

# Update ssh allowed signers
echo "$GIT_EMAIL $GIT_SIGNINGKEY" >"$XDG_CONFIG_HOME/ssh/allowed_signers"

# Update 1password ssh agent: https://developer.1password.com/docs/ssh/agent/config
perl -pi -e "s/vault = \"Private\"/vault = \"$OP_VAULT\"/g" "$XDG_CONFIG_HOME/1Password/ssh/agent.toml"

# Authenticate GitHub CLI
cd "$HOME/.dotfiles" || return 1

gh auth login
gh repo set-default "$GITHUB_NAME/dotfiles"

rm -f "$HOME/.dotfiles/gh/hosts.yml"
git add --all

echo -e "${CYAN}󰓒 [$((++step))/12] INSTALL SHELL PLUGINS 󰓒${RESET}"

# Install zsh plugin manager zap
[[ -f $XDG_DATA_HOME/zap/zap.zsh ]] || zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 -k

# Build blesh
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX="$HOME/.local"
rm -rf ble.sh

echo -e "${CYAN}󰓒 [$((++step))/12] SETUP ATUIN SYNC 󰓒${RESET}"

# Create atuin login
op item get "$ATUIN_OP_TITLE" --vault "$OP_VAULT" &>/dev/null || op item create \
  --vault "$OP_VAULT" \
  --category login \
  --title "$ATUIN_OP_TITLE" \
  --generate-password='letters,digits,symbols,32' \
  "username=$ATUIN_USERNAME" \
  "email[text]=$ATUIN_EMAIL" \
  "key[password]=<Update with \$(atuin key)>" &>/dev/null

# Get 1password field like password or key
getop() {
  local field="$1"
  op item get "$ATUIN_OP_TITLE" \
    --vault "$OP_VAULT" \
    --fields "$field" \
    --reveal
}

atuin register -u "$ATUIN_USERNAME" -e "$ATUIN_EMAIL" -p "$(getop password)"

# Update Atuin Sync with generated key
op item edit "$ATUIN_OP_TITLE" --vault "$OP_VAULT" key="$(atuin key)"

# Ensure authenticated as atuin user - NOTE is idempotent
atuin status | grep -q "$ATUIN_USERNAME" || (
  atuin logout
  atuin login -u "$ATUIN_USERNAME" -p "$(getop password)" -k "$(getop key)"
) >/dev/null

# Sync shell history & integrate with Atuin history
atuin import auto
atuin sync

echo -e "${CYAN}󰓒 [$((++step))/12] LOAD BAT THEMES 󰓒${RESET}"

# Rebuild bat cache any time theme folder changes
bat cache --build

echo -e "${CYAN}󰓒 [$((++step))/12] SETUP TOUCHID SUDO 󰓒${RESET}"

# Ensure touchid possible in interactive mode or tmux
echo "# Authenticate with Touch ID - even in tmux
auth  optional    $(brew --prefix)/lib/pam/pam_reattach.so ignore_ssh
auth  sufficient  pam_tid.so" | sudo tee /etc/pam.d/sudo_local >/dev/null
echo 'UPDATED /etc/pam.d/sudo_local'

# Hide tty login message for iterm
echo -e "${CYAN}󰓒 [$((++step))/12] SURPRESS ITERM2 LOGIN 󰓒${RESET}"
echo 'CREATED ~/.hushlogin'
touch "$HOME/.hushlogin"

echo -e "${CYAN}󰓒 [$((++step))/12] CHANGE SHELL 󰓒${RESET}"
for shell in bash zsh; do
  shell_path="$(brew --prefix)/bin/$shell"
  grep -qxF "$shell_path" /etc/shells || echo "$shell_path" | sudo tee -a /etc/shells
done

chsh -s "$shell_path"
echo "CURRENT SHELL IS $(basename "$SHELL")"
echo "SHELL=$shell_path"

echo -e "${CYAN}󰓒 [$((++step))/12] HAMMERSPOON SETUP 󰓒${RESET}"
defaults write org.hammerspoon.Hammerspoon MJConfigFile "$XDG_CONFIG_HOME/hammerspoon/init.lua"
echo 'GO TO System Settings > Privacy & Security > Accessibility: ENSURE HAMMERSPOON IS LISTED AND ENABLED'

cd || exit
