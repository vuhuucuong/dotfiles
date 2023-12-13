export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="code"

ZSH_THEME=""

# load ENV & path
source "$HOME/.scripts/env/load.sh"
# zsh plugin manager
source "$HOME/.scripts/antigen/load.sh"

# load app
source "$HOME/.scripts/app/node.sh"
source "$HOME/.scripts/app/fzf.sh"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
