#!/usr/bin/env zsh

if [ -z "$ZSH_VERSION" ]; then
  echo "Please switch to Zsh shell before running this script."
  exit 1
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "oh-my-zsh not found. Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if ! command -v brew &>/dev/null; then
  echo -e "PLEASE INSTALL BREW FIRST: https://brew.sh"
  exit 1
fi


# copy home dotfiles
rsync -av --progress home/ "$HOME" --exclude .git &&
  echo "All home dotfiles have been copied!"

# Only install APT packages on Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo -e "[INSTALLING APT PACKAGES]\n"
  # Define APT packages to install
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

  # Filter out already installed APT packages
  APT_PACKAGES_TO_INSTALL=($(
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
else
  echo -e "Skipping APT packages (not on Linux)\n----------\n"
fi


echo -e "[INSTALLING BREW PACKAGES]\n"
# Define packages to install
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

# Filter out already installed packages
PACKAGES_TO_INSTALL=($(
  for package in "${BREW_PACKAGES[@]}"; do
    brew list "$package" &>/dev/null || echo "$package"
  done
))

# Install missing packages
if [ ${#PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
  echo -e "Installing packages: ${PACKAGES_TO_INSTALL[*]}\n----------\n"
  brew install "${PACKAGES_TO_INSTALL[@]}" &&
    echo -e "Installed: ${PACKAGES_TO_INSTALL[*]}\n----------\n"
fi

echo -e "Sourcing .zshrc\n----------\n"
source $HOME/.zshrc
echo -e "Finished!\n----------\n"
