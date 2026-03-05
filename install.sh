#!/usr/bin/env zsh

# ============================================
# CONFIGURATION
# ============================================

# APT packages to install on Linux
APT_PACKAGES=(
  "curl"
  "unzip"
  "htop"
  "iperf3"
  "lsof"
  "rsync"
  "vim"
  "wget"
  "progress"
  "gcc"
)

# Homebrew packages to install on macOS
BREW_PACKAGES_MAC=(
  "jq"
  "unzip"
  "fzf"
  "zoxide"
  "antidote"
  "nvm"
  "pyenv"
  "yarn"
  "atuin"
  "neovim"
  "delta"
  # "eza"
  # "zellij"
  "rust"
  "docker"
  "docker-compose"
  "iperf3"
  "shfmt"
  "pnpm"
  "oven-sh/bun/bun" # brew tap oven-sh/bun
)

# Homebrew packages to install on Linux
BREW_PACKAGES_LINUX=(
  "jq"
  "fzf"
  "zoxide"
  "antidote"
  "nvm"
  "pyenv"
  "yarn"
  "atuin"
  "neovim"
  "delta"
  "eza"
  "zellij"
  "rust"
  "shfmt"
  "pnpm"
  "oven-sh/bun/bun" # brew tap oven-sh/bun
)

# Binary URLs for macOS in format: "URL|BINARY_NAME"
BINARY_URLS_MAC=(
  # Add macOS binary URLs here
  # Example: "https://example.com/tool-mac|tool"
  "https://github.com/zellij-org/zellij/releases/download/v0.43.1/zellij-x86_64-apple-darwin.tar.gz|zellij"
)

# Binary URLs for Linux in format: "URL|BINARY_NAME"
BINARY_URLS_LINUX=(
  # Add Linux binary URLs here
  # Example: "https://example.com/tool-linux|tool"
)

# ============================================
# FUNCTIONS
# ============================================

_section() { printf "\n\033[1;34m┌─ %s\033[0m\n" "$*"; }

# Check if running in Zsh
check_zsh() {
  if [ -z "$ZSH_VERSION" ]; then
    echo "❌ Please switch to Zsh shell before running this script."
    exit 1
  fi
}

# Install oh-my-zsh if not present
install_oh_my_zsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🔧 oh-my-zsh not found. Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
}

# Check if Homebrew is installed
check_brew() {
  if ! command -v brew &>/dev/null; then
    echo "❌ PLEASE INSTALL BREW FIRST: https://brew.sh"
    exit 1
  fi
}

# Copy dotfiles from home/ to $HOME
copy_dotfiles() {
  _section "Dotfiles"
  rsync -a home/ "$HOME" --exclude .git
  chmod +x "$HOME/.claude/statusline.sh" 2>/dev/null || true
  echo "✅ Dotfiles copied"
}

