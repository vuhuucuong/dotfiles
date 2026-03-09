# FZF
_require_cmd fzf && eval "$(fzf --zsh)"

# NVM
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# PYENV
if [[ -d "$PYENV_ROOT/bin" ]]; then
  path=("$PYENV_ROOT/bin" "${path[@]}")
  eval "$(pyenv init - zsh)"
fi
_require_cmd zoxide && eval "$(zoxide init zsh)"
_require_cmd atuin  && eval "$(atuin init zsh)"
