call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
call plug#end()

xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine
nnoremap <C-h> <Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>
nnoremap <C-l> <Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>
nnoremap gs <Cmd>call VSCodeNotify('typescript.goToSourceDefinition')<CR>
set clipboard=unnamedplus