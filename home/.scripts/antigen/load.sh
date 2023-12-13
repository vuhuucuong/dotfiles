source $HOME/.scripts/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
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


# Tell antigen that you're done.
antigen apply

# zsh-users/zsh-syntax-highlighting
# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic 
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}

zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#b1b1b1,bold,underline"
bindkey '^ ' autosuggest-accept
