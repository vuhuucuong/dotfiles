#!/usr/bin/env zsh

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

# Install nvm
if ! brew list nvm &>/dev/null; then
  BREW_PACKAGES+=("nvm")
fi

# yarn
if ! brew list yarn &>/dev/null; then
  BREW_PACKAGES+=("yarn")
fi

# Install atuin
if ! brew list atuin &>/dev/null; then
  BREW_PACKAGES+=("atuin")
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
