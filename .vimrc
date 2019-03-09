call plug#begin('~/.vim/plugged')

Plug 'Valloric/YouCompleteMe'
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'terryma/vim-multiple-cursors'
Plug 'airblade/vim-gitgutter'
Plug 'leafgarland/typescript-vim'
Plug 'w0rp/ale'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-sensible'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'pangloss/vim-javascript'
Plug 'junegunn/vim-easy-align'
Plug 'mhinz/vim-startify'
Plug 'ryanoasis/vim-devicons'
Plug 'christoomey/vim-tmux-navigator'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'Yggdroot/indentLine'
Plug 'jiangmiao/auto-pairs'
Plug 'editorconfig/editorconfig-vim'
Plug 'joshdick/onedark.vim'
Plug 'matze/vim-move'
Plug 'mxw/vim-jsx'

call plug#end()

"Custom Config
set number
set mouse=a

"Valloric/YouCompleteMe
set completeopt-=preview
let g:ycm_add_preview_to_completeopt=0

"scrooloose/nerdtree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
let NERDTreeShowHidden=1

"jistr/vim-nerdtree-tabs
map <Leader>n <plug>NERDTreeTabsToggle<CR>

"w0rp/ale
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\   'jsx': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'tslint'],
\   'css': ['prettier', 'stylelint'],
\   'scss': ['prettier', 'stylelint'],
\   'html': ['prettier'],
\}
let g:ale_linters = {
\   'typescript': ['tslint'],
\   'javascript': ['eslint'],
\   'html': ['htmlhint'],
\   'jsx': ['eslint'],
\   'css': ['stylelint'],
\   'scss': ['stylelint'],
\}
let g:ale_fix_on_save = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 1

"junegunn/fzf.vim
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})
nmap <c-p> :FZF<CR>

"ryanoasis/vim-devicons
set encoding=UTF-8

"joshdick/onedark.vim
" Enable true color 启用终端24位色
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

syntax on
colorscheme onedark


"matze/vim-move
let g:move_key_modifier = 'S'
