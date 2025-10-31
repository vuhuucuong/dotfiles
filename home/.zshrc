
# load ENV & path
source "$HOME/.scripts/env.sh"
# check os
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# load app eval
source "$HOME/.scripts/eval.sh"

# load keybindings
source "$HOME/.scripts/keybindings.sh"
source "$HOME/.scripts/oh-my-zsh.sh"
