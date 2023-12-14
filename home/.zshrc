eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# load ENV & path
source "$HOME/.scripts/env.sh"
# zsh plugin manager
source "$HOME/.scripts/antigen.sh"

# load app
source "$HOME/.scripts/app.sh"

