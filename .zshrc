export LANG=en_US.UTF-8
export ZSH="~/.oh-my-zsh"

ZSH_THEME=""

plugins=(
  vi-mode
  git
  brew
  docker-compose
  docker
  fzf
  gem
  node
  npm
  nvm
  pip
  pyenv
  sudo
  tmux
  yarn
  man
  npx
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  osx
)

source $ZSH/oh-my-zsh.sh

# Custom configs
export EDITOR="nvim"
export NVM_DIR="$HOME/.nvm"
export PATH="/usr/local/opt/curl/bin:$PATH"

[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=250'
bindkey '^ ' autosuggest-accept

pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic 
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}

zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

eval "$(starship init zsh)"
