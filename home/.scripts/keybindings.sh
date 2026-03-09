# WSL-specific settings
if grep -q microsoft /proc/version 2>/dev/null; then
  # Convert Windows paths (C:\foo) to WSL paths (/mnt/c/foo) on paste/drag-drop
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

  alias open='/mnt/c/Windows/explorer.exe'
  alias cleanWSL='find . -name "*:Zone.Identifier" -type f -delete'
fi

# aliases
_require_cmd eza    && alias ls='eza'
_require_cmd zellij && alias ze='zellij'
_require_cmd code   && alias c='code'
_require_cmd claude && alias cl='claude'

function zc() {
  _require_cmd zoxide || return 1
  z "$@"
  echo "Opening $(pwd -P)"
  code .
}

function zcl() {
  _require_cmd zoxide || return 1
  z "$@"
  echo "Opening $(pwd -P)"
  claude
}
