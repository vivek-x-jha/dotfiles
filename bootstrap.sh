#!/usr/bin/env bash
# TODO Fix zsh compinit: insecure directories: chmod -R go-w "$(brew --prefix)/share"

echo "󰓒 INSTALLATION START 󰓒"

# -------------------------------- Pre-Installation ----------------------------------------

# Turn on 1Password SSH Agent
# https://developer.1password.com/docs/ssh/get-started#step-3-turn-on-the-1password-ssh-agent)

# Ensure Xcode installed
command -v xcode-select &> /dev/null || { echo 'Please run: xcode-select --install'; exit 1; }

echo "󰓒 [1/<steps>] INSTALLING PACKAGE MANAGER 󰓒"
command -v brew &> /dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


# -------------------------------- Install Tools & Apps ----------------------------------------

# Set Homebrew path based on architecture
case "$(uname -m)" in
  'arm64' ) `export HOMEBREW_BIN='/opt/homebrew/bin' ;;
  'x86_64') `export HOMEBREW_BIN='/usr/local/bin' ;;
         *) echo "[! Unknown architecture - requires arm64 or x86_64]"; exit 1 ;;
esac

# Load Homebrew env vars and prepend to path in current session
eval "$("$HOMEBREW_BIN/brew" shellenv)"

echo "󰓒 [2/<steps>] INSTALLING TOOLS & APPS 󰓒"
read -p 'Install [tools/apps/all] (Press Enter to Skip): ' install_type

brew_install () {
  local filter="$1"
  local cmd="$2"
  local repo='https://raw.githubusercontent.com/vivek-x-jha/dotfiles/main'

  case "$install_type" in
    'all') curl -fsSL "$repo/.Brewfile" | brew bundle --file=- ;;
        *) curl -fsSL "$repo/.Brewfile" | grep "$filter" | awk '{print $2}' | xargs "$cmd"
  esac
} 

case "$install_type" in
  'all'  ) brew_install ;;
  'tools') brew_install '^tap '  '-n1 brew tap'
           brew_install '^brew ' 'brew install' ;;
  'apps' ) brew_install '^tap '  '-n1 brew tap'
           brew_install '^brew ' 'brew install --cask' ;;
esac

echo "󰓒 [3/<steps>] RUNNING HOMEBREW DIAGNOSTICS 󰓒"
read -p 'Run Homebrew diagnostics and maintenance? [y/n]: ' brew_diagnostics

if [[ "$brew_diagnostics" =~ ^[Yy]$ ]]; then
  brew upgrade
  brew cleanup
  brew doctor
fi

echo "󰓒 [4/<steps>] INITIALIZING BREW CASK UPGRADE 󰓒"
brew tap buo/cask-upgrade
brew install brew-cask-upgrade

read -p 'Run brew cask upgrade? [y/n]: ' brew_cask_upgrade
[[ "$brew_cask_upgrade" =~ ^[Yy]$ ]] && brew cu -af

# -------------------------------- User Input ----------------------------------------
echo "󰓒 [5/<steps>] SET ENVIRONMENT 󰓒"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

echo "XDG_CONFIG_HOME=$XDG_CONFIG_HOME:=$HOME/.config}"
echo "XDG_CACHE_HOME=$XDG_CACHE_HOME:=$HOME/.cache}"
echo "XDG_DATA_HOME=$XDG_DATA_HOME:=$HOME/.local/share}"
echo "XDG_STATE_HOME=$XDG_STATE_HOME:=$HOME/.local/state}"

# Required 
read -p 'Git Username: ' GIT_NAME          # Ari Ganapathi
read -p 'Git Email: ' GIT_EMAIL            # ariganapathi7@gmail.com
read -p 'Git Signing Key: ' GIT_SIGNINGKEY # AAAAC3NzaC1lZDI1NTE5AAAAICWIS35ryEKaOq1XmBr9NoDlS9TeWcb10YsrLJ3m35e5
read -p 'Atuin Username: ' ATUIN_USERNAME  # ariganapathi7
read -p 'Atuin Email: ' ATUIN_EMAIL        # ariganapathi7@gmail.com

# Optional 
read -p '1Password Vault name (Press Enter to set to "Private"): ' OP_VAULT # Ari's Passwords
read -p '1Password Atuin Sync Title (Press Enter to set to "Atuin Sync"): ' ATUIN_OP_TITLE # Atuin Sync

read -p 'Python URL (Press Enter to set to "https://www.python.org/ftp/python/3.13.1/python-3.13.1-macos11.pkg"): ' PYTHON_URL
read -p 'Python Download Location (Press Enter to set to "/Applications/Python 3.13"): ' PYTHON_APP_PATH

