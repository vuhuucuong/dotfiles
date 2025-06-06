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
zstyle ':autocomplete:*' delay 2  # seconds (float)

# zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#a6adc8,bold,underline"
bindkey '^ ' autosuggest-accept
bindkey '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

# aliases
alias f='fuck'
alias ls='eza'

if grep -q "WSL" /proc/version; then
  alias open='/mnt/c/Windows/explorer.exe'
  alias cleanWSL='find . -name "*:Zone.Identifier" -type f -delete'
fi

function zc(){
  z $@;
  echo "Opening $(pwd -P)";
  code .;
}

