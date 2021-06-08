set wrap!
set number
set signcolumn=yes
set noshowmode

let g:loaded_matchparen=1

set nocompatible
filetype plugin on
syntax on

set tabstop=4
set shiftwidth=4
set expandtab

set autochdir
set noshowmode

let g:startify_font_height = 22.0
let g:startify_font_width  = 10.0

let g:startify_header_image = '/home/pizza/pics/emacs-start.png'

let g:startify_lists = [
      \ { 'type': 'files', 'header': [] },
      \ ]

call plug#begin('~/.vim/plugged')
    Plug 'dylanaraps/wal.vim'
    Plug 'file://'.expand('~/c/contrib/vim-startify')
"    Plug 'mhinz/vim-startify'
call plug#end()

colo wal
