call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdcommenter'
Plug 'Yggdroot/indentLine'
Plug 'jiangmiao/auto-pairs'
Plug 'editorconfig/editorconfig-vim'
Plug 'matze/vim-move'
Plug 'tpope/vim-repeat'
Plug 'easymotion/vim-easymotion'
Plug 'alvan/vim-closetag'
Plug 'ryanoasis/vim-devicons'
Plug 'liuchengxu/vista.vim'
Plug 'suan/vim-instant-markdown', {'for': 'markdown'}
Plug 'morhetz/gruvbox'
Plug 'vim-scripts/BufOnly.vim'

call plug#end()

colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'

" Custom configs
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

filetype plugin on
syntax on

set encoding=utf-8
set fileencoding=utf-8
set number
set mouse=a
set splitright
set splitbelow
set nofoldenable
set backupcopy=yes
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes
set iskeyword+=\-

hi Normal guibg=NONE
hi Comment guifg=#A9A9A9 gui=italic
hi CursorLine guibg=#708090 guifg=#FFFFFF

" Custom key mapping
nmap gb :bn<CR>
nmap gB :bp<CR>
nmap <leader>bl :ls<CR>:b<space>
nmap <C-J> <C-W>w
nmap <C-K> <C-W>W
nmap <C-L> <C-W>l
nmap <C-H> <C-W>h
nmap <Leader>n :NERDTreeToggle<CR>
nmap <Leader>nf :NERDTreeFind<CR>
nmap <c-p> :FZF<CR>
nmap <c-f> :Ag<CR>
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <leader>f :Format<CR>
nmap <leader>l :CocList diagnostics<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <Leader>v :Vista!!<CR>
nmap <Leader>bo :BufOnly<CR>
nmap <Leader>to :tabonly<CR>
xmap <leader>f  <Plug>(coc-format-selected)
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" scrooloose/nerdtree
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeCascadeSingleChildDir=0
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
autocmd BufWinEnter * NERDTreeMirror

"scrooloose/nerdcommenter
let NERDDefaultAlign="left"
let NERDSpaceDelims=1

" junegunn/fzf.vim
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
let g:fzf_buffers_jump = 1
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" matze/vim-move
let g:move_key_modifier = 'S'

" alvan/vim-closetag
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js,*.tsx'
let g:closetag_filetypes = 'html,xhtml,phtml,jsx'
let g:closetag_xhtml_filetypes = 'xhtml,jsx'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }
let g:closetag_shortcut = '>'
let g:closetag_close_shortcut = '<leader>>'

" ryanoasis/vim-devicons
let g:DevIconsEnableFoldersOpenClose = 1
let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol = ' '
let g:DevIconsDefaultFolderOpenSymbol = ' '

" vim-airline/vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.dirty='⚡'


" vim-airline/vim-airline-themes
let g:airline_theme='bubblegum'

" neoclide/coc.nvim
let g:coc_global_extensions = [
     \ 'coc-lists',
     \ 'coc-prettier',
     \ 'coc-eslint',
     \ 'coc-snippets',
     \ 'coc-emmet',
     \ 'coc-yank',
     \ 'jest-snippets',
     \ 'coc-highlight',
     \ 'coc-tsserver',
     \ 'coc-python',
     \ 'coc-html',
     \ 'coc-json',
     \ 'coc-yaml',
     \ 'coc-markdownlint',
     \ 'coc-css',
     \ 'coc-go',
     \]

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

command! -nargs=0 Format :call CocAction('format')
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup CloseLoclistWindowGroup
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END

" liuchengxu/vista.vim
let g:vista_default_executive = 'coc'
