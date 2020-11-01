" Use Vim settings, rather than Vi settings
" This must be first, because it changes other options as a side effect
set nocompatible

call plug#begin()

Plug 'sainnhe/sonokai'
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline'
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'sdiehl/vim-ormolu'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

call plug#end()

" Set theme
colorscheme sonokai

" Allow recursive search into subdirectories
" when using :find
set path+=**

" Tab-based autocomplete below words
set wildmode=longest,list,full

"Ignore certain files and directories
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=*.pdf
set wildignore+=*/node_modules/*,*/__pycache__/*
set wildignore+=*.class

" Keep more info in memory to speed things
set hidden

" Autosave changes when switching buffers
set autowrite

" Show matching parentheses on selecting other
set showmatch

" Allow access to main graphical clipboard
noremap <C-y> "+y
noremap <C-p> "+p

" Open nerdtree browser
map <C-n> :NERDTreeToggle<CR>

" Reload vimrc on \r
map <leader>s :source ~/.vimrc<CR>

" Filetype-specific settings for indentation
autocmd FileType javascript setlocal expandtab tabstop=4 sw=4 softtabstop=4
autocmd FileType html setlocal expandtab tabstop=2 sw=2 softtabstop=2

" Detect filetypes as lisp to allow correct parentheses highlighting
if has("autocmd")
        au BufReadPost *.scm,*.rkt,*.rktl set filetype=lisp
endif
" Turn on rainbow parentheses for lisp
let g:lisp_rainbow = 1
" Enhance lisp formatting
autocmd FileType lisp,scheme,art setlocal equalprg=scmindent.rkt

" Turn on spell checking for text files
autocmd BufNewFile,BufRead *.txt setlocal spell spelllang=en_gb

" Detect assembly
au BufRead,BufNewFile *.s set filetype=gas

" Hightlight from start of file
au BufEnter * :syntax sync fromstart

" Delete whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" HASKELL
" Locate sandbox ormolu formatter
let g:ormolu_command=trim(system("stack exec -- which ormolu"))

" Tabs and spaces
set tabstop=4 " Displays TAB characters as 4 spaces
set softtabstop=4 " Insert 4 spaces when TAB is pressed
set expandtab " Turns TAB key into shortcut for 4 spaces

" Match previous indent on new line
set autoindent

" Set character encoding
set fileencoding=utf-8 " The encoding written to files

" Turn line numbering on
set number
" When set with above enables a hybrid of absolute and relative line nums
set relativenumber

" Show if text goes too far to the right
" shows a line at 80 characters and solid block from 110 onwards
let &colorcolumn="80,".join(range(110,999),",")

" If there are upper-case letters become case-sensitive
set smartcase

" Clear previous search highlight
nmap <silent> ,/ :nohlsearch<CR>

" History and undo
set undolevels=10000

" Toggle auto indent to allow well formatted pasting
set pastetoggle=<F2>

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Change cursor in response to mode
" for urxvt or tmux
if exists("$TMUX")
        let &t_SI = "\ePtmux;\e\e[6 q\e\\"
        let &t_SR = "\ePtmux;\e\e[4 q\e\\"
        let &t_EI = "\ePtmux;\e\e[2 q\e\\"
else
        let &t_SI = "\e[6 q"  " Beam in insert
        let &t_SR = "\e[4 q"  " Underline in replace
        let &t_EI = "\e[2 q"  " Block in normal mode
endif
