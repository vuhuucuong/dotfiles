#!/usr/bin/env bash

# Install fzf
FZF_DIR="$HOME/.fzf"
OMZ_DIR="$HOME/.oh-my-zsh"
if [ ! -d $FZF_DIR ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git $FZF_DIR;
  $FZF_DIR/install;
  echo "fzf installled!";
fi

# Install oh my zsh
if [ ! -d $OMZ_DIR ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)";
  echo "oh my zsh installled!";
fi

# Install zsh plugins
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions;
  echo "zsh-autosuggestions installled!";
fi
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting;
  echo "source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc;
  echo "zsh-syntax-highlighting installled!";
fi
