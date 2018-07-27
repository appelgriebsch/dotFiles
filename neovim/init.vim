" Preamble ---------------------------------------------------------------- {{{

set nocompatible              " be iMproved
filetype off                  " required!

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim')

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'powershell -executionpolicy bypass -File install.ps1',
    \ }

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/denite.nvim'
Plug 'Shougo/echodoc.vim'

" git support
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" status lines
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" color theme bundles
Plug 'morhetz/gruvbox'

call plug#end()

" Basic options ----------------------------------------------------------- {{{
"language eng_US
syntax on                     " syntax highlighing
filetype on                   " try to detect filetypes
filetype plugin indent on     " enable loading indent file for filetype
set nocompatible
set langmenu=en_US.UTF8
set helplang=en
set encoding=utf-8
set modelines=0
set autoindent
set showmode
set showcmd
set hidden
set visualbell
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set statusline=[%l,%v\ %P%M]\ %f\ %r%h%w\ (%{&ff})\ %{fugitive#statusline()}
set history=1000
set undofile
set undoreload=10000
set list
set listchars=tab:▸\ ,eol:¬,extends:›,precedes:‹
set lazyredraw
set matchtime=3
set splitbelow
set splitright
set fillchars=diff:░,vert:│
set shiftround
set title
set linebreak
set colorcolumn=+1
set number
set numberwidth=1             " using only 1 column (and 1 space) while possible
set norelativenumber
set noautowrite             " Never write a file unless I request it.
set noautowriteall          " NEVER.
set noautoread              " Don't automatically re-read changed files.
set modeline                " Allow vim options to be embedded in files;
set modelines=5             " they must be within the first or last 5 lines.
set ffs=unix,dos,mac        " Try recognizing dos, unix, and mac line endings.
set confirm                 " Y-N-C prompt if closing with unsaved changes.
set showcmd                 " Show incomplete normal mode commands as I type.
set report=0                " : commands always print changed line count.
set shortmess+=a            " Use [+]/[RO]/[w] for modified/readonly/written.
set ruler                   " Show some info, even without statuslines.
set cursorline

" Don't try to highlight lines longer than 800 characters.
set synmaxcol=800

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
set notimeout
set ttimeout
set ttimeoutlen=10

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

" Better Completion
set complete=.,w,b,u,t
set completeopt=longest,menuone,preview

" Save when losing focus
au FocusLost * :silent! wall

" Resize splits when the window is resized
au VimResized * :wincmd =

" Always draw sign column. Prevent buffer moving when adding/deleting sign.
set signcolumn=yes
set noshowmode
" }}}

" Cursorline {{{
" Only show cursorline in the current window and in normal mode.
augroup cline
    au!
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave * set cursorline
augroup END
" }}}

" Tabs, spaces, wrapping {{{
set tabstop=4
set shiftwidth=2
set softtabstop=2
set expandtab
set wrap
set textwidth=80
set formatoptions=qrn1
set colorcolumn=+1
" }}}

" Backups {{{
set nobackup                      " disable backups
set nowritebackup
set noswapfile                    " It's 2012, Vim.
" }}}

" Leader {{{
let mapleader = ","
let maplocalleader = "\\"
" }}}

" Color scheme {{{
syntax on
set background=dark
set guifont=Source\ Code\ Pro:h14
colorscheme gruvbox
" }}}

" Searching and movement -------------------------------------------------- {{{
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
set gdefault
set scrolloff=3
set sidescroll=1
set sidescrolloff=10
set smarttab                " Handle tabs more intelligently
set virtualedit+=block
set ruler                   " show the cursor position all the time
set nostartofline           " Avoid moving cursor to BOL when jumping around
set backspace=2             " Allow backspacing over autoindent, EOL, and BOL
set linebreak               " don't wrap textin the middle of a word
set autoindent              " always set autoindenting on
set smartindent             " use smart indent if there is no indent file
set shiftround              " rounds indent to a multiple of shiftwidth
set matchpairs+=<:>         " show matching <> (html mainly) as well

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz
nnoremap <c-o> <c-o>zz

" Easier to type, and I never use the default behavior.
noremap H ^
noremap L $
vnoremap L g_

" Heresy
inoremap <c-a> <esc>I
inoremap <c-e> <esc>A

" It's 2012.
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Easy buffer navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

noremap <leader>v <C-w>v
noremap <leader>h <C-w>s

" easy window resizing
noremap <C-w>j <C-w>-
noremap <C-w>k <C-w>+
noremap <C-w>h <C-w><
noremap <C-w>l <C-w>>

" easy command execution
cnoremap <C-r> <C-r>"

" Folding ----------------------------------------------------------------- {{{
set foldlevelstart=99
set foldmethod=indent       " allow us to fold on indents
set foldlevel=99            " don't fold by default

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
nnoremap zO zCzO
" }}}

" }}}

" Convenience mappings ---------------------------------------------------- {{{
" Tabs
nnoremap <leader>< :bprev<cr>
nnoremap <leader>> :bnext<cr>

" Select entire buffer
nnoremap vaa ggvGg_
nnoremap Vaa ggVG

" open/close the quickfix window
nmap <leader>c :copen<CR>
nmap <leader>cl :cclose<CR>

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

" Paste from clipboard
map <leader>p "+p

" Quit window on <leader>q
nnoremap <leader>q :bd<CR>

" hide matches on <leader>space
nnoremap <leader><space> :nohlsearch<cr>

" }}}

" Plugin settings --------------------------------------------------------- {{{

augroup filetype_rust
    autocmd!
    autocmd BufReadPost *.rs setlocal filetype=rust
augroup END

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
\ }

let g:deoplete#enable_at_startup = 1
let g:python3_host_prog = "C:/ProgramData/Python37/python.exe"
let g:python_host_prog = "C:/ProgramData/Python27/python.exe"

" status line (airline)
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'powerlineish'

" tmux line
let g:tmuxline_preset = 'powerline'
let g:tmuxline_theme = 'powerline'
let g:tmuxline_separators = {
    \ 'left' : '',
    \ 'left_alt': '>',
    \ 'right' : '',
    \ 'right_alt' : '<',
    \ 'space' : ' '}

" }}}
