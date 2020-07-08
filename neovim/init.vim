scriptencoding utf-8
source ~/.config/nvim/plugins.vim

" ============================================================================ "
" ===                           EDITING OPTIONS                            === "
" ============================================================================ "

" Remap leader key to ,
let g:mapleader=','

" Don't show last command
set noshowcmd

" Yank and paste with the system clipboard
set clipboard=unnamedplus

" Hides buffers instead of closing them
set hidden

" === TAB/Space settings === "
" Insert spaces when TAB is pressed.
set expandtab

" Change number of spaces that a <Tab> counts for during editing ops
set softtabstop=2

" Indentation amount for < and > commands.
set shiftwidth=2

" do wrap long lines by default at margin 80
set wrap

" Don't highlight current cursor line
set nocursorline

" Disable line/column number in status line
" Shows up in preview window when airline is disabled if not
set noruler

" Only one line for command line
set cmdheight=1

" always show tab bar
set showtabline=2

" Set preview window to appear at bottom
set splitbelow

" Don't dispay mode in command line (airilne already shows it)
set noshowmode

" === Search === "
" ignore case when searching
set ignorecase

" if the search string has an upper case letter in it, the search will be case sensitive
set smartcase

" Automatically re-read file if a change was detected outside of vim
set autoread

" Enable line numbers
set number
set relativenumber

" Enable cursor line
set cursorline

" Set backups
if has('persistent_undo')
  set undofile
  set undolevels=3000
  set undoreload=10000
endif

set backupdir=~/.local/share/nvim/backup " Don't put backups in current dir
set backup
set noswapfile

set encoding=UTF-8
set fileencoding=utf-8

" ============================================================================ "
" ===                                UI                                    === "
" ============================================================================ "

" Enable true color support
set termguicolors
set guifont=JetBrains\ Mono:h13

" Editor theme
set background=dark

source ~/.config/nvim/colors.vim

let g:eleline_powerline_fonts = 1

let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]

autocmd FileType * RainbowParentheses

" === Completion Settings === "

" Don't give completion messages like 'match 1 of 2'
" or 'The only match'
set shortmess+=c

if has('nvim-0.3.2') || has("patch-8.1.0360")
  set diffopt=filler,internal,algorithm:histogram,indent-heuristic
endif

" coc.nvim color changes
hi! link CocErrorSign WarningMsg
hi! link CocWarningSign Number
hi! link CocInfoSign Type

" ============================================================================ "
" ===                           PLUGIN SETUP                               === "
" ============================================================================ "

" === Coc.nvim === "
" use <tab> for trigger completion and navigate to next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

let g:coc_status_error_sign = '•'
let g:coc_status_warning_sign = '•'

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

"Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

try
  call coc#add_extension(
        \ 'coc-marketplace')
  call coc#add_extension(
        \ 'coc-yank')
  call coc#add_extension(
        \ 'coc-todolist')
  call coc#add_extension(
        \ 'coc-terminal')
  call coc#add_extension(
        \ 'coc-smartf')
  call coc#add_extension(
        \ 'coc-snippets')
  call coc#add_extension(
        \ 'coc-pairs')
  call coc#add_extension(
        \ 'coc-lists')
  call coc#add_extension(
        \ 'coc-highlight')
  call coc#add_extension(
        \ 'coc-git')
  call coc#add_extension(
        \ 'coc-dictionary')
  call coc#add_extension(
        \ 'coc-bookmark')
  call coc#add_extension(
        \ 'coc-actions')
  call coc#add_extension(
        \ 'coc-json')
  call coc#add_extension(
        \ 'coc-html')
  call coc#add_extension(
        \ 'coc-css')
  call coc#add_extension(
        \ 'coc-eslint')
  call coc#add_extension(
        \ 'coc-yaml')
  call coc#add_extension(
        \ 'coc-tsserver')
  call coc#add_extension(
        \ 'coc-tslint-plugin')
  call coc#add_extension(
        \ 'coc-template')
  call coc#add_extension(
        \ 'coc-stylelint')
  call coc#add_extension(
        \ 'coc-sh')
  call coc#add_extension(
        \ 'coc-rust-analyzer')
  call coc#add_extension(
        \ 'coc-python')
  call coc#add_extension(
        \ 'coc-markdownlint')
  call coc#add_extension(
        \ 'coc-lit-html')
  call coc#add_extension(
        \ 'coc-julia')
  call coc#add_extension(
        \ 'coc-jest')
  call coc#add_extension(
        \ 'coc-floaterm')
  call coc#add_extension(
        \ 'coc-emmet')
  call coc#add_extension(
        \ 'coc-docthis')
  call coc#add_extension(
        \ 'coc-docker')
  call coc#add_extension(
        \ 'coc-deno')
  call coc#add_extension(
        \ 'coc-db')
  call coc#add_extension(
        \ 'coc-explorer')
