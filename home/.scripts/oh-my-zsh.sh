# Install zsh-users plugins if they don't exist
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

ZSH_PLUGIN_REPOS=(
  "zsh-users/zsh-syntax-highlighting"
  "zsh-users/zsh-autosuggestions"
  "zsh-users/zsh-completions"
)

for repo in "${ZSH_PLUGIN_REPOS[@]}"; do
  plugin_name=$(basename "$repo")
  if [[ ! -d "$ZSH_CUSTOM/plugins/$plugin_name" ]]; then
    git clone "https://github.com/$repo.git" "$ZSH_CUSTOM/plugins/$plugin_name"
  fi
done

# Install powerlevel10k theme if it doesn't exist
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
  git clone --depth=1 "https://github.com/romkatv/powerlevel10k.git" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  git
  pip
  command-not-found
  vi-mode
  brew
  docker-compose
  docker
  fzf
  gem
  node
  nvm
  sudo
  yarn
  man
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-completions
)
source "$ZSH/oh-my-zsh.sh"

# zsh-users/zsh-autosuggestions
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

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#b4befe,bold,underline"
bindkey '^ ' autosuggest-accept
