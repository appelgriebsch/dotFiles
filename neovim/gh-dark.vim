try
let g:gh_color = 'soft'
colorscheme ghdark
catch
  echo 'GitHub Dark is not installed. It should work after running :PlugInstall'
endtry

let g:lightline = {
\ 'colorscheme': 'ghdark',
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