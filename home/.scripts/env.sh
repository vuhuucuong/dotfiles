export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="code"

export NVM_DIR="$HOME/.nvm"
export PYENV_ROOT="$HOME/.pyenv"

# PATH
path+="$HOME/.yarn/bin"
path+="$HOME/.cargo/bin"
path+="$HOME/.local/bin"
path+="/usr/local/opt/curl/bin"

# check if windows wsl
if [ -f /proc/version ] && grep -q microsoft /proc/version; then
  path+="/mnt/c/Program Files/Microsoft VS Code/bin"
  path+="/mnt/c/Users/vuhuu/AppData/Local/Programs/cursor/resources/app/bin"
  path+="/mnt/c/Program Files/WezTerm"
  path+="/mnt/c/Windows"

  # Alias .exe programs so they can be run without the extension
  # Skips /mnt/c/Windows (too many system binaries) and names that shadow native commands
  for _win_dir in \
    "/mnt/c/Program Files/Microsoft VS Code/bin" \
    "/mnt/c/Users/vuhuu/AppData/Local/Programs/cursor/resources/app/bin" \
    "/mnt/c/Program Files/WezTerm"; do
    for _exe in "$_win_dir"/*.exe(N); do
      _cmd="${${_exe##*/}%.exe}"
      (( $+commands[$_cmd] )) || alias "$_cmd"="'$_exe'"
    done
  done
  unset _win_dir _exe _cmd
fi
# include env.secret.sh
if [ -f "$HOME/.scripts/env.secret.sh" ]; then
  source "$HOME/.scripts/env.secret.sh"
fi

export PATH
