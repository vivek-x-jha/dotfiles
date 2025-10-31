# macOS Casks → Linux Availability

| App | Ubuntu (Debian-based) | Fedora (dnf-based) | Notes |
| --- | --- | --- | --- |
| 1Password | `curl -sS https://downloads.1password.com/linux/keys/1password.asc \| sudo gpg --dearmor -o /usr/share/keyrings/1password.gpg`<br>`echo 'deb [signed-by=/usr/share/keyrings/1password.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' \| sudo tee /etc/apt/sources.list.d/1password.list`<br>`sudo apt update && sudo apt install 1password` | `sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc`<br>`sudo tee /etc/yum.repos.d/1password.repo <<'EOF'`<br>`[1password]`<br>`name=1Password`<br>`baseurl=https://downloads.1password.com/linux/rpm/stable/$basearch`<br>`enabled=1`<br>`gpgcheck=1`<br>`gpgkey=https://downloads.1password.com/linux/keys/1password.asc`<br>`EOF`<br>`sudo dnf install 1password` | Official Linux builds. |
| 1Password CLI | Same repo as above: `sudo apt install 1password-cli` | Same repo: `sudo dnf install 1password-cli` | Ships with desktop install, package name differs. |
| Alfred | — | — | macOS-only launcher. Use GNOME/KDE launchers like Albert or Ulauncher. |
| Alt-Tab | — | — | macOS window switcher. Linux DEs have built-in alternatives. |
| Anki | `sudo apt install anki` (22.04+). For newest: download `.tar.zst` from apps.ankiweb.net. | `sudo dnf install anki` | Official packages exist. |
| Arc | — | — | No Linux build yet; use Firefox/Chrome. |
| ChatGPT (OpenAI) | — | — | No native client; use https://chat.openai.com or community flatpaks. |
| ChatGPT Atlas | — | — | macOS-only. |
| CleanShot | — | — | macOS-only screenshot tool; use Flameshot/Shutter on Linux. |
| Codex | — | — | macOS-specific (internal tool). |
| Discord | Download `.deb` from https://discord.com → `sudo apt install ./discord.deb` or `sudo snap install discord`. | Enable RPM Fusion Free: `sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm`<br>`sudo dnf install discord` | Official Linux builds hosted by Discord. |
| Dropbox | `sudo apt install nautilus-dropbox` or download `.deb` from https://dropbox.com/downloading`. | `sudo dnf install nautilus-dropbox` (after enabling RPM Fusion) or download `.rpm`. | First run downloads daemon. |
| Figma | — | — | No official Linux desktop; use web app or `flatpak install flathub io.github.Figma_Linux`. |
| Firefox | `sudo apt install firefox` (default). | `sudo dnf install firefox` (default). | Typically preinstalled. |
| JetBrains Mono Nerd Font | Download latest archive from https://github.com/ryanoasis/nerd-fonts/releases → unzip to `~/.local/share/fonts` → `fc-cache -fv`. | Same as Ubuntu. | Manual install; no distro package. |
| Google Chrome | `wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb`<br>`sudo apt install ./google-chrome-stable_current_amd64.deb` | `wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm`<br>`sudo dnf install google-chrome-stable_current_x86_64.rpm` | Installer adds Google repo for updates. |
| Hammerspoon | — | — | macOS automation app; no Linux equivalent. |
| Image2icon | — | — | macOS-only icon editor. |
| iTerm2 | — | — | macOS-only terminal; use Kitty/WezTerm/Alacritty on Linux. |
| Karabiner-Elements | — | — | macOS keyboard remapper. Linux alternatives: `xremap`, KDE System Settings. |
| KeyCastr | — | — | macOS-only keystroke display; Linux alternatives: `screenkey`, `key-mon`. |
| MacTeX (no GUI) | Install TeX Live: `sudo apt install texlive-full` (or minimal variant). | `sudo dnf install texlive-scheme-full` (or other scheme). | TeX Live replaces MacTeX. |
| Messenger (Meta) | — | — | No official Linux desktop; use https://messenger.com or `flatpak install flathub com.messenger.desktop` (community). |
| Notion Calendar | — | — | macOS/Windows only; use web https://calendar.notion.so. |
| Postman | `sudo snap install postman` or download tarball from https://www.postman.com/downloads. | `flatpak install flathub com.getpostman.Postman` or tarball. | Official tarball; Flatpak maintained. |
| Skim | — | — | macOS PDF reader; Linux alternatives: Okular, Evince. |
| Slack | Download `.deb` from https://slack.com/downloads/linux → `sudo apt install ./slack-desktop-*.deb`. | Download `.rpm` from Slack or enable RPM Fusion and install → `sudo dnf install slack`. | Official builds provided. |
| Spotify | Add repo: `curl -fsSL https://download.spotify.com/debian/pubkey.gpg \| sudo gpg --dearmor -o /usr/share/keyrings/spotify.gpg`<br>`echo 'deb [signed-by=/usr/share/keyrings/spotify.gpg] http://repository.spotify.com stable non-free' \| sudo tee /etc/apt/sources.list.d/spotify.list`<br>`sudo apt update && sudo apt install spotify-client` | Easiest via Flatpak: `flatpak install flathub com.spotify.Client`. Alternatively enable RPM Fusion nonfree and install `sudo dnf install spotify`. | Spotify maintains deb/rpm repos. |
| Thinkorswim | Download Linux installer (`thinkorswim_installer.sh`) from TD Ameritrade → `chmod +x` → run script (requires Java). | Same as Ubuntu. | Official Linux shell installer available. |
| Visual Studio Code | Add Microsoft repo: `curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \| gpg --dearmor \| sudo tee /usr/share/keyrings/ms.gpg >/dev/null`<br>`echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/ms.gpg] https://packages.microsoft.com/repos/code stable main' \| sudo tee /etc/apt/sources.list.d/vscode.list`<br>`sudo apt update && sudo apt install code` | `sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc`<br>`sudo tee /etc/yum.repos.d/vscode.repo <<'EOF'`<br>`[code]`<br>`name=Visual Studio Code`<br>`baseurl=https://packages.microsoft.com/yumrepos/vscode`<br>`enabled=1`<br>`gpgcheck=1`<br>`gpgkey=https://packages.microsoft.com/keys/microsoft.asc`<br>`EOF`<br>`sudo dnf install code` | Official packages with auto updates. |
| VLC | `sudo apt install vlc` | `sudo dnf install vlc` (requires RPM Fusion free) | Widely available. |
| WeChat | — | — | No official Linux build; use Wine (`electronic-wechat`) or web via https://web.wechat.com. |
| WezTerm | Download `.deb` from https://github.com/wez/wezterm/releases or `sudo apt install wezterm` from unofficial PPA. | `sudo dnf install wezterm` (official COPR: `sudo dnf copr enable wez/wezterm && sudo dnf install wezterm`). | Cross-platform terminal maintained upstream. |
| WhatsApp | — | — | No official Linux desktop; use https://web.whatsapp.com or `flatpak install flathub com.github.eneshecan.WhatsAppForLinux`. |

