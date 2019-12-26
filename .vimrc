set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'terryma/vim-multiple-cursors'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

colo elflord
syntax enable
set tabstop=4
set softtabstop=4
set expandtab
set number
set showcmd
set cursorline
set lazyredraw
set incsearch
set hlsearch
autocmd BufNewFile,BufRead * setlocal formatoptions-=r

set pastetoggle=<F2>
