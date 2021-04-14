try
colorscheme base16-matcha-green
catch
  echo 'Base16 Vim not installed. It should work after running :PlugInstall'
endtry

let g:lightline = {
\ 'colorscheme': 'base16_matcha_green',
\ 'active': {
\   'left': [ [ 'mode', 'paste' ],
\             [ 'readonly', 'branchname', 'fetchstatus', 'filecount', 'filename' ] ] ,
\   'right': [ [ 'lineinfo' ],
\              [ 'percent' ],
\              [ 'fileformat', 'fileencoding', 'filetype' ] ]
\ },
\ 'component_function': {
\   'filecount': 'gitline#FileCount',
\   'branchname': 'gitline#BranchName',
\   'filestatus': 'gitline#FileStatus',
\   'fetchstatus': 'gitline#FetchStatus'
\ },
\}

" register compoments:
call lightline#coc#register()
