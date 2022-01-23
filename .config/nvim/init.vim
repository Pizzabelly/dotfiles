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

let g:startify_filename_max_len = 50

let g:startify_files_number = 12
let g:startify_enable_special = 0
let g:startify_lists = [
      \ { 'type': 'files', 'header': ["Recent Files: (r)"] },
      \ ]

call plug#begin('~/.vim/plugged')
    Plug 'dylanaraps/wal.vim'
    "Plug 'mhinz/vim-startify', { 'commit': '81e36c3' }
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'neovim/nvim-lspconfig'
call plug#end()

let g:deoplete#enable_at_startup = 1
" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

lua << EOF
require'lspconfig'.clangd.setup{}
EOF

colo wal