catch
  echo 'coc.vim not installed. It should work after running :PlugInstall'
endtry

"Close preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" lightline integration of coc status
function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

" === echodoc === "
" Enable echodoc on startup
let g:echodoc#enable_at_startup = 1

" === lsp outline view === "
let g:vista_default_executive = 'coc'
let g:vista_icon_indent = ["▸ ", ""]
let g:vista_fzf_preview = ['right:33%']

" ============================================================================ "
" ===                             KEY MAPPINGS                             === "
" ============================================================================ "

" visual lines navigation
noremap <silent> k gk
noremap <silent> j gj
noremap <silent> 0 g0
noremap <silent> $ g$

" buffer navigation
nmap <silent> <Tab> :bnext<CR>
nmap <silent> <S-Tab> :bprevious<CR>
nmap <silent> <leader>q :bdelete<CR>
nmap <silent> <C-h> <C-w>h
nmap <silent> <C-j> <C-w>j
nmap <silent> <C-k> <C-w>k
nmap <silent> <C-l> <C-w>l

" terminal
tnoremap <Esc> <C-\><C-n>
nmap <silent> <leader>t :<C-u>CocCommand terminal.Toggle<cr>

" fuzzy search
nmap <silent> <leader>f :<C-u>CocList files<cr>
nmap <silent> <leader>b :<C-u>CocList buffers<cr>

"  <leader>n - Toggle Explorer on/off
nmap <silent> <leader>n :CocCommand explorer<CR>
autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif

" === Vista === "
nmap <silent> <leader>o :Vista!!<CR>

" === coc.nvim === "
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> dj <Plug>(coc-diagnostic-prev)
nmap <silent> dk <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>p  <Plug>(coc-format-selected)
nmap <leader>p  <Plug>(coc-format-selected)

" Remap for do codeAction of current line
nmap <silent> <leader>ac :<C-u>CocCommand actions.open<cr>

" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" === Search shorcuts === "
"   <leader>h - Find and replace
"   <leader>/ - Clear highlighted search terms while preserving history
map <leader>h :%s///<left><left>
nmap <silent> <leader>/ :nohlsearch<CR>

" === Easy-motion shortcuts ==="
"   <leader>w - Easy-motion highlights first word letters bi-directionally
map <leader>w <Plug>(easymotion-bd-w)

" Allows you to save files you opened without write permissions via sudo
cmap w!! w !sudo tee %

" git diff hunk preview
nmap <leader>g :GitGutterPreviewHunk<CR>
nmap <space>g :FloatermNew gitui<CR>

nmap <space>r :RnvimrToggle<CR>

" Make Ranger replace Netrw and be the file explorer
let g:rnvimr_ex_enable = 1

" Make Ranger to be hidden after picking a file
let g:rnvimr_pick_enable = 1

let g:rnvimr_draw_border = 1

" Make Neovim wipe the buffers corresponding to the files deleted by Ranger
let g:rnvimr_bw_enable = 1

nmap <space>t :FloatermToggle<CR>
nmap <space>m :FloatermNew aerc<CR>
