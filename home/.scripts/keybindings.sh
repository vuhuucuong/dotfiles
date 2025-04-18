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
zstyle ':autocomplete:*' delay 0.3  # seconds (float)

# zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#a6adc8,bold,underline"
bindkey '^ ' autosuggest-accept
bindkey '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

# aliases
alias f='fuck'
if grep -q "WSL" /proc/version; then
  alias e='/mnt/c/Windows/explorer.exe'
fi
function zc(){
  z $@;
  echo "Opening $(pwd -P)";
  code .;
}

