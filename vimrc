" Nick Bader's .vimrc
" Last updated 1 Apr 17
" Original from Michael Smalley
"""""""""""""""""""""""""""""""

" Keep this file in ~/.vimrc
" On Windows machines, $VIM\_vimrc
"

set nocompatible               " use Vim settings, not Vi; must be first
filetype plugin indent on      " filetype detection[ON] plugin[ON] indent[ON]
set t_Co=256                   " enable 256-color mode.
syntax enable                  " enable syntax highlighting
colorscheme desert             " set colorscheme
set number                     " show line numbers
set laststatus=2               " last window always has a statusline
filetype indent on             " activates indenting for files
set backspace=indent,eol,start " make backspace do what you expect
set nohlsearch                 " Don't continue to highlight searched phrases.
set incsearch                  " But do highlight as you type your search.
set ignorecase                 " Make searches case-insensitive.
set ruler                      " Always show info along bottom.
set autoindent                 " auto-indent
set tabstop=4                  " tab spacing
set softtabstop=4              " unify
set shiftwidth=4               " indent/outdent by 4 columns
set shiftround                 " always indent/outdent to the nearest tabstop
set expandtab                  " use spaces instead of tabs
set smarttab                   " use tabs at the start of line, spaces elsewhere
set nowrap                     " don't wrap text