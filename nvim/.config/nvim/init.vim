" After editing, run :source $MYVIMRC to update changes

" PLUGINS "
" Using the 'vim-plug' plugin manager
" If the vim-plug file does not yet exist, get it via Terminal:
" curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" Occasionally call :PlugUpdate to update plugins
" After removing a plugin, :PlugClean will delete the files

" Use vim-plug to install the plugins
call plug#begin('~/.local/share/nvim/plugged') "put plugs in std nvim dir
Plug 'morhetz/gruvbox' " A nifty color scheme
Plug 'tpope/vim-surround' " can edit surrounding text like quotes
Plug 'lervag/vimtex' " lightweight LaTeX plugin
Plug 'jalvesaq/Nvim-R' " R plugin
call plug#end()
"
" Color scheme
set termguicolors
colorscheme gruvbox

" Line numbers
set number relativenumber

" Ctrl-c sends visual range to the system clipboard
set clipboard=unnamed

" File finding
"set path+=** " Searches all subdirectories of current directory
