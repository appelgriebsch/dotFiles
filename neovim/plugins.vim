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
    autocmd VimEnter * PlugInstall
    autocmd VimEnter * PlugInstall | source $MYVIMRC
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

" Async Tasks
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'

" Intellisense Engine
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Test runner
Plug 'vim-test/vim-test'

" Print function signatures in echo area
Plug 'Shougo/echodoc.vim'

" lsp based outline and symbols
Plug 'liuchengxu/vista.vim'

" === Git Plugins === "
" Enable git changes to be shown in sign column
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'APZelos/blamer.nvim'

" Syntax highlighting for different languages
Plug 'sheerun/vim-polyglot'

" better start screen
Plug 'mhinz/vim-startify'

" rust crates
Plug 'mhinz/vim-crates'

" floating terminal and file manager
Plug 'voldikss/vim-floaterm'
Plug 'kevinhwang91/rnvimr'
Plug 'rbgrouleff/bclose.vim'

" Database
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'

" === UI === "

" Nerd Icons
Plug 'ryanoasis/vim-devicons'

" Customized vim status line
Plug 'itchyny/lightline.vim'
Plug 'josa42/vim-lightline-coc'
Plug 'APZelos/gitline.vim'

" enhanced terminal features
Plug 'kassio/neoterm'

" Rainbow parantheses
Plug 'junegunn/rainbow_parentheses.vim'

" ijq playground
Plug 'bfrg/vim-jqplay'

" vim clap
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }
Plug 'vn-ki/coc-clap'

" Initialize plugin system
call plug#end()
