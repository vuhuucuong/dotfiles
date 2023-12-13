#!/usr/bin/env bash

# copy home dotfiles
rsync -av --progress home/ "$HOME" --exclude .git &&
  echo "All home dotfiles have been copied!"

# copy all .config
rsync -av --progress .config/ "$HOME/.config/" &&
  echo ".config has been copied!"

# Install fzf
FZF_DIR="$HOME/.fzf"

echo -e "[INSTALLING APPS]\n"

if [ ! -d $FZF_DIR ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git $FZF_DIR &&
    $FZF_DIR/install &&
    echo -e "fzf has been installed!\n----------\n"
else
  echo -e "fzf is already installed!\n----------\n"
fi

ANTIGEN_SCRIPT="$HOME/.scripts/antigen/antigen.sh"
# Install antigen oh my zsh plugin manager
if [ ! -f $ANTIGEN_SCRIPT ]; then
  echo "Installing antigen..."
  curl -L git.io/antigen >"$ANTIGEN_SCRIPT" &&
    echo -e "antigen has been installed!\n----------\n"
else
  echo -e "antigen is already installed!\n----------\n"
fi

# Install nvm
NVM_DIR="$HOME/.nvm"
if [ ! -d $NVM_DIR ]; then
  echo "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash &&
    echo -e "nvm has been installed!\n----------\n"
else
  echo -e "nvm is already installed!\n----------\n"
fi

# yarn
if ! command -v yarn &>/dev/null; then
  echo "Installing yarn..."
  curl -o- -L https://yarnpkg.com/install.sh | bash &&
    echo -e "yarn has been installed!\n----------\n"
else
  echo -e "yarn is already installed!\n----------\n"
fi

# Install git plugins

# diff-so-fancy
echo -e "[INSTALLING GIT PLUGINS]\n"
if ! command -v diff-so-fancy &>/dev/null; then
  sudo apt install diff-so-fancy &&
    echo -e "diff-so-fancy has been installed!\n----------\n"
else
  echo -e "diff-so-fancy is already installed!\n----------\n"
fi

# delta
if ! command -v delta &>/dev/null; then
  echo -e "Please install delta here: https://github.com/dandavison/delta\n----------\n"
else
  echo -e "delta is already installed!\n----------\n"
fi
