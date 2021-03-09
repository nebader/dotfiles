" Nick Bader's .vimrc
" Last updated 25 Sep 2019
""""""""""""""""""""""""""

"
" This is ~/dotfiles/vimrc
" A hard link in ~/.vimrc links to this file
" This file lives in a git repository.  To commit new changes:
" :!git commit -m "Did stuff" 
" :!git push origin master
"

" Leave at the top of the document to avoid issues:
set nocompatible  " Don't try to preserve vi compatibility

" File types and syntax coloration
filetype on " uses $VIMRUNTIME/filetype.vim to figure out the file type
filetype plugin on " can load plugin files for particular file types
filetype indent on " gets indent rules for particular file types
syntax enable " Turns on syntax highlighting

set number relativenumber " show relative line numbers
"set backspace=indent,eol,start " make backspace do what you expect
set ignorecase                 " Make searches case-insensitive.

" Tabs and spaces (using spaces only)
set tabstop=2 " Columns per tabstop
set softtabstop=2 " Spaces per tab
set shiftwidth=2 " Spaces for indent/outdent >>/<<
set shiftround " indent/outdent rounds to the nearest tabstop
set expandtab " Tabs produce spaces instead

" Using vim-plug as a plugin manager
" Start by bootstrapping vim-plug itself
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC

" Now load plugins
call plug#begin()
Plug 'morhetz/gruvbox'
call plug#end()
