#!/usr/bin/env bash
# TODO Fix zsh compinit insecure directories warning: chmod -R go-w "$(brew --prefix)/share"

# Turn on 1Password SSH Agent
# https://developer.1password.com/docs/ssh/get-started#step-3-turn-on-the-1password-ssh-agent)

# Ensure Xcode installed
command -v xcode-select &> /dev/null || { echo 'Please run: xcode-select --install'; exit 1; }

declare -i step=1

echo "󰓒 INSTALLATION START 󰓒"
echo "󰓒 [$step/14] INSTALLING PACKAGE MANAGER 󰓒" && step+=1
command -v brew &> /dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Set Homebrew path based on architecture
case "$(uname -m)" in
  'arm64' ) export HOMEBREW_BIN='/opt/homebrew/bin' ;;
  'x86_64') export HOMEBREW_BIN='/usr/local/bin' ;;
         *) echo "[! Unknown architecture - requires arm64 or x86_64]"; exit 1 ;;
esac

# Load Homebrew env vars and prepend to path in current session
eval "$("$HOMEBREW_BIN/brew" shellenv)"

echo "󰓒 [2/14] INSTALLING TOOLS & APPS 󰓒"
read -p 'Install [all/tools/apps] (Press Enter to Skip): '  install_type
read -p 'Run Homebrew diagnostics and maintenance? [y/n]: ' brew_diagnostics
read -p 'Run brew cask upgrade? [y/n]: '                    brew_cask_upgrade

brew_install () {
  local brewfile='https://raw.githubusercontent.com/vivek-x-jha/dotfiles/refs/heads/main/brew/.Brewfile'

  case "$install_type" in
    'all') curl -fsSL "$brewfile" | brew bundle --file=- ;;
        *) curl -fsSL "$brewfile" | grep "$1" | awk '{print $2}' | xargs "$2" ;;
  esac
} 

case "$install_type" in
  'all'  ) brew_install ;;
  'tools') brew_install '^tap '  '-n1 brew tap'
           brew_install '^brew ' 'brew install' ;;
  'apps' ) brew_install '^tap '  '-n1 brew tap'
           brew_install '^brew ' 'brew install --cask' ;;
esac

echo "󰓒 [$step/14] RUNNING HOMEBREW DIAGNOSTICS 󰓒" && step+=1
if [[ "$brew_diagnostics" =~ ^[Yy]$ ]]; then
  brew upgrade
  brew cleanup
  brew doctor
fi

echo "󰓒 [$step/14] INITIALIZING BREW CASK UPGRADE 󰓒" && step+=1
brew tap buo/cask-upgrade
brew install brew-cask-upgrade
[[ "$brew_cask_upgrade" =~ ^[Yy]$ ]] && brew cu -af

echo "󰓒 [$step/14] SET ENVIRONMENT 󰓒" && step+=1
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

while true; do
  # Required 
  read -p 'Git Username: '    GIT_NAME
  read -p 'Git Email: '       GIT_EMAIL
  read -p 'Git Signing Key: ' GIT_SIGNINGKEY # 1password GitHub Signing Key

  DEFAULT_NAME="${GIT_EMAIL%@*}"

  # Optional 
  read -p "GitHub User (Press Enter to set to '$DEFAULT_NAME'): " GITHUB_NAME
  GITHUB_NAME="${GITHUB_NAME:=$DEFAULT_NAME}"

  read -p "Atuin Username (Press Enter to set to '$DEFAULT_NAME'): " ATUIN_USERNAME
  ATUIN_USERNAME="${ATUIN_USERNAME:=$DEFAULT_NAME}"

  read -p "Atuin Email (Press Enter to set to '$GIT_EMAIL'): " ATUIN_EMAIL
  ATUIN_EMAIL="${ATUIN_EMAIL:=$GIT_EMAIL}"

  read -p "1Password Vault name (Press Enter to set to 'Private'): " OP_VAULT
  OP_VAULT="${OP_VAULT:='Private'}"

  read -p "1Password Atuin Sync Title (Press Enter to set to 'Atuin Sync'): " ATUIN_OP_TITLE
  ATUIN_OP_TITLE="${ATUIN_OP_TITLE:='Atuin Sync'}"

  read -p "Python Version (Press Enter to set to '3.13.2'): " PYTHON_VERSION
  PYTHON_VERSION="${PYTHON_VERSION:='3.13.2'}"

  read -p "Python Download Location (Press Enter to set to '/Applications/Python 3.13'): " PYTHON_APP_PATH
  PYTHON_APP_PATH="${PYTHON_APP_PATH:='/Applications/Python 3.13'}"
  
  echo -e "\
  XDG_CONFIG_HOME=$XDG_CONFIG_HOME\n\
  XDG_CACHE_HOME=$XDG_CACHE_HOME\n\
  XDG_DATA_HOME=$XDG_DATA_HOME\n\
  XDG_STATE_HOME=$XDG_STATE_HOME\n\
  \n\
  GIT_NAME=$GIT_NAME\n\
  GIT_EMAIL=$GIT_EMAIL\n\
  GIT_SIGNINGKEY=$GIT_SIGNINGKEY\n\
  \n\
  GITHUB_NAME=$GITHUB_NAME\n\
  ATUIN_USERNAME=$ATUIN_USERNAME\n\
  ATUIN_EMAIL=$ATUIN_EMAIL\n\
  \n\
  OP_VAULT=$OP_VAULT\n\
  ATUIN_OP_TITLE=$ATUIN_OP_TITLE\n\
  \n\
  PYTHON_VERSION=$PYTHON_VERSION\n\
  PYTHON_APP_PATH=$PYTHON_APP_PATH\n"

  read -p "Re-enter any Environment Variables? (Press Enter to continue): " RE_ENTER
  [ -z "$RE_ENTER" ] && break
