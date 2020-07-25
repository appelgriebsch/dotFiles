try
colorscheme base16-atelier-lakeside
catch
  echo 'Base16 Vim not installed. It should work after running :PlugInstall'
endtry

let g:lightline = {
\ 'colorscheme': 'base16_atelier_lakeside',
\ 'active': {
\   'left': [ [ 'mode', 'paste' ],
\             [ 'readonly', 'branchname', 'fetchstatus', 'filecount', 'filename', 'coc_errors', 'coc_warnings', 'coc_ok' ],
\             [ 'coc_status'  ] ]
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
