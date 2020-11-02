" Use Vim settings, rather than Vi settings
" This must be first, because it changes other options as a side effect
set nocompatible

call plug#begin()

Plug 'sainnhe/sonokai'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf.vim'
Plug 'sdiehl/vim-ormolu'

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

" Use main clipboard
set clipboard+=unnamed

" Use True Color
set termguicolors

" Set the leader key to space
let mapleader="\<Space>"

" NERDTREE

" Open nerdtree browser
map <C-n> :NERDTreeToggle<CR>

let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''

" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" BUILT IN TERMINAL
" open new split panes to right and below
set splitright
set splitbelow
" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>
" start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
" open terminal on ctrl+n
function! OpenTerminal()
  split term://bash
  resize 10
endfunction
nnoremap <c-m> :call OpenTerminal()<CR>

" FZF

" CTRL-P to launch in current directory
nnoremap <C-p> :FZF<CR>

" key binds for opening actions
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}

" Reload vimrc on \r
map <leader>s :source ~/.config/nvim/init.vim<CR>

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

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

" Statusline colour definitions
hi WhiteHighlight guifg=Black guibg=White ctermfg=Black ctermbg=White
hi GrayHighlight guifg=Black guibg=DarkGray ctermfg=Black ctermbg=DarkGray
hi BlackHighlight guifg=Black guibg=LightGray ctermfg=Black ctermbg=LightGray

" Statusline
set laststatus=2 " always show
set statusline= " begin content
set statusline+=%#WhiteHighlight# " colour
set statusline+=%{StatuslineGit()} " current git branch
set statusline+=%#GrayHighlight# " colour
set statusline+=\ %2n\  " buffer number
set statusline+=%#CursorColumn# " colour
set statusline+=\ %t " filename
set statusline+=%= " right align
set statusline+=\ %y\  " file type
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}\  " file encoding
set statusline+=%#WhiteHighlight# " colour
set statusline+=\ %3l:%-2c " Line and character
set statusline+=\ %3p%%\  " percentage through file
