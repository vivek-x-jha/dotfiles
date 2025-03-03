#!/usr/bin/env bash
# TODO Fix zsh compinit insecure directories warning: chmod -R go-w "$(brew --prefix)/share"

# Ensure Xcode installed
command -v xcode-select &> /dev/null || { echo Please run: xcode-select --install; exit 1; }

echo 󰓒 INSTALLATION START 󰓒
step=0

((step++)); echo 󰓒 [$step/12] INSTALLING PACKAGE MANAGER 󰓒

if ! command -v brew &>/dev/null; then
  # Install Homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Prepend Homebrew to PATH
  case "$(uname -m)" in
    arm64 ) eval "$('/opt/homebrew/bin/brew' shellenv)" ;;
    x86_64) eval "$('/usr/local/bin/brew' shellenv)" ;;
         *) echo [! Unknown architecture - requires arm64 or x86_64]; exit 1 ;;
  esac
fi

echo Commands successfully installed: $(brew --prefix)

((step++)); echo "󰓒 [$step/12] INSTALLING COMMANDS & APPS 󰓒"

# Install commands and apps using Homebrew
brewfile='https://raw.githubusercontent.com/vivek-x-jha/dotfiles/refs/heads/main/brew/.Brewfile'

while true; do
  read -rp 'Install [all/cmds/apps] (<Enter> to Skip): '

  brew_install () {
    case $REPLY in
                'all') curl -fsSL "$brewfile" | brew bundle --file=- ;;
      'cmds' | 'apps') curl -fsSL "$brewfile" | grep "$1" | awk '{print $2}' | xargs "$2" ;;
    esac
  }

  case $REPLY in
    'all' ) brew_install; break ;;
    'cmds') brew_install '^tap '  '-n1 brew tap'
            brew_install '^brew ' 'brew install'; break ;;
    'apps') brew_install '^tap '  '-n1 brew tap'
            brew_install '^brew ' 'brew install --cask'; break ;;
        '') break ;;
         *) echo "[ERROR] Invalid input! Please enter 'all', 'cmds', 'apps', or <Enter> to skip." ;;
  esac
done

# Run Homebrew utility functions
while true; do
  read -rp 'Run Homebrew diagnostics? (<Enter> to Skip): '
  case $REPLY in
    [Yy]*) brew upgrade
           brew cleanup
           brew doctor; break ;;
       '') break ;;
        *) echo "[ERROR] Invalid input! Please enter 'y' or <Enter> to skip." ;;
  esac
done

# Upgrade applications managed by Homebrew
brew tap buo/cask-upgrade
while true; do
  read -rp 'Run brew cask upgrade? (<Enter> to Skip): '
  case $REPLY in
    [Yy]*) brew cu -af
           break ;;
       '') break ;;
        *) echo "[ERROR] Invalid input! Please enter 'y' or <Enter> to skip." ;;
  esac
done

((step++)); echo "󰓒 [$step/12] SET ENVIRONMENT 󰓒"

# XDG directory structure
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Install requirements
command -v atuin &>/dev/null     || brew install atuin
command -v bat   &>/dev/null     || brew install bat
command -v gh    &>/dev/null     || brew install gh
command -v op    &>/dev/null     || brew install 1password-cli
command -v perl  &>/dev/null     || brew install perl
brew list | grep -q pam-reattach || brew install pam-reattach

# Authenticate 1password-cli
op signin

while true; do
  # Required 
  read -rp 'Git Username: ' GIT_NAME
  read -rp 'Git Email: '    GIT_EMAIL

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

  read -rp "Python Version (<Enter> to set to '3.13.2'): "
  PYTHON_VERSION="${REPLY:-3.13.2}"

  read -rp "Python Download Location (<Enter> to set to '/Applications/Python 3.13'): "
  PYTHON_APP_PATH="${REPLY:-/Applications/Python 3.13}"

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

PYTHON_VERSION=$PYTHON_VERSION
PYTHON_APP_PATH=$PYTHON_APP_PATH

MEDIA=~/$MEDIA
---------------------------------------------
EOF

  read -rp "Re-enter any variables? (<Enter> to continue): "
  [[ -z $REPLY || ! $REPLY =~ ^[Yy]$ ]] && break
done

((step++)); echo "󰓒 [$step/12] CREATE SYMLINKS & DIRECTORIES 󰓒"

symlink() {
  local src="$1"
  local cwd="$2"
  local tgt="$3"
  
  # Test: Valid Current Working Dir
  [ -d "$cwd" ] || return 1
  cd "$cwd"

  # Test: Valid Source File/Folder
  [ -e "$src" ] || return 1

  # Link Source to Target - remove original if directory
  [ -d "$tgt" ] && rm -rf "$tgt"
  ln -sf "$src" "$tgt"

  echo "[+ Link: $src -> $cwd/$tgt]"
}

# Ensure base directories created before symlinking
directories=(
  "$XDG_CACHE_HOME"
  "$XDG_CONFIG_HOME/atuin"
  "$XDG_CONFIG_HOME/op"
  "$XDG_DATA_HOME"
  "$XDG_STATE_HOME"
)
for dir in "$directories[@]"; do [ -d "$dir" ] || mkdir -p "$dir"; done

