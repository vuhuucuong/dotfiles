source $HOMEBREW_PREFIX/share/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle command-not-found
antigen bundle vi-mode
antigen bundle git
antigen bundle brew
antigen bundle docker-compose
antigen bundle docker
antigen bundle fzf
antigen bundle gem
antigen bundle node
antigen bundle nvm
antigen bundle pip
antigen bundle sudo
antigen bundle tmux
antigen bundle yarn
antigen bundle man
antigen bundle npm

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle marlonrichert/zsh-autocomplete@main

antigen theme romkatv/powerlevel10k

# Tell antigen that you're done.
antigen apply

# please run antigen reset after changing this file
