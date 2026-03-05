# zsh-users/zsh-syntax-highlighting
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

# WSL: convert Windows paths (C:\foo) to WSL paths (/mnt/c/foo) on paste/drag-drop
if grep -q microsoft /proc/version 2>/dev/null; then
  _wsl_paste_convert() {
    local before_len=${#LBUFFER}
    zle .$WIDGET
    local pasted="${LBUFFER:$before_len}"
    if [[ "$pasted" == *\\* ]]; then
      pasted="$(printf '%s' "$pasted" | sed 's|\\|/|g; s|\([A-Za-z]\):/|/mnt/\L\1/|g')"
      LBUFFER="${LBUFFER:0:$before_len}${pasted}"
    fi
  }
  zle -N bracketed-paste _wsl_paste_convert
fi

# zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#b4befe,bold,underline"
bindkey '^ ' autosuggest-accept
bindkey '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

# aliases
_require_cmd eza    && alias ls='eza'
_require_cmd zellij && alias ze='zellij'
_require_cmd code   && alias c='code'
_require_cmd claude && alias cl='claude'

if grep -q microsoft /proc/version 2>/dev/null; then
  alias open='/mnt/c/Windows/explorer.exe'
  alias cleanWSL='find . -name "*:Zone.Identifier" -type f -delete'
fi

function zc(){
  _require_cmd zoxide || return 1
  z $@;
  echo "Opening $(pwd -P)";
  code .;
}

function zcl(){
  _require_cmd zoxide || return 1
  z $@;
  echo "Opening $(pwd -P)";
  claude;
}