# NOTE manage all links - provides fine-grained control over GNU stow
symlinks=(
  .dotfiles/hammerspoon        "$HOME" .hammerspoon
  .dotfiles/bash/.bash_profile "$HOME" .bash_profile
  .dotfiles/bash/.bashrc       "$HOME" .bashrc
  .dotfiles/zsh/.zshenv        "$HOME" .zshenv

  ../.dotfiles/1Password "$XDG_CONFIG_HOME" 1Password
  ../.dotfiles/atuin     "$XDG_CONFIG_HOME" atuin
  ../.dotfiles/bash      "$XDG_CONFIG_HOME" bash
  ../.dotfiles/bat       "$XDG_CONFIG_HOME" bat
  ../.dotfiles/blesh     "$XDG_CONFIG_HOME" blesh
  ../.dotfiles/brew      "$XDG_CONFIG_HOME" brew
  ../.dotfiles/btop      "$XDG_CONFIG_HOME" btop
  ../.dotfiles/dust      "$XDG_CONFIG_HOME" dust
  ../.dotfiles/eza       "$XDG_CONFIG_HOME" eza
  ../.dotfiles/fzf       "$XDG_CONFIG_HOME" fzf
  ../.dotfiles/gh        "$XDG_CONFIG_HOME" gh
  ../.dotfiles/git       "$XDG_CONFIG_HOME" git
  ../.dotfiles/glow      "$XDG_CONFIG_HOME" glow
  ../.dotfiles/karabiner "$XDG_CONFIG_HOME" karabiner
  ../.dotfiles/mycli     "$XDG_CONFIG_HOME" mycli
  ../.dotfiles/nvim      "$XDG_CONFIG_HOME" nvim
  ../.dotfiles/ssh       "$XDG_CONFIG_HOME" ssh
  ../.dotfiles/tmux      "$XDG_CONFIG_HOME" tmux
  ../.dotfiles/wezterm   "$XDG_CONFIG_HOME" wezterm
  ../.dotfiles/yazi      "$XDG_CONFIG_HOME" yazi
  ../.dotfiles/youtube   "$XDG_CONFIG_HOME" youtube
  ../.dotfiles/zsh       "$XDG_CONFIG_HOME" zsh

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

((step++)); echo "󰓒 [$step/12] CONFIGURE MACOS OPTIONS 󰓒"
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

((step++)); echo "󰓒 [$step/12] CONFIGURE GIT AND GITHUB CLI 󰓒"

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
gh auth login

((step++)); echo "󰓒 [$step/12] SETUP ATUIN SYNC 󰓒"

# Create Atuin Sync login
op item get "$ATUIN_OP_TITLE" --vault "$OP_VAULT" &>/dev/null || op item create \
  --vault "$OP_VAULT" \
  --category login \
  --title "$ATUIN_OP_TITLE" \
  --generate-password='letters,digits,symbols,32' \
  "username=$ATUIN_USERNAME" \
  "email[text]=$ATUIN_EMAIL" \
  "key[password]=update this with \$(atuin key)" &>/dev/null

# Logout of current session before registering
atuin logout
atuin register -u "$ATUIN_USERNAME" -e "$ATUIN_EMAIL"
atuin login -u "$ATUIN_USERNAME" -p "$(op item get "$ATUIN_OP_TITLE" --vault "$OP_VAULT" --fields password)"

# Sync shell history & integrate with Atuin history
atuin import auto
atuin sync

# Update Atuin Sync with generated key
op item edit "$ATUIN_OP_TITLE" "key=$(atuin key)"

((step++)); echo "󰓒 [$step/12] LOAD BAT THEMES 󰓒"

# Rebuild bat cache any time theme folder changes
bat cache --build

((step++)); echo "󰓒 [$step/12] SETUP TOUCHID SUDO 󰓒"

# Ensure touchid possible in interactive mode or tmux
echo "# Authenticate with Touch ID - even in tmux
auth  optional    $(brew --prefix)/lib/pam/pam_reattach.so ignore_ssh
auth  sufficient  pam_tid.so" | sudo tee /etc/pam.d/sudo_local >/dev/null

# Show changes to sudo_local
bat /etc/pam.d/sudo_local

((step++)); echo "󰓒 [$step/12] DOWNLOAD AND INSTALL PYTHON 󰓒"

# Downloads & installs Python - cleans installer after finishing
if [ ! -d "$PYTHON_APP_PATH" ]; then
  echo "Python 3.13 not found: Downloading and installing..."
  python_link=https://www.python.org/ftp/python/$PYTHON_VERSION/python-$PYTHON_VERSION-macos11.pkg

  curl -o /tmp/python.pkg $python_link || { echo "Python $PYTHON_VERSION download failed"; exit 1; }
  sudo installer -pkg /tmp/python.pkg -target / || { echo "Python $PYTHON_VERSION installation failed"; exit 1; }
  rm -f /tmp/python.pkg

  echo "Python $PYTHON_VERSION installed successfully in $PYTHON_APP_PATH"
else
  echo "Python $PYTHON_VERSION already installed"
fi

# Hide tty login message for iterm
((step++)); echo "󰓒 [$step/12] SURPRESS ITERM2 LOGIN 󰓒"
echo 'Created ~/.hushlogin'
touch "$HOME/.hushlogin" 

((step++)); echo "󰓒 [$step/12] CHANGE SHELL 󰓒"
for shell in bash zsh; do echo "$(brew --prefix)/bin/$shell" | sudo tee -a /etc/shells; done
chsh -s "$(brew --prefix)/bin/zsh"

cd

cat <<EOF
--------------- POST INSTALLATION ---------------

1 Restart terminal emulator

2 Setup Neovim
- Install plugins:         nvim
- Quit Lazy installer:     :q
- Install language servers :MasonInstall lua-language-server basedpyright
- Quit Neovim:             :qa

3 Setup Karabiner Elements
EOF
