#!/usr/bin/env bash

# Test: architecture arm64 or x86_64
case "$(uname -m)" in
  'arm64' ) homebrew_bin='/opt/homebrew/bin' ;;
  'x86_64') homebrew_bin='/usr/local/bin' ;;
         *) echo "[! Unknown architecture - requires arm64 or x86_64]"; exit 1 ;;
esac

eval "$("$homebrew_bin/brew" shellenv)"
echo "[ brew: $homebrew_bin]"

install_packages () {
  local install_type="$1"

  brew_install () {
    local filter="$1"
    local cmd="$2"
    local repo='https://raw.githubusercontent.com/vivek-x-jha/dotfiles/main'

    command -v brew &>/dev/null || install_homebrew

    case "$install_type" in
      'all') curl -fsSL "$repo/.Brewfile" | brew bundle --file=- ;;
          *) curl -fsSL "$repo/.Brewfile" | grep "$filter" | awk '{print $2}' | xargs "$cmd"
    esac
  } 

  case "$install_type" in
    'all'     ) brew_install ;;
    'formulas') brew_install '^tap '  '-n1 brew tap'
                brew_install '^brew ' 'brew install' ;;
    'casks'   ) brew_install '^tap '  '-n1 brew tap'
                brew_install '^brew ' 'brew install --cask' ;;
  esac

  # Run Diagnostics
  brew cu -af
  brew upgrade
  brew cleanup
  brew doctor

}

install_packages all
