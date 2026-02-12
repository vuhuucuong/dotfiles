#!/usr/bin/env zsh

# ============================================
# CONFIGURATION
# ============================================

# APT packages to install on Linux
APT_PACKAGES=(
  "curl"
  "htop"
  "iperf3"
  "lsof"
  "rsync"
  "vim"
  "wget"
  "progress"
  "gcc"
)

# Homebrew packages to install
BREW_PACKAGES=(
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
  "opencode"
)

# Binary URLs for macOS in format: "URL|BINARY_NAME"
BINARY_URLS_MAC=(
  # Add macOS binary URLs here
  # Example: "https://example.com/tool-mac|tool"
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
    echo "Please switch to Zsh shell before running this script."
    exit 1
  fi
}

# Install oh-my-zsh if not present
install_oh_my_zsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "oh-my-zsh not found. Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
}

# Check if Homebrew is installed
check_brew() {
  if ! command -v brew &>/dev/null; then
    echo -e "PLEASE INSTALL BREW FIRST: https://brew.sh"
    exit 1
  fi
}

# Copy dotfiles from home/ to $HOME
copy_dotfiles() {
  echo "Copying home dotfiles..."
  rsync -av --progress home/ "$HOME" --exclude .git &&
    echo "All home dotfiles have been copied!"
}

# Install APT packages on Linux
install_apt_packages() {
  if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo -e "Skipping APT packages (not on Linux)\n----------\n"
    return
  fi

  echo -e "[INSTALLING APT PACKAGES]\n"
  
  # Filter out already installed APT packages
  local APT_PACKAGES_TO_INSTALL=($(
    for package in "${APT_PACKAGES[@]}"; do
      dpkg -l | grep -q "^ii  $package " || echo "$package"
    done
  ))

  # Install missing APT packages
  if [ ${#APT_PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
    echo -e "Installing APT packages: ${APT_PACKAGES_TO_INSTALL[*]}\n----------\n"
    sudo apt update && sudo apt install -y "${APT_PACKAGES_TO_INSTALL[@]}" &&
      echo -e "Installed: ${APT_PACKAGES_TO_INSTALL[*]}\n----------\n"
  else
    echo -e "All APT packages are already installed.\n----------\n"
  fi
}

# Install binaries to ~/.local/bin
install_binaries() {
  echo -e "[INSTALLING BINARIES]\n"
  
  # Select appropriate binary list based on OS
  local BINARY_URLS=()
  if [[ "$OSTYPE" == "darwin"* ]]; then
    BINARY_URLS=("${BINARY_URLS_MAC[@]}")
    echo "Using macOS binaries..."
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    BINARY_URLS=("${BINARY_URLS_LINUX[@]}")
    echo "Using Linux binaries..."
  fi

  # Create ~/.local/bin if it doesn't exist
  mkdir -p "$HOME/.local/bin"

  if [ ${#BINARY_URLS[@]} -eq 0 ]; then
    echo -e "No binaries configured for this OS.\n----------\n"
    return
  fi

  for entry in "${BINARY_URLS[@]}"; do
    local url="${entry%%|*}"
    local binary_name="${entry##*|}"
    local binary_path="$HOME/.local/bin/$binary_name"

    if [ -f "$binary_path" ]; then
      echo "Binary '$binary_name' already exists. Skipping..."
      continue
    fi

    echo "Downloading $binary_name from $url..."
    if curl -fsSL "$url" -o "$binary_path"; then
      chmod +x "$binary_path"
      echo "Installed: $binary_name"
    else
      echo "Failed to download $binary_name"
    fi
  done

  echo -e "Binary installation complete.\n----------\n"
}

# Install Homebrew packages
install_brew_packages() {
  echo -e "[INSTALLING BREW PACKAGES]\n"
  
  # Filter out already installed packages
  local PACKAGES_TO_INSTALL=($(
    for package in "${BREW_PACKAGES[@]}"; do
      brew list "$package" &>/dev/null || echo "$package"
    done
  ))

  # Install missing packages
  if [ ${#PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
    echo -e "Installing packages: ${PACKAGES_TO_INSTALL[*]}\n----------\n"
    brew install "${PACKAGES_TO_INSTALL[@]}" &&
      echo -e "Installed: ${PACKAGES_TO_INSTALL[*]}\n----------\n"
  else
    echo -e "All Brew packages are already installed.\n----------\n"
  fi
}

# Source the updated .zshrc
reload_zshrc() {
  echo -e "Sourcing .zshrc\n----------\n"
  source "$HOME/.zshrc"
  echo -e "Finished!\n----------\n"
}

# Main execution
main() {
  check_zsh
  install_oh_my_zsh
  check_brew
  copy_dotfiles
  install_apt_packages
  install_brew_packages
  install_binaries
  reload_zshrc
}

main
