# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# load ENV & path
source "$HOME/.scripts/env.sh"
# check os
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# zsh plugin manager
source "$HOME/.scripts/antigen.sh"
# load app
source "$HOME/.scripts/app.sh"

eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"
eval $(thefuck --alias)

# load keybindings
source "$HOME/.scripts/keybindings.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
