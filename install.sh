#!/usr/bin/env bash

# copy home dotfiles
cp -av home/. "$HOME/" && \
echo "All home dotfiles have been copied!";

# copy all .config
cp -rfv .config/. "$HOME/.config/" && \
echo ".config has been copied!";

# Install fzf
FZF_DIR="$HOME/.fzf"
OMZ_DIR="$HOME/.oh-my-zsh"
if ! -d $FZF_DIR
then
  git clone --depth 1 https://github.com/junegunn/fzf.git $FZF_DIR && \
  $FZF_DIR/install && \
  echo "fzf has been installled!";
fi

# Install oh my zsh
if ! -d $OMZ_DIR
then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
  echo "oh my zsh has been installled!";
fi

# Install zsh plugins
echo "Install zsh plugins...";
if ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
  echo "zsh-autosuggestions has been installled!";
fi

if ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
  echo "zsh-syntax-highlighting has been installled!";
fi

if ! -d ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
then
  git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions && \
  echo "zsh-completions has been installled!";
fi
 
# Install git plugins

echo "Install git plugins...";
if ! diff-so-fancy -v &> /dev/null
then
  sudo apt install diff-so-fancy && \
  echo "diff-so-fancy has been installled!";
fi
