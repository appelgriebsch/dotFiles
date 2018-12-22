" Specify a directory for plugins
call plug#begin('~/.local/share/nvim/extensions')

" Make sure you use single quotes
Plug 'ayu-theme/ayu-vim'

Plug 'natebosch/vim-lsc'

" Initialize plugin system
call plug#end()

set termguicolors     " enable true colors support
" let ayucolor="light"  " for light version of theme
let ayucolor="mirage" " for mirage version of theme
" let ayucolor="dark"   " for dark version of theme
colorscheme ayu

let g:lsc_server_commands = {
\  'typescript': 'typescript-language-server --stdio',
\  'javascript': 'typescript-language-server --stdio',
\  'rust': 'rustup run stable rls',
\  'go': 'go-langserver -gocodecompletion'
\ }
