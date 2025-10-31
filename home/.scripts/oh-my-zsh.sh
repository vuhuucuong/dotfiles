# Install zsh-users plugins if they don't exist
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

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

ZSH_THEME="robbyrussell"
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
  tmux
  yarn
  man
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-completions
)
source $ZSH/oh-my-zsh.sh