done

echo "󰓒 [$step/14] CREATE SYMLINKS & DIRECTORIES 󰓒" && step+=1

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
                                              
directories=(
  "$XDG_CACHE"
  "$XDG_CONFIG_HOME/atuin"
  "$XDG_CONFIG_HOME/op"
  "$XDG_DATA"
  "$XDG_STATE"
)
for dir in "$directories[@]"; do [ -d "$dir" ] || mkdir -p "$dir"; done

symlinks=(
  .dotfiles/bash/.bash_profile "$HOME" .bash_profile
  .dotfiles/bash/.bashrc       "$HOME" .bashrc      
  .dotfiles/zsh/.zshenv        "$HOME" .zshenv       
  ../.dotfiles/hammerspoon     "$HOME" .hammerspoon

  ../.dotfiles/1Password "$XDG_CONFIG_HOME" 1Password
  ../.dotfiles/atuin     "$XDG_CONFIG_HOME" atuin
  ../.dotfiles/bash      "$XDG_CONFIG_HOME" bash 
  ../.dotfiles/bat       "$XDG_CONFIG_HOME" bat 
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
  ../.dotfiles/task      "$XDG_CONFIG_HOME" task
  ../.dotfiles/tmux      "$XDG_CONFIG_HOME" tmux
  ../.dotfiles/wezterm   "$XDG_CONFIG_HOME" wezterm
  ../.dotfiles/yazi      "$XDG_CONFIG_HOME" yazi
  ../.dotfiles/youtube   "$XDG_CONFIG_HOME" youtube
  ../.dotfiles/zsh       "$XDG_CONFIG_HOME" zsh 

  ../.dotfiles/starship/config.toml "$XDG_CONFIG_HOME"    starship.toml
  ../../.dotfiles/op/plugins.sh     "$XDG_CONFIG_HOME/op" plugins.sh
  ../../.dotfiles/eza "$HOME/Library/Application Support" eza

  Dropbox/developer      "$HOME"            Developer
  ../Dropbox/content     "$HOME/Movies"     content
  ../Dropbox/icons       "$HOME/Pictures"   icons
  ../Dropbox/screenshots "$HOME/Pictures"   screenshots
  ../Dropbox/wallpapers  "$HOME/Pictures"   wallpapers
  ../Dropbox/education   "$HOME/Documents"  education
  ../Dropbox/finances    "$HOME/Documents"  finances
)

