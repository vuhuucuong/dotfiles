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
# Install fzf
BREW_PACKAGES=()

if ! brew list fzf &>/dev/null; then
  BREW_PACKAGES+=("fzf")
fi

if ! brew list zoxide &>/dev/null; then
  BREW_PACKAGES+=("zoxide")
fi

# Install antigen oh my zsh plugin manager
if ! brew list antigen &>/dev/null; then
  BREW_PACKAGES+=("antigen")
fi

# Install atuin
if ! brew list atuin &>/dev/null; then
  BREW_PACKAGES+=("atuin")
fi

# Install thefuck
if ! brew list thefuck &>/dev/null; then
  BREW_PACKAGES+=("thefuck")
fi

# Install exa
if ! brew list exa &>/dev/null; then
  BREW_PACKAGES+=("exa")
fi

# Install nvm
if ! brew list nvm &>/dev/null; then
  BREW_PACKAGES+=("nvm")
fi

# Install pyenv
if ! brew list pyenv &>/dev/null; then
  BREW_PACKAGES+=("pyenv")
fi

# yarn
if ! brew list yarn &>/dev/null; then
  BREW_PACKAGES+=("yarn")
fi

# Install git plugins

# diff-so-fancy
if ! brew list diff-so-fancy &>/dev/null; then
  BREW_PACKAGES+=("diff-so-fancy")
fi

# delta
if ! brew list git-delta &>/dev/null; then
  BREW_PACKAGES+=("git-delta")
fi

# install brew packages
if [ ${#BREW_PACKAGES[@]} -gt 0 ]; then
  echo -e "Installing packages: ${BREW_PACKAGES[@]}\n----------\n"
  brew install "${BREW_PACKAGES[@]}" &&
    echo -e "Installed: ${BREW_PACKAGES[@]}\n----------\n"
fi

echo -e "Sourcing .zshrc\n----------\n"
source $HOME/.zshrc
echo -e "Finished!\n----------\n"
