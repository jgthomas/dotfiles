" Use Vim settings, rather than Vi settings
" This must be first, because it changes other options as a side effect
set nocompatible

" Load plugins
call pathogen#infect()

" If using snazzy theme, use transparent background
let g:SnazzyTransparent = 1

" Switch on syntax highlighting
syntax on

" Set theme
colorscheme gruvbox
set background=dark

" Allow recursive search into subdirectories
" when using :find
set path+=**

" Tab-based autocomplete below words
set wildmode=longest,list,full

" Display all matching files in status bar on tab
" start with :b to search buffers
set wildmenu

"Ignore certain files and directories
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=*.pdf
set wildignore+=*/node_modules/*

" Built-in file browser settings
let g:netrw_banner = 0 "disable the useless header
"let g:netrw_liststyle = 3 "default to tree-style list of files
"let g:netrw_altv = 1
"let g:netrw_winsize = 25 "only use this percentage of the screen
" Start file browser automatically on the left
"augroup ProjectDrawer
"        autocmd!
"        autocmd VimEnter * :Vexplore
"augroup end

" Enable file type detection and do language-dependent indenting
filetype plugin indent on

" Filetype-specific settings for indentation
autocmd FileType javascript setlocal expandtab tabstop=4 sw=4 softtabstop=4
autocmd FileType html setlocal expandtab tabstop=2 sw=2 softtabstop=2

" Turn on spell checking for text files
autocmd BufNewFile,BufRead *.txt setlocal spell spelllang=en_gb

" Detect assembly
au BufRead,BufNewFile *.s set filetype=gas

" Hightlight from start of file
au BufEnter * :syntax sync fromstart

" Delete whitespace on save
autocmd BufWritePre * :%s/\s\+$//e


" Set a swap and backup location for all files
set directory=/home/james/.vim/swapfiles//
set backupdir=/home/james/.vim/backup//

" Tabs and spaces
set tabstop=4 " Displays TAB characters as 4 spaces
set softtabstop=4 " Insert 4 spaces when TAB is pressed
set expandtab " Turns TAB key into shortcut for 4 spaces

" Enable some indenting tweaks
set autoindent " Match previous indent on new line

" Set character encoding
set encoding=utf-8 " The encoding displayed on screen
set fileencoding=utf-8 " The encoding written to files

" Stop beeps on cursor errors
set visualbell
set noerrorbells

" Turn line numbering on
set number

" Show if text goes too far to the right
set colorcolumn=80

" Some tweaks for searching
"set ignorecase " Enable case-insensitive search
set smartcase " If there are upper-case letters become case-sensitive
set incsearch " Live incremental search
set hlsearch " highlight search terms
" Clear previous search highlight
nmap <silent> ,/ :nohlsearch<CR>

" Show statusline
set laststatus=2
" Show current mode
set showmode " Show insert, visual or replace mode in status
" Custom statusline
set statusline=
set statusline+=\ %F%m%r%h%w " Show filename and path
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%% " Percentage through file
set statusline+=\ %l\ %c " Line and character

" History and undo
set history=1000
set undolevels=1000

" Toggle auto indent to allow well formatted pasting
set pastetoggle=<F2>

" Make vim colours behave in tmux
" Setting background to dark makes vim use easier to read colours
" other setting prevents highlighting in Visual mode from breaking
"if exists("$TMUX")
"        set background=dark
"        :highlight Visual cterm=reverse ctermbg=NONE
"endif

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Make backspace like in other programs in insert mode
set backspace=indent,eol,start
