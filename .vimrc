call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'terryma/vim-multiple-cursors'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify'
Plug 'christoomey/vim-tmux-navigator'
Plug 'scrooloose/nerdcommenter'
Plug 'Yggdroot/indentLine'
Plug 'jiangmiao/auto-pairs'
Plug 'editorconfig/editorconfig-vim'
Plug 'matze/vim-move'
Plug 'tpope/vim-repeat'
Plug 'easymotion/vim-easymotion'
Plug 'alvan/vim-closetag'
Plug 'ryanoasis/vim-devicons'
Plug 'liuchengxu/vista.vim'
Plug 'joshdick/onedark.vim'

call plug#end()

"Custom Config
syntax on
set encoding=utf-8
set fileencoding=utf-8
set number
set mouse=a
set splitright
set splitbelow
set nofoldenable
set clipboard^=unnamed
set hidden
set backupcopy=yes
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes
" Enable true color
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Used for autocomplete when adding dash
set iskeyword+=\-

" joshdick/onedark.vim
colorscheme onedark
hi Normal guibg=NONE
hi Comment guifg=#A9A9A9 gui=italic
hi CursorLine guibg=#708090 guifg=#FFFFFF
hi Visual guibg=#708090 guifg=#FFFFFF
hi CocHighlightText guibg=#708090 guifg=#FFFFFF

" set color split line
set fillchars=vert:┃ " for vsplits
set fillchars+=fold:· " for folds
hi VertSplit guifg=#87CEFA

" Directory color
hi Directory guifg=#87CEFA

"scrooloose/nerdtree
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeCascadeSingleChildDir=0
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
autocmd BufWinEnter * NERDTreeMirror

" open close icon
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
nmap <Leader>n :NERDTreeToggle<CR>
nmap <Leader>nf :NERDTreeFind<CR>

"fzf
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
nmap <c-p> :FZF<CR>
nmap <c-f> :Ag<CR>

"matze/vim-move
let g:move_key_modifier = 'S'

"alvan/vim-closetag

" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
"
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js,*.tsx'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
"
let g:closetag_filetypes = 'html,xhtml,phtml,jsx'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filetypes = 'xhtml,jsx'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
"
let g:closetag_emptyTags_caseSensitive = 1

" Disables auto-close if not in a "valid" region (based on filetype)
"
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }

" Shortcut for closing tags, default is '>'
"
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
"
let g:closetag_close_shortcut = '<leader>>'

"ryanoasis/vim-devicons

let g:DevIconsEnableFoldersOpenClose = 1
let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol = ' '
let g:DevIconsDefaultFolderOpenSymbol = ' '

"vim-airline/vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" unicode symbols
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
" powerline symbols
let g:airline_left_sep = ""
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ""
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = 'שׂ'
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''

"neoclide/coc.nvim
" list extensions
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
       \]

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

command! -nargs=0 Format :call CocAction('format')
" format all lines of current buffer
nmap <leader>f :Format<CR>
" format selected
nmap <leader>F  <Plug>(coc-format-selected)
xmap <leader>F  <Plug>(coc-format-selected)
"display linting error
nmap <leader>l :CocList diagnostics<CR>
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
autocmd CursorHold * silent call CocActionAsync('highlight')


" autoclose loclist when close buffer
augroup CloseLoclistWindowGroup
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END

"scrooloose/nerdcommenter

let NERDDefaultAlign="left"
let NERDSpaceDelims=1

"liuchengxu/vista.vim
let g:vista_default_executive = 'coc'
nmap <Leader>v :Vista!!<CR>

" BufOnly.vim  -  Delete all the buffers except the current/named buffer.
"
" Copyright November 2003 by Christian J. Robinson <infynity@onewest.net>
"
" Distributed under the terms of the Vim license.  See ":help license".
"
" Usage:
"
" :Bonly / :BOnly / :Bufonly / :BufOnly [buffer]
"
" Without any arguments the current buffer is kept.  With an argument the
" buffer name/number supplied is kept.

command! -nargs=? -complete=buffer -bang Bonly
    \ :call BufOnly('<args>', '<bang>')
command! -nargs=? -complete=buffer -bang BOnly
    \ :call BufOnly('<args>', '<bang>')
command! -nargs=? -complete=buffer -bang Bufonly
    \ :call BufOnly('<args>', '<bang>')
command! -nargs=? -complete=buffer -bang BufOnly
    \ :call BufOnly('<args>', '<bang>')

function! BufOnly(buffer, bang)
	if a:buffer == ''
		" No buffer provided, use the current buffer.
		let buffer = bufnr('%')
	elseif (a:buffer + 0) > 0
		" A buffer number was provided.
		let buffer = bufnr(a:buffer + 0)
	else
		" A buffer name was provided.
		let buffer = bufnr(a:buffer)
	endif

	if buffer == -1
		echohl ErrorMsg
		echomsg "No matching buffer for" a:buffer
		echohl None
		return
	endif

	let last_buffer = bufnr('$')

	let delete_count = 0
	let n = 1
	while n <= last_buffer
		if n != buffer && buflisted(n)
			if a:bang == '' && getbufvar(n, '&modified')
				echohl ErrorMsg
				echomsg 'No write since last change for buffer'
							\ n '(add ! to override)'
				echohl None
			else
				silent exe 'bdel' . a:bang . ' ' . n
				if ! buflisted(n)
					let delete_count = delete_count+1
				endif
			endif
		endif
		let n = n+1
	endwhile

	if delete_count == 1
		echomsg delete_count "buffer deleted"
	elseif delete_count > 1
		echomsg delete_count "buffers deleted"
	endif

endfunction

nmap <Leader>o :BufOnly<CR>