# Install APT packages on Linux
install_apt_packages() {
  if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    return
  fi

  _section "APT Packages"
  local APT_PACKAGES_TO_INSTALL=($(
    for package in "${APT_PACKAGES[@]}"; do
      dpkg -l | grep -q "^ii  $package " || echo "$package"
    done
  ))

  if [ ${#APT_PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
    echo "  Installing: ${APT_PACKAGES_TO_INSTALL[*]}"
    sudo apt-get update -qq && sudo apt-get install -y -qq "${APT_PACKAGES_TO_INSTALL[@]}"
    echo "✅ APT: installed ${APT_PACKAGES_TO_INSTALL[*]}"
  else
    echo "✅ APT: all packages already installed"
  fi
}

# Shared finalization: compare checksums, install, and clean up
_finalize_binary() {
  local source_path="$1" binary_name="$2"
  local binary_path="$HOME/.local/bin/$binary_name"
  local new_checksum
  new_checksum=$(shasum -a 256 "$source_path" | awk '{print $1}')

  if [ -f "$binary_path" ]; then
    local current_checksum
    current_checksum=$(shasum -a 256 "$binary_path" | awk '{print $1}')
    if [ "$current_checksum" = "$new_checksum" ]; then
      echo "  ✅ $binary_name up to date"
      return 0
    fi
  fi

  mv "$source_path" "$binary_path"
  chmod +x "$binary_path"
  echo "  ✅ $binary_name installed"
}

# Install binaries to ~/.local/bin
install_binaries() {
  _section "Binaries"
  local BINARY_URLS=()
  if [[ "$OSTYPE" == "darwin"* ]]; then
    BINARY_URLS=("${BINARY_URLS_MAC[@]}")
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    BINARY_URLS=("${BINARY_URLS_LINUX[@]}")
  fi

  mkdir -p "$HOME/.local/bin"

  if [ ${#BINARY_URLS[@]} -eq 0 ]; then
    echo "✅ Binaries: none configured"
    return
  fi

  for entry in "${BINARY_URLS[@]}"; do
    local url="${entry%%|*}"
    local binary_name="${entry##*|}"
    local temp_dir=$(mktemp -d)

    echo "  ⬇️  $binary_name..."
    if [[ "$url" == *.tar.gz ]]; then
      curl -fsSL "$url" -o "$temp_dir/archive.tar.gz" || { echo "  ❌ Failed to download $binary_name"; rm -rf "$temp_dir"; continue; }
      tar -xzf "$temp_dir/archive.tar.gz" -C "$temp_dir"
      local extracted=$(find "$temp_dir" -name "$binary_name" -type f | head -n 1)
      [ -z "$extracted" ] && { echo "  ❌ Could not find $binary_name in archive"; rm -rf "$temp_dir"; continue; }
      _finalize_binary "$extracted" "$binary_name"
    else
      curl -fsSL "$url" -o "$temp_dir/$binary_name" || { echo "  ❌ Failed to download $binary_name"; rm -rf "$temp_dir"; continue; }
      _finalize_binary "$temp_dir/$binary_name" "$binary_name"
    fi
    rm -rf "$temp_dir"
  done
  echo "✅ Binaries done"
}

# Install Homebrew packages
install_brew_packages() {
  _section "Brew Packages"
  local BREW_PACKAGES=()
  if [[ "$OSTYPE" == "darwin"* ]]; then
    BREW_PACKAGES=("${BREW_PACKAGES_MAC[@]}")
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    BREW_PACKAGES=("${BREW_PACKAGES_LINUX[@]}")
  fi

  local PACKAGES_TO_INSTALL=($(
    for package in "${BREW_PACKAGES[@]}"; do
      brew list "$package" &>/dev/null || echo "$package"
    done
  ))

  if [ ${#PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
    echo "  Installing: ${PACKAGES_TO_INSTALL[*]}"
    brew install "${PACKAGES_TO_INSTALL[@]}"
    echo "✅ Brew: installed ${PACKAGES_TO_INSTALL[*]}"
  else
    echo "✅ Brew: all packages already installed"
  fi
}

# Copy .wezterm.lua to Windows user profile (WSL only)
copy_wezterm_to_windows() {
  if ! grep -q microsoft /proc/version 2>/dev/null; then
    return
  fi

  local win_home
  win_home=$(wslpath "$(cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")

  if [ -z "$win_home" ] || [ ! -d "$win_home" ]; then
    echo "⚠️  Could not resolve Windows profile path, skipping WezTerm copy"
    return
  fi

  cp "$HOME/.wezterm.lua" "$win_home/.wezterm.lua" &&
    echo "✅ .wezterm.lua → $win_home" ||
    echo "❌ Failed to copy .wezterm.lua to Windows profile"
}

# Source the updated .zshrc
reload_zshrc() {
  source "$HOME/.zshrc"
  echo "🎉 Done!"
}

# Main execution
main() {
  check_zsh
  install_oh_my_zsh
  check_brew
  copy_dotfiles
  copy_wezterm_to_windows
  install_apt_packages
  install_brew_packages
  install_binaries
  reload_zshrc
}

main
