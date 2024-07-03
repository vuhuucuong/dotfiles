# load ENV & path
source "$HOME/.scripts/env.sh"
# check os
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# zsh plugin manager
source "$HOME/.scripts/antigen.sh"
# load app
source "$HOME/.scripts/app.sh"

eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"
eval "$(starship init zsh)"
eval $(thefuck --alias)

# load keybindings
source "$HOME/.scripts/keybindings.sh"