# -------------------------------- Symlinks & Directories ----------------------------------------
echo "󰓒 [6/<steps>] CREATE SYMLINKS & DIRECTORIES 󰓒"

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
  ../.dotfiles/zsh       "$XDG_CONFIG_HOME" zsh 

  ../.dotfiles/starship/config.toml "$XDG_CONFIG_HOME" starship.toml
  ../../.dotfiles/op/plugins.sh "$XDG_CONFIG_HOME/op"  plugins.sh

  ../../.dotfiles/eza          "$HOME/Library/Application Support" eza

  zsh-autocomplete.plugin.zsh  "$(brew --prefix)/share/zsh-autocomplete"        autocomplete.zsh
  zsh-autosuggestions.zsh      "$(brew --prefix)/share/zsh-autosuggestions"     autosuggestions.zsh
  zsh-syntax-highlighting.zsh  "$(brew --prefix)/share/zsh-syntax-highlighting" syntax-highlighting.zsh
)

for ((i=0; i<${#symlinks[@]}; i+=3)); do symlink "${symlinks[i]}" "${symlinks[i+1]}" "${symlinks[i+2]}"; done

# -------------------------------- Configure macOS options ----------------------------------------
echo "󰓒 [7/<steps>] CONFIGURE MACOS OPTIONS 󰓒"

# Screenshots
[ -d "$HOME/Pictures/screenshots" ] || mkdir "$HOME/Pictures/screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/screenshots"

# Dock 
defaults write com.apple.dock autohide-delay -float 0.1                     # speed up dock animation
defaults write com.apple.dock autohide-time-modifier -int 0
defaults write com.apple.dock appswitcher-all-displays -bool true           # show app switcher on all screens
defaults write com.apple.dock expose-animation-duration -float 0.1          # shorten mission conrol animation

# Finder
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"         # use list view
defaults write com.apple.finder QuitMenuItem -bool true                     # quit via ⌘ + Q
defaults write com.apple.finder AppleShowAllFiles -bool true                # show hidden files
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false  # disable file ext change warning

# -------------------------------- Configure Git and GitHub CLI ----------------------------------------
echo "󰓒 [8/<steps>] CONFIGURE GIT AND GITHUB CLI 󰓒"

# Change git protocol for dotfiles
git -C "$HOME/.dotfiles" remote set-url origin git@github.com:arig07/dotfiles.git

# Set custom git config fields
git config --global user.name       "$GIT_NAME"
git config --global user.email      "$GIT_EMAIL"
git config --global user.signingkey "$GIT_SIGNINGKEY"

# Set Allowed Signers
echo "$GIT_EMAIL $GIT_SIGNINGKEY" > "$XDG_CONFIG_HOME/ssh/allowed_signers"

# Authenticate GitHub CLI
gh auth login

# Update 1Password SSH Agent
cat <<EOF > "$XDG_CONFIG_HOME/1Password/ssh/agent.toml"
# https://developer.1password.com/docs/ssh/agent/config

[[ssh-keys]]
item = "GitHub Signing Key"
vault = "$OP_VAULT"
EOF

# -------------------------------- Setup Atuin & Sync ----------------------------------------
echo "󰓒 [9/<steps>] SETUP ATUIN & SYNC 󰓒"

# Create 1Password item
command -v op &>/dev/null || brew install 1password-cli
op signin && op item create \
    --vault "${OP_VAULT:-Private}" \
    --category login \
    --title "${ATUIN_OP_TITLE:-Atuin Sync}" \
    --generate-password='letters,digits,symbols,32' \
    "username=$ATUIN_USERNAME" \
    "email[text]=$ATUIN_EMAIL" \
    "key[password]=update this with \$(atuin key)" &>/dev/null

# Register Atuin and update 1Password item key
atuin register -u "$ATUIN_USERNAME" -e "$ATUIN_EMAIL"
op item edit "$ATUIN_OP_TITLE" "key=$(atuin key)"
atuin import auto && atuin sync

# -------------------------------- Install Python ----------------------------------------
echo "󰓒 [10/<steps>] INSTALL PYTHON 󰓒"

# Download and install Python 3.13
if [ ! -d "$PYTHON_APP_PATH" ]; then
  echo "Python 3.13 not found: Downloading and installing..."

  curl -o '/tmp/python.pkg' "$PYTHON_URL" || { echo "Python 3.13 download failed"; exit 1; }
  sudo installer -pkg '/tmp/python.pkg' -target / || { echo "Python 3.13 installation failed"; exit 1; }
  rm -f '/tmp/python.pkg'
  
  echo "Python 3.13 installed successfully in $PYTHON_APP_PATH"
else
  echo "Python 3.13 already installed"
fi

# -------------------------------- Setup iTerm2 ----------------------------------------
echo "󰓒 [11/<steps>] SETUP ITERM 󰓒"

# Surpress iterm2 login message
touch "$HOME/.hushlogin"

# -------------------------------- Setup Bat ----------------------------------------
echo "󰓒 [12/<steps>] SETUP BAT 󰓒"

# Load bat themes
command -v bat &>/dev/null || brew install bat
bat cache --build

# -------------------------------- Setup Neovim ----------------------------------------
echo "󰓒 [13/<steps>] SETUP NEOVIM 󰓒"

# Installs lazy.nvim and plugins
# After installation finishes run :MasonInstall lua-language-server basedpyright
cd; nvim

echo "󰓒 INSTALLATION COMPLETE 󰓒"
