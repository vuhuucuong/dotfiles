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
    echo -e "❌ PLEASE INSTALL BREW FIRST: https://brew.sh"
    exit 1
  fi
}

# Copy dotfiles from home/ to $HOME
copy_dotfiles() {
  echo "📁 Copying home dotfiles..."
  rsync -av --progress home/ "$HOME" --exclude .git &&
    echo "✅ All home dotfiles have been copied!"
  # Ensure Claude Code status line script is executable
  chmod +x "$HOME/.claude/statusline.sh" 2>/dev/null || true
}

# Install APT packages on Linux
install_apt_packages() {
  if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo -e "⏭️  Skipping APT packages (not on Linux)\n----------\n"
    return
  fi

  echo -e "📦 [INSTALLING APT PACKAGES]\n"
  
  # Filter out already installed APT packages
  local APT_PACKAGES_TO_INSTALL=($(
    for package in "${APT_PACKAGES[@]}"; do
      dpkg -l | grep -q "^ii  $package " || echo "$package"
    done
  ))

  # Install missing APT packages
  if [ ${#APT_PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
    echo -e "🔧 Installing APT packages: ${APT_PACKAGES_TO_INSTALL[*]}\n----------\n"
    sudo apt update && sudo apt install -y "${APT_PACKAGES_TO_INSTALL[@]}" &&
      echo -e "✅ Installed: ${APT_PACKAGES_TO_INSTALL[*]}\n----------\n"
  else
    echo -e "✅ All APT packages are already installed.\n----------\n"
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
      echo "✅ '$binary_name' is up to date. Skipping..."
      return 0
    fi
    echo "🔄 Checksum differs. Updating $binary_name..."
  fi

  mv "$source_path" "$binary_path"
  chmod +x "$binary_path"
  echo "✅ Installed: $binary_name (checksum: $new_checksum)"
}

# Install binaries to ~/.local/bin
install_binaries() {
  echo -e "📦 [INSTALLING BINARIES]\n"
  
  # Select appropriate binary list based on OS
  local BINARY_URLS=()
  if [[ "$OSTYPE" == "darwin"* ]]; then
    BINARY_URLS=("${BINARY_URLS_MAC[@]}")
    echo "ℹ️  Using macOS binaries..."
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    BINARY_URLS=("${BINARY_URLS_LINUX[@]}")
    echo "ℹ️  Using Linux binaries..."
  fi

  # Create ~/.local/bin if it doesn't exist
  mkdir -p "$HOME/.local/bin"

  if [ ${#BINARY_URLS[@]} -eq 0 ]; then
    echo -e "⏭️  No binaries configured for this OS.\n----------\n"
    return
  fi

  for entry in "${BINARY_URLS[@]}"; do
    local url="${entry%%|*}"
    local binary_name="${entry##*|}"
    local binary_path="$HOME/.local/bin/$binary_name"
    local temp_dir=$(mktemp -d)
    
    echo "⬇️  Downloading $binary_name from $url..."

    if [[ "$url" == *.tar.gz ]]; then
      curl -fsSL "$url" -o "$temp_dir/archive.tar.gz" || { echo "❌ Failed to download $binary_name"; rm -rf "$temp_dir"; continue; }
      echo "📦 Extracting $binary_name..."
      tar -xzf "$temp_dir/archive.tar.gz" -C "$temp_dir"
      local extracted=$(find "$temp_dir" -name "$binary_name" -type f | head -n 1)
      [ -z "$extracted" ] && { echo "❌ Could not find $binary_name in archive"; rm -rf "$temp_dir"; continue; }
      _finalize_binary "$extracted" "$binary_name"
    else
      curl -fsSL "$url" -o "$temp_dir/$binary_name" || { echo "❌ Failed to download $binary_name"; rm -rf "$temp_dir"; continue; }
      _finalize_binary "$temp_dir/$binary_name" "$binary_name"
    fi
    rm -rf "$temp_dir"
  done

  echo -e "✅ Binary installation complete.\n----------\n"
}

# Install Homebrew packages
install_brew_packages() {
  echo -e "📦 [INSTALLING BREW PACKAGES]\n"
    # Select appropriate package list based on OS
  local BREW_PACKAGES=()
  if [[ "$OSTYPE" == "darwin"* ]]; then
    BREW_PACKAGES=("${BREW_PACKAGES_MAC[@]}")
    echo "ℹ️  Using macOS packages..."
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    BREW_PACKAGES=("${BREW_PACKAGES_LINUX[@]}")
    echo "ℹ️  Using Linux packages..."
  fi
    # Filter out already installed packages
  local PACKAGES_TO_INSTALL=($(
    for package in "${BREW_PACKAGES[@]}"; do
      brew list "$package" &>/dev/null || echo "$package"
    done
  ))

  # Install missing packages
  if [ ${#PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
    echo -e "🔧 Installing packages: ${PACKAGES_TO_INSTALL[*]}\n----------\n"
    brew install --verbose "${PACKAGES_TO_INSTALL[@]}" &&
      echo -e "✅ Installed: ${PACKAGES_TO_INSTALL[*]}\n----------\n"
  else
    echo -e "✅ All Brew packages are already installed.\n----------\n"
  fi
}

# Copy .wezterm.lua to Windows user profile (WSL only)
copy_wezterm_to_windows() {
  if ! grep -q microsoft /proc/version 2>/dev/null; then
    echo -e "⏭️  Skipping Windows WezTerm copy (not on WSL)\n----------\n"
    return
  fi

  local win_home
  win_home=$(wslpath "$(cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")

  if [ -z "$win_home" ] || [ ! -d "$win_home" ]; then
    echo -e "⚠️  Could not resolve Windows user profile path. Skipping WezTerm copy.\n----------\n"
    return
  fi

  echo "📁 Copying .wezterm.lua to Windows profile ($win_home)..."
  cp "$HOME/.wezterm.lua" "$win_home/.wezterm.lua" &&
    echo -e "✅ .wezterm.lua copied to $win_home\n----------\n" ||
    echo -e "❌ Failed to copy .wezterm.lua to Windows profile\n----------\n"
}

# Source the updated .zshrc
reload_zshrc() {
  echo -e "🔄 Sourcing .zshrc\n----------\n"
  source "$HOME/.zshrc"
  echo -e "🎉 Finished!\n----------\n"
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
