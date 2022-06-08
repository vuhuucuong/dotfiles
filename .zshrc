export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export ZSH="$HOME/.oh-my-zsh"

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
  nvm
  pip
  sudo
  tmux
  yarn
  man
  npm
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)

source $ZSH/oh-my-zsh.sh

# Custom configs
export EDITOR="vim"
export NVM_DIR="$HOME/.nvm"
export PATH="$(yarn global bin):$HOME/.local/bin:/usr/local/opt/curl/bin:$PATH"

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

bindkey '^R' history-incremental-search-backward

zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

eval "$(starship init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# pnpm
export PNPM_HOME="/home/cuong/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true
