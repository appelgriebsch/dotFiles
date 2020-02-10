" ============================================================================ "
" ===                               PLUGINS                                === "
" ============================================================================ "

" check whether vim-plug is installed and install it if necessary
let plugpath = expand('<sfile>:p:h'). '/autoload/plug.vim'
if !filereadable(plugpath)
    if executable('curl')
        let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        call system('curl -fLo ' . shellescape(plugpath) . ' --create-dirs ' . plugurl)
        if v:shell_error
            echom "Error downloading vim-plug. Please install it manually.\n"
            exit
        endif
    else
        echom "vim-plug not installed. Please install it manually or install curl.\n"
        exit
    endif
endif

" Specify a directory for plugins
" - For Neovim: ~/.config/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/extensions')

" === Editing Plugins === "
" Trailing whitespace highlighting & automatic fixing
Plug 'ntpeters/vim-better-whitespace'

" EditorConfig support
Plug 'editorconfig/editorconfig-vim'

" Improved motion in Vim
Plug 'easymotion/vim-easymotion'

" Intellisense Engine
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Print function signatures in echo area
Plug 'Shougo/echodoc.vim'

" lsp based outline and symbols
Plug 'liuchengxu/vista.vim'

" === Git Plugins === "
" Enable git changes to be shown in sign column
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

" Syntax highlighting for different languages
Plug 'sheerun/vim-polyglot'

" better start screen
Plug 'mhinz/vim-startify'

" database
Plug 'vim-scripts/dbext.vim'

" rust crates
Plug 'mhinz/vim-crates'

" === UI === "

" color themes
Plug 'ayu-theme/ayu-vim'

" Customized vim status line
Plug 'itchyny/lightline.vim'

" enhanced terminal features
Plug 'kassio/neoterm'

" Icons
Plug 'ryanoasis/vim-devicons'

" Initialize plugin system
call plug#end()
