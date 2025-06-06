#!/usr/bin/env zsh

if [ -z "$ZSH_VERSION" ]; then
  echo "Please switch to Zsh shell before running this script."
  exit 1
fi

if ! command -v brew &>/dev/null; then
  echo -e "PLEASE INSTALL BREW FIRST: https://brew.sh"
  exit 1
fi

# copy home dotfiles
rsync -av --progress home/ "$HOME" --exclude .git &&
  echo "All home dotfiles have been copied!"

# copy all .config
rsync -av --progress .config/ "$HOME/.config/" &&
  echo ".config has been copied!"

echo -e "[INSTALLING APPS]\n"
# Define packages to install
PACKAGES=(
  "fzf"
  "zoxide"
  "antigen"
  "thefuck"
  "nvm"
  "pyenv"
  "yarn"
  "atuin"
  # "nvim"
  "delta"
  "jandedobbeleer/oh-my-posh/oh-my-posh",
  "eza"
)

# Filter out already installed packages
BREW_PACKAGES=($(
  for package in "${PACKAGES[@]}"; do
    brew list "$package" &>/dev/null || echo "$package"
  done
))

# Install missing packages
if [ ${#BREW_PACKAGES[@]} -gt 0 ]; then
  echo -e "Installing packages: ${BREW_PACKAGES[*]}\n----------\n"
  brew install "${BREW_PACKAGES[@]}" &&
    echo -e "Installed: ${BREW_PACKAGES[*]}\n----------\n"
fi

echo -e "Sourcing .zshrc\n----------\n"
source $HOME/.zshrc
echo -e "Finished!\n----------\n"