for ((i=0; i<${#symlinks[@]}; i+=3)); do symlink "${symlinks[i]}" "${symlinks[i+1]}" "${symlinks[i+2]}"; done

echo "󰓒 [$step/14] CONFIGURE MACOS OPTIONS 󰓒" && step+=1

echo "opt1: Change default screenshots location to '~/Pictures/screenshots/'"
[ -d "$HOME/Pictures/screenshots" ] || mkdir "$HOME/Pictures/screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/screenshots"

echo 'opt2: Speed up dock animation'
defaults write com.apple.dock autohide-delay -float 0.1

echo 'opt3: Remove dock autohide animation'
defaults write com.apple.dock autohide-time-modifier -int 0

echo 'opt4: Show app switcher on all screens'
defaults write com.apple.dock appswitcher-all-displays -bool true

echo 'opt5: Shorten Mission Control animation'
defaults write com.apple.dock expose-animation-duration -float 0.1

echo 'opt6: Use list view in Finder'
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

echo 'opt7: Enable quitting Finder via ⌘ + Q'
defaults write com.apple.finder QuitMenuItem -bool true

echo 'opt8: Show hidden files in Finder'
defaults write com.apple.finder AppleShowAllFiles -bool true

echo 'opt9: Disable file extension change warning'
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "󰓒 [$step/14] CONFIGURE GIT AND GITHUB CLI 󰓒" && step+=1

git -C "$HOME/.dotfiles" remote set-url origin "git@github.com:$GITHUB_NAME/dotfiles.git"

git config --global user.name       "$GIT_NAME"
git config --global user.email      "$GIT_EMAIL"
git config --global user.signingkey "$GIT_SIGNINGKEY"

echo "$GIT_EMAIL ssh-ed25519 $GIT_SIGNINGKEY" > "$XDG_CONFIG_HOME/ssh/allowed_signers"

command -v gh &> /dev/null || brew install gh && gh auth login

cat <<EOF > "$XDG_CONFIG_HOME/1Password/ssh/agent.toml"
# https://developer.1password.com/docs/ssh/agent/config

[[ssh-keys]]
item = "GitHub Signing Key"
vault = "$OP_VAULT"
EOF

echo "󰓒 [$step/14] SETUP ATUIN & SYNC 󰓒" && step+=1
command -v op &> /dev/null || brew install 1password-cli
op signin && op item create \
  --vault "$OP_VAULT" \
  --category login \
  --title "$ATUIN_OP_TITLE" \
  --generate-password='letters,digits,symbols,32' \
  "username=$ATUIN_USERNAME" \
  "email[text]=$ATUIN_EMAIL" \
  "key[password]=update this with \$(atuin key)" &>/dev/null

command -v atuin &> /dev/null || brew install atuin && atuin register -u "$ATUIN_USERNAME" -e "$ATUIN_EMAIL"
op item edit "$ATUIN_OP_TITLE" "key=$(atuin key)"
atuin import auto && atuin sync

echo "󰓒 [$step/14] DOWNLOAD AND INSTALL PYTHON 󰓒" && step+=1
if [ ! -d "$PYTHON_APP_PATH" ]; then
  echo "Python 3.13 not found: Downloading and installing..."

  curl -o '/tmp/python.pkg' "https://www.python.org/ftp/python/$PYTHON_VERSION/python-$PYTHON_VERSION-macos11.pkg" || { echo "Python $PYTHON_VERSION download failed"; exit 1; }
  sudo installer -pkg '/tmp/python.pkg' -target / || { echo "Python $PYTHON_VERSION installation failed"; exit 1; }
  rm -f '/tmp/python.pkg'

  echo "Python $PYTHON_VERSION installed successfully in $PYTHON_APP_PATH"
else
  echo "Python $PYTHON_VERSION already installed"
fi

echo "󰓒 [$step/14] SETUP ITERM 󰓒" && step+=1
touch "$HOME/.hushlogin" && echo 'Created ~/.hushlogin (Surpresses iterm2 login message)' 

echo "󰓒 [$step/14] LOAD BAT THEMES 󰓒" && step+=1
command -v bat &> /dev/null || brew install bat && bat cache --build

echo "󰓒 [$step/14] SETUP TOUCHID SUDO 󰓒" && step+=1
brew list | grep -q pam-reattach || brew install pam-reattach
sudo cp -f "$HOME/.dotfiles/sudo/sudo_local" /etc/pam.d/sudo_local
[[ "$(uname -m)" == 'x86_64' ]] && sudo sed -i '' 's|/opt/homebrew|/usr/local|g' /etc/pam.d/sudo_local

# Installs lazy.nvim and plugins
echo "󰓒 [$step/14] SETUP NEOVIM 󰓒" && step+=1
cd; command -v nvim &> /dev/null || nvim

# After installation finishes run :MasonInstall lua-language-server basedpyright
echo "󰓒 INSTALLATION COMPLETE 󰓒"